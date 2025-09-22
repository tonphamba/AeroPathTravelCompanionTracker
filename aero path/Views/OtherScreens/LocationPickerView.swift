import SwiftUI
import MapKit
import CoreLocation

struct LocationPickerView: View {
    @Binding var selectedCoordinate: CLLocationCoordinate2D
    @Binding var selectedLocationName: String
    @State private var region: MKCoordinateRegion
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching = false
    @Environment(\.dismiss) private var dismiss
    
    init(selectedCoordinate: Binding<CLLocationCoordinate2D>, selectedLocationName: Binding<String>) {
        self._selectedCoordinate = selectedCoordinate
        self._selectedLocationName = selectedLocationName
        self._region = State(initialValue: MKCoordinateRegion(
            center: selectedCoordinate.wrappedValue,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                searchBar
                
                // Map
                mapView
                
                // Search results
                if !searchResults.isEmpty {
                    searchResultsList
                }
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Select") {
                        selectedCoordinate = region.center
                        selectedLocationName = searchText.isEmpty ? "Selected Location" : searchText
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search for a place...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .onSubmit {
                    searchForLocation()
                }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    searchResults = []
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private var mapView: some View {
        Map(coordinateRegion: $region, annotationItems: [MapAnnotation(coordinate: region.center)]) { annotation in
            MapPin(coordinate: annotation.coordinate, tint: .red)
        }
        .onTapGesture { location in
            let coordinate = region.center
            region.center = coordinate
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    // Update region center based on drag
                    let newCenter = CLLocationCoordinate2D(
                        latitude: region.center.latitude - value.translation.height * 0.0001,
                        longitude: region.center.longitude + value.translation.width * 0.0001
                    )
                    region.center = newCenter
                }
        )
    }
    
    private var searchResultsList: some View {
        List(searchResults, id: \.self) { item in
            Button(action: {
                selectLocation(item)
            }) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name ?? "Unknown")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(item.placemark.title ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(maxHeight: 200)
    }
    
    private func searchForLocation() {
        guard !searchText.isEmpty else { return }
        
        isSearching = true
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                isSearching = false
                if let response = response {
                    searchResults = response.mapItems
                }
            }
        }
    }
    
    private func selectLocation(_ item: MKMapItem) {
        let coordinate = item.placemark.coordinate
        region.center = coordinate
        searchText = item.name ?? ""
        searchResults = []
    }
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    LocationPickerView(
        selectedCoordinate: .constant(CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
        selectedLocationName: .constant("San Francisco")
    )
}
