import SwiftUI
import CoreLocation
import MapKit

struct AddEditCityView: View {
    @State var viewModel: AeroPathViewModel
    let city: City?
    
    @State private var name = ""
    @State private var country = ""
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var visitDate = Date()
    @State private var rating = 5
    @State private var notes = ""
    @State private var isFavorite = false
    @State private var showingLocationPicker = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var selectedLocationName = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var isEditMode: Bool {
        city != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Basic Information") {
                    TextField("City Name", text: $name)
                    TextField("Country", text: $country)
                }
                
                Section("Coordinates") {
                    HStack {
                        TextField("Latitude", text: $latitude)
                            .keyboardType(.decimalPad)
                        
                        TextField("Longitude", text: $longitude)
                            .keyboardType(.decimalPad)
                    }
                    
                    Button("Select on Map") {
                        showingLocationPicker = true
                    }
                    .foregroundColor(.blue)
                    
                    if !selectedLocationName.isEmpty {
                        Text("Selected: \(selectedLocationName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Visit Date") {
                    DatePicker("Date", selection: $visitDate, displayedComponents: .date)
                }
                
                Section("Rating") {
                    HStack {
                        Text("Rating")
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { star in
                                Button(action: { rating = star }) {
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.title3)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                
                Section("Additional") {
                    Toggle("Favorite", isOn: $isFavorite)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $notes)
                            .frame(minHeight: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                }
            }
            .navigationTitle(isEditMode ? "Edit City" : "Add City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditMode ? "Save" : "Add") {
                        saveCity()
                    }
                    .disabled(!isValidInput)
                }
            }
            .onAppear {
                setupInitialValues()
            }
            .sheet(isPresented: $showingLocationPicker) {
                LocationPickerView(
                    selectedCoordinate: Binding(
                        get: {
                            if let lat = Double(latitude), let lon = Double(longitude) {
                                return CLLocationCoordinate2D(latitude: lat, longitude: lon)
                            }
                            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
                        },
                        set: { coordinate in
                            latitude = String(format: "%.6f", coordinate.latitude)
                            longitude = String(format: "%.6f", coordinate.longitude)
                        }
                    ),
                    selectedLocationName: $selectedLocationName
                )
            }
            .alert("Ошибка", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private var isValidInput: Bool {
        !name.isEmpty && !country.isEmpty && !latitude.isEmpty && !longitude.isEmpty
    }
    
    private func setupInitialValues() {
        if let city = city {
            name = city.name
            country = city.country
            latitude = String(city.coordinate.latitude)
            longitude = String(city.coordinate.longitude)
            visitDate = city.visitDate
            rating = city.rating
            notes = city.notes
            isFavorite = city.isFavorite
        }
    }
    
    private func saveCity() {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else {
            alertMessage = "Пожалуйста, введите корректные координаты"
            showingAlert = true
            return
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let newCity = City(
            name: name,
            country: country,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            visitDate: visitDate,
            rating: rating,
            notes: notes,
            photos: city?.photos ?? [],
            isFavorite: isFavorite
        )
        
        if isEditMode {
            viewModel.updateCity(newCity)
        } else {
            viewModel.addCity(newCity)
        }
        
        dismiss()
    }
}


#Preview {
    AddEditCityView(viewModel: AeroPathViewModel(), city: nil)
        .preferredColorScheme(.dark)
}
