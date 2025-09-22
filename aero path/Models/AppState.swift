import Foundation

enum AppState: Equatable {
    case loading
    case loaded
    case error(String)
}

enum SortOption: String, CaseIterable {
    case dateNewest = "Date (Newest)"
    case dateOldest = "Date (Oldest)"
    case rating = "Rating"
    case name = "Name"
    case country = "Country"
}

enum FilterOption: String, CaseIterable {
    case all = "All"
    case favorites = "Favorites"
    case highRated = "High Rating (4-5)"
    case recent = "Last Month"
}
