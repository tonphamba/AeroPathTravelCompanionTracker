import Foundation
import SwiftUI
import CoreLocation

@MainActor
@Observable
class AeroPathViewModel {
    // MARK: - Properties
    var cities: [City] = []
    var filteredCities: [City] = []
    var appState: AppState = .loading
    var selectedCity: City?
    var isShowingAddCity = false
    var isShowingEditCity = false
    var isShowingAnalytics = false
    var isShowingProfile = false
    var searchText = ""
    var selectedSortOption: SortOption = .dateNewest
    var selectedFilterOption: FilterOption = .all
    var selectedTab = 0
    
    // MARK: - Computed Properties
    var travelStats: TravelStats {
        TravelStats(cities: cities)
    }
    
    var favoriteCities: [City] {
        cities.filter { $0.isFavorite }
    }
    
    var recentCities: [City] {
        let calendar = Calendar.current
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        return cities.filter { $0.visitDate >= thirtyDaysAgo }
    }
    
    // MARK: - Initialization
    init() {
        loadCities()
    }
    
    // MARK: - Data Management
    func loadCities() {
        appState = .loading
        
        // Load sample data for demonstration
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.cities = self.getSampleCities()
            self.applyFiltersAndSort()
            self.appState = .loaded
        }
    }
    
    func addCity(_ city: City) {
        cities.append(city)
        applyFiltersAndSort()
        saveCities()
    }
    
    func updateCity(_ city: City) {
        if let index = cities.firstIndex(where: { $0.id == city.id }) {
            cities[index] = city
            applyFiltersAndSort()
            saveCities()
        }
    }
    
    func deleteCity(_ city: City) {
        cities.removeAll { $0.id == city.id }
        applyFiltersAndSort()
        saveCities()
    }
    
    func toggleFavorite(_ city: City) {
        if let index = cities.firstIndex(where: { $0.id == city.id }) {
            cities[index] = City(
                name: cities[index].name,
                country: cities[index].country,
                latitude: cities[index].coordinate.latitude,
                longitude: cities[index].coordinate.longitude,
                visitDate: cities[index].visitDate,
                rating: cities[index].rating,
                notes: cities[index].notes,
                photos: cities[index].photos,
                isFavorite: !cities[index].isFavorite
            )
            applyFiltersAndSort()
            saveCities()
        }
    }
    
    // MARK: - Filtering and Sorting
    func applyFiltersAndSort() {
        var filtered = cities
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { city in
                city.name.localizedCaseInsensitiveContains(searchText) ||
                city.country.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply category filter
        switch selectedFilterOption {
        case .all:
            break
        case .favorites:
            filtered = filtered.filter { $0.isFavorite }
        case .highRated:
            filtered = filtered.filter { $0.rating >= 4 }
        case .recent:
            let calendar = Calendar.current
            let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()
            filtered = filtered.filter { $0.visitDate >= thirtyDaysAgo }
        }
        
        // Apply sorting
        switch selectedSortOption {
        case .dateNewest:
            filtered = filtered.sorted { $0.visitDate > $1.visitDate }
        case .dateOldest:
            filtered = filtered.sorted { $0.visitDate < $1.visitDate }
        case .rating:
            filtered = filtered.sorted { $0.rating > $1.rating }
        case .name:
            filtered = filtered.sorted { $0.name < $1.name }
        case .country:
            filtered = filtered.sorted { $0.country < $1.country }
        }
        
        filteredCities = filtered
    }
    
    // MARK: - UI Actions
    func selectCity(_ city: City) {
        selectedCity = city
    }
    
    func showAddCity() {
        isShowingAddCity = true
    }
    
    func showEditCity(_ city: City) {
        selectedCity = city
        isShowingEditCity = true
    }
    
    func showAnalytics() {
        isShowingAnalytics = true
    }
    
    func showProfile() {
        isShowingProfile = true
    }
    
    func dismissModals() {
        isShowingAddCity = false
        isShowingEditCity = false
        isShowingAnalytics = false
        isShowingProfile = false
        selectedCity = nil
    }
    
    // MARK: - Search
    func searchTextChanged(_ text: String) {
        searchText = text
        applyFiltersAndSort()
    }
    
    func sortOptionChanged(_ option: SortOption) {
        selectedSortOption = option
        applyFiltersAndSort()
    }
    
    func filterOptionChanged(_ option: FilterOption) {
        selectedFilterOption = option
        applyFiltersAndSort()
    }
    
    // MARK: - Data Persistence
    private func saveCities() {
        // In a real app, this would save to Core Data or UserDefaults
        // For now, we'll just keep data in memory
    }
    
    // MARK: - Sample Data
    private func getSampleCities() -> [City] {
        return [
            City(name: "Paris", country: "France", latitude: 48.8566, longitude: 2.3522, visitDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), rating: 5, notes: "Incredible city! The Eiffel Tower is simply amazing.", photos: [], isFavorite: true),
            City(name: "Tokyo", country: "Japan", latitude: 35.6762, longitude: 139.6503, visitDate: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date(), rating: 5, notes: "Futuristic city with amazing culture.", photos: [], isFavorite: true),
            City(name: "New York", country: "USA", latitude: 40.7128, longitude: -74.0060, visitDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(), rating: 4, notes: "The city that never sleeps.", photos: [], isFavorite: false),
            City(name: "London", country: "United Kingdom", latitude: 51.5074, longitude: -0.1278, visitDate: Calendar.current.date(byAdding: .day, value: -45, to: Date()) ?? Date(), rating: 4, notes: "Classic beauty and history.", photos: [], isFavorite: true),
            City(name: "Sydney", country: "Australia", latitude: -33.8688, longitude: 151.2093, visitDate: Calendar.current.date(byAdding: .day, value: -60, to: Date()) ?? Date(), rating: 5, notes: "Opera House and harbor - unforgettable!", photos: [], isFavorite: false),
            City(name: "Rome", country: "Italy", latitude: 41.9028, longitude: 12.4964, visitDate: Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date(), rating: 5, notes: "Eternal city with incredible history.", photos: [], isFavorite: true),
            City(name: "Barcelona", country: "Spain", latitude: 41.3851, longitude: 2.1734, visitDate: Calendar.current.date(byAdding: .day, value: -120, to: Date()) ?? Date(), rating: 4, notes: "Gaudi and the sea - perfect combination.", photos: [], isFavorite: false),
            City(name: "Amsterdam", country: "Netherlands", latitude: 52.3676, longitude: 4.9041, visitDate: Calendar.current.date(byAdding: .day, value: -150, to: Date()) ?? Date(), rating: 4, notes: "Canals and bicycles - unique experience.", photos: [], isFavorite: true)
        ]
    }
}
