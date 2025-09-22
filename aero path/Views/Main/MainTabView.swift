import SwiftUI

struct MainTabView: View {
    @State var viewModel: AeroPathViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            // Главный экран
            HomeView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            // Список городов
            CitiesListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Cities")
                }
                .tag(1)
            
            // Избранное
            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .tag(2)
            
            // Аналитика
            AnalyticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }
                .tag(3)
            
            // Коллекции
            CollectionsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Collections")
                }
                .tag(4)
            
            // Настройки
            SettingsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(5)
        }
                    .accentColor(.aeroPrimary)
                    .preferredColorScheme(.dark)
    }
}

struct FavoritesView: View {
    @State var viewModel: AeroPathViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.favoriteCities.isEmpty {
                    EmptyFavoritesView()
                        .centerInParent()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.favoriteCities) { city in
                                CityCard(
                                    city: city,
                                    onTap: { viewModel.selectCity(city) },
                                    onFavoriteToggle: { viewModel.toggleFavorite(city) }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $viewModel.isShowingAddCity) {
            AddEditCityView(viewModel: viewModel, city: nil)
        }
        .sheet(isPresented: $viewModel.isShowingEditCity) {
            if let city = viewModel.selectedCity {
                AddEditCityView(viewModel: viewModel, city: city)
            }
        }
    }
}

#Preview {
    MainTabView(viewModel: AeroPathViewModel())
        .preferredColorScheme(.dark)
}
