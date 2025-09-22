import SwiftUI
import Charts

struct AnalyticsView: View {
    @State var viewModel: AeroPathViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with stats
                    headerStatsView
                    
                    // Charts
                    chartsView
                    
                    // Detailed stats
                    detailedStatsView
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Export") {
                        // TODO: Show export view
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var headerStatsView: some View {
        VStack(spacing: 16) {
            // Main stats cards
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Cities",
                    value: "\(viewModel.travelStats.totalCities)",
                    icon: "building.2.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "Countries",
                    value: "\(viewModel.travelStats.totalCountries)",
                    icon: "globe",
                    color: .green
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Average Rating",
                    value: String(format: "%.1f", viewModel.travelStats.averageRating),
                    icon: "star.fill",
                    color: .yellow
                )
                
                StatCard(
                    title: "Favorites",
                    value: "\(viewModel.favoriteCities.count)",
                    icon: "heart.fill",
                    color: .red
                )
            }
        }
    }
    
    private var chartsView: some View {
        VStack(spacing: 24) {
            // Rating distribution chart
            ratingDistributionChart
            
            // Monthly visits chart
            monthlyVisitsChart
            
            // Countries chart
            countriesChart
        }
    }
    
    private var ratingDistributionChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rating Distribution")
                .font(.headline)
                .fontWeight(.semibold)
            
            let ratingData = getRatingDistribution()
            
            VStack(spacing: 12) {
                ForEach(1...5, id: \.self) { rating in
                    HStack {
                        HStack(spacing: 4) {
                            ForEach(1...rating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                            }
                        }
                        
                        Spacer()
                        
                        Text("\(ratingData[rating] ?? 0)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ProgressBar(
                            progress: Double(ratingData[rating] ?? 0) / Double(viewModel.cities.count),
                            height: 8,
                            color: .yellow
                        )
                        .frame(width: 100)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
    }
    
    private var monthlyVisitsChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Visits")
                .font(.headline)
                .fontWeight(.semibold)
            
            let monthlyData = getMonthlyVisits()
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(monthlyData.keys.sorted()), id: \.self) { month in
                    VStack(spacing: 8) {
                        Text("\(monthlyData[month] ?? 0)")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue)
                            .frame(width: 30, height: CGFloat(monthlyData[month] ?? 0) * 10)
                        
                        Text(month)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 120)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
    }
    
    private var countriesChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Countries")
                .font(.headline)
                .fontWeight(.semibold)
            
            let countryData = getCountryDistribution()
            
            VStack(spacing: 12) {
                ForEach(Array(countryData.prefix(5)), id: \.key) { country, count in
                    HStack {
                        Text(country)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("\(count)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        ProgressBar(
                            progress: Double(count) / Double(viewModel.cities.count),
                            height: 6,
                            color: .green
                        )
                        .frame(width: 80)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
    }
    
    private var detailedStatsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Additional Statistics")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 16) {
                StatRow(
                    title: "Total Distance",
                    value: String(format: "%.0f km", viewModel.travelStats.totalDistance),
                    icon: "location"
                )
                
                StatRow(
                    title: "Visit Streak",
                    value: "\(viewModel.travelStats.visitStreak) days",
                    icon: "calendar"
                )
                
                if let favoriteCity = viewModel.travelStats.favoriteCity {
                    StatRow(
                        title: "Favorite City",
                        value: favoriteCity,
                        icon: "heart.fill"
                    )
                }
                
                if let mostVisitedCountry = viewModel.travelStats.mostVisitedCountry {
                    StatRow(
                        title: "Most Visited Country",
                        value: mostVisitedCountry,
                        icon: "globe"
                    )
                }
                
                if let lastVisit = viewModel.travelStats.lastVisitDate {
                    StatRow(
                        title: "Last Visit",
                        value: lastVisit.formattedRelative(),
                        icon: "clock"
                    )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
    }
    
    // MARK: - Helper Methods
    private func getRatingDistribution() -> [Int: Int] {
        var distribution: [Int: Int] = [:]
        for city in viewModel.cities {
            distribution[city.rating, default: 0] += 1
        }
        return distribution
    }
    
    private func getMonthlyVisits() -> [String: Int] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        
        var monthlyData: [String: Int] = [:]
        for city in viewModel.cities {
            let month = formatter.string(from: city.visitDate)
            monthlyData[month, default: 0] += 1
        }
        return monthlyData
    }
    
    private func getCountryDistribution() -> [(key: String, value: Int)] {
        let countryCounts = Dictionary(grouping: viewModel.cities, by: { $0.country })
            .mapValues { $0.count }
        return countryCounts.sorted { $0.value > $1.value }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.subheadline)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    AnalyticsView(viewModel: AeroPathViewModel())
        .preferredColorScheme(.dark)
}
