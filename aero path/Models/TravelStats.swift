import Foundation

struct TravelStats: Codable {
    let totalCities: Int
    let totalCountries: Int
    let averageRating: Double
    let favoriteCity: String?
    let mostVisitedCountry: String?
    let totalDistance: Double // in kilometers
    let visitStreak: Int // consecutive days with visits
    let lastVisitDate: Date?
    
    init(cities: [City]) {
        self.totalCities = cities.count
        self.totalCountries = Set(cities.map { $0.country }).count
        self.averageRating = cities.isEmpty ? 0 : cities.map { Double($0.rating) }.reduce(0, +) / Double(cities.count)
        
        // Find favorite city (highest rated)
        self.favoriteCity = cities.max { $0.rating < $1.rating }?.name
        
        // Find most visited country
        let countryCounts = Dictionary(grouping: cities, by: { $0.country })
            .mapValues { $0.count }
        self.mostVisitedCountry = countryCounts.max { $0.value < $1.value }?.key
        
        // Calculate total distance (simplified - straight line distances)
        let calculatedDistance = Self.calculateTotalDistance(cities: cities)
        self.totalDistance = calculatedDistance
        
        // Calculate visit streak
        let calculatedStreak = Self.calculateVisitStreak(cities: cities)
        self.visitStreak = calculatedStreak
        
        // Last visit date
        self.lastVisitDate = cities.map { $0.visitDate }.max()
    }
    
    private static func calculateTotalDistance(cities: [City]) -> Double {
        guard cities.count > 1 else { return 0 }
        
        var totalDistance: Double = 0
        let sortedCities = cities.sorted { $0.visitDate < $1.visitDate }
        
        for i in 0..<sortedCities.count - 1 {
            let distance = Self.distance(
                from: sortedCities[i].coordinate,
                to: sortedCities[i + 1].coordinate
            )
            totalDistance += distance
        }
        
        return totalDistance
    }
    
    private static func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let location2 = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return location1.distance(from: location2) / 1000 // Convert to kilometers
    }
    
    private static func calculateVisitStreak(cities: [City]) -> Int {
        guard !cities.isEmpty else { return 0 }
        
        let sortedDates = cities.map { $0.visitDate }.sorted { $0 > $1 }
        var streak = 0
        let calendar = Calendar.current
        
        for i in 0..<sortedDates.count {
            if i == 0 {
                streak = 1
            } else {
                let daysBetween = calendar.dateComponents([.day], from: sortedDates[i], to: sortedDates[i-1]).day ?? 0
                if daysBetween <= 1 {
                    streak += 1
                } else {
                    break
                }
            }
        }
        
        return streak
    }
}

import CoreLocation
