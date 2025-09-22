import SwiftUI

struct HomeView: View {
    @State var viewModel: AeroPathViewModel
    
    var body: some View {
        NavigationView {
                        ZStack {
                            // Background gradient
                            Color.aeroGradient
                                .ignoresSafeArea()
                            
                            // Animated background elements
                            Circle()
                                .fill(Color.aeroAccent.opacity(0.1))
                                .frame(width: 200, height: 200)
                                .offset(x: -100, y: -200)
                                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: UUID())
                            
                            Circle()
                                .fill(Color.aeroSuccess.opacity(0.1))
                                .frame(width: 150, height: 150)
                                .offset(x: 150, y: -100)
                                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: UUID())
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerView
                        
                        // Stats cards
                        statsView
                        
                        // Recent cities
                        recentCitiesView
                        
                        // Quick actions
                        quickActionsView
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $viewModel.isShowingAddCity) {
            AddEditCityView(viewModel: viewModel, city: nil)
        }
        .sheet(isPresented: $viewModel.isShowingAnalytics) {
            AnalyticsView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome!")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Text("Your travel map")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Button(action: { viewModel.showProfile() }) {
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.top, 20)
    }
    
    private var statsView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Cities",
                    value: "\(viewModel.travelStats.totalCities)",
                    icon: "building.2.fill",
                    color: .white
                )
                
                StatCard(
                    title: "Countries",
                    value: "\(viewModel.travelStats.totalCountries)",
                    icon: "globe",
                    color: .white
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Rating",
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
    
    private var recentCitiesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Trips")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink(destination: CitiesListView(viewModel: viewModel)) {
                    Text("All")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            if viewModel.recentCities.isEmpty {
                EmptyCitiesView(onAddCity: { viewModel.showAddCity() })
                    .cardStyle()
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(Array(viewModel.recentCities.prefix(3))) { city in
                        CityCard(
                            city: city,
                            onTap: { viewModel.selectCity(city) },
                            onFavoriteToggle: { viewModel.toggleFavorite(city) }
                        )
                    }
                }
            }
        }
    }
    
    private var quickActionsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                QuickActionButton(
                    title: "Add City",
                    icon: "plus.circle.fill",
                    color: .green
                ) {
                    viewModel.showAddCity()
                }
                
                QuickActionButton(
                    title: "Analytics",
                    icon: "chart.bar.fill",
                    color: .orange
                ) {
                    viewModel.showAnalytics()
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .glow(color: color, radius: 5)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .glassCardStyle()
        .hoverEffect()
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                        .glow(color: color, radius: 3)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .neonCardStyle()
            .hoverEffect()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView(viewModel: AeroPathViewModel())
        .preferredColorScheme(.dark)
}
