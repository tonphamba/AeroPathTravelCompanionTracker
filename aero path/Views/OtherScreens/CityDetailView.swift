import SwiftUI
import MapKit

struct CityDetailView: View {
    @State var viewModel: AeroPathViewModel
    let city: City
    @State private var region: MKCoordinateRegion
    @State private var showingEditSheet = false
    
    init(viewModel: AeroPathViewModel, city: City) {
        self.viewModel = viewModel
        self.city = city
        self._region = State(initialValue: MKCoordinateRegion(
            center: city.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with city info
                headerView
                
                // Map
                mapView
                
                // Rating and visit date
                ratingAndDateView
                
                // Notes
                if !city.notes.isEmpty {
                    notesView
                }
                
                // Photos
                photosView
                
                // Stats
                statsView
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingEditSheet = true }) {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddEditCityView(viewModel: viewModel, city: city)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            // City name and country
            VStack(spacing: 8) {
                Text(city.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(city.country)
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            
            // Favorite button
            Button(action: { viewModel.toggleFavorite(city) }) {
                HStack(spacing: 8) {
                    Image(systemName: city.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(city.isFavorite ? .red : .gray)
                    
                    Text(city.isFavorite ? "In Favorites" : "Add to Favorites")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(city.isFavorite ? Color.red.opacity(0.1) : Color(.systemGray6))
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.top, 20)
    }
    
    private var mapView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Location")
                .font(.headline)
                .fontWeight(.semibold)
            
            Map(coordinateRegion: $region, annotationItems: [city]) { city in
                MapPin(coordinate: city.coordinate, tint: .red)
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var ratingAndDateView: some View {
        HStack(spacing: 24) {
            // Rating
            VStack(alignment: .leading, spacing: 8) {
                Text("Рейтинг")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= city.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.title3)
                    }
                }
            }
            
            Spacer()
            
            // Visit date
            VStack(alignment: .trailing, spacing: 8) {
                Text("Дата посещения")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(city.formattedVisitDate)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private var notesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Заметки")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(city.notes)
                .font(.body)
                .foregroundColor(.primary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
        }
    }
    
    private var photosView: some View {
        PhotoGalleryView(
            photos: city.photos,
            onAddPhoto: {
                // TODO: Implement photo addition
            },
            onDeletePhoto: { photo in
                // TODO: Implement photo deletion
            }
        )
    }
    
    private var statsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Статистика")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 16) {
                StatItem(
                    title: "Координаты",
                    value: "\(String(format: "%.4f", city.coordinate.latitude)), \(String(format: "%.4f", city.coordinate.longitude))",
                    icon: "location"
                )
                
                StatItem(
                    title: "Фотографий",
                    value: "\(city.photos.count)",
                    icon: "photo"
                )
            }
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    NavigationView {
        CityDetailView(
            viewModel: AeroPathViewModel(),
            city: City(
                name: "Париж",
                country: "Франция",
                latitude: 48.8566,
                longitude: 2.3522,
                rating: 5,
                notes: "Невероятный город! Эйфелева башня просто потрясающая.",
                isFavorite: true
            )
        )
    }
    .preferredColorScheme(.dark)
}
