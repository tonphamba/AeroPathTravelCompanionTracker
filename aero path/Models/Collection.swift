import Foundation
import SwiftUI

struct Collection: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let color: CollectionColor
    let cityIds: [UUID]
    let createdDate: Date
    let isDefault: Bool
    
    init(name: String, description: String = "", color: CollectionColor = .blue, cityIds: [UUID] = [], isDefault: Bool = false) {
        self.name = name
        self.description = description
        self.color = color
        self.cityIds = cityIds
        self.createdDate = Date()
        self.isDefault = isDefault
    }
    
    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdDate)
    }
}

enum CollectionColor: String, CaseIterable, Codable {
    case blue = "blue"
    case red = "red"
    case green = "green"
    case orange = "orange"
    case purple = "purple"
    case pink = "pink"
    case yellow = "yellow"
    case indigo = "indigo"
    
    var color: Color {
        switch self {
        case .blue: return .blue
        case .red: return .red
        case .green: return .green
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return .pink
        case .yellow: return .yellow
        case .indigo: return .indigo
        }
    }
    
    var name: String {
        switch self {
        case .blue: return "Blue"
        case .red: return "Red"
        case .green: return "Green"
        case .orange: return "Orange"
        case .purple: return "Purple"
        case .pink: return "Pink"
        case .yellow: return "Yellow"
        case .indigo: return "Indigo"
        }
    }
}
