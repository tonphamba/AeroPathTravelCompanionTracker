import Foundation
import CoreLocation

struct City: Identifiable, Codable {
    let id = UUID()
    let name: String
    let country: String
    let coordinate: CLLocationCoordinate2D
    let visitDate: Date
    let rating: Int // 1-5 stars
    let notes: String
    let photos: [PhotoData] // Photo data
    let isFavorite: Bool
    
    init(name: String, country: String, latitude: Double, longitude: Double, visitDate: Date = Date(), rating: Int = 5, notes: String = "", photos: [PhotoData] = [], isFavorite: Bool = false) {
        self.name = name
        self.country = country
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.visitDate = visitDate
        self.rating = max(1, min(5, rating))
        self.notes = notes
        self.photos = photos
        self.isFavorite = isFavorite
    }
    
    var fullName: String {
        "\(name), \(country)"
    }
    
    var formattedVisitDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: visitDate)
    }
}

// Custom Codable implementation for CLLocationCoordinate2D
extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    private enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
}