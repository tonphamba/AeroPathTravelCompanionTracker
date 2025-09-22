import SwiftUI

struct CitiesListView: View {
    @State var viewModel: AeroPathViewModel
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and filter bar
                searchAndFilterBar
                
                // Content
                if viewModel.appState == .loading {
                    loadingView
                } else if viewModel.filteredCities.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        citiesList
                    }
                }
            }
            .navigationTitle("My Cities")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showAddCity() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingAddCity) {
                AddEditCityView(viewModel: viewModel, city: nil)
            }
            .sheet(isPresented: $viewModel.isShowingEditCity) {
                if let city = viewModel.selectedCity {
                    AddEditCityView(viewModel: viewModel, city: city)
                }
            }
            .sheet(isPresented: $showingFilters) {
                FilterView(viewModel: viewModel)
            }
        }
    }
    
    private var searchAndFilterBar: some View {
        VStack(spacing: 12) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search cities...", text: $viewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onChange(of: viewModel.searchText) { _, newValue in
                        viewModel.searchTextChanged(newValue)
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
            )
            
            // Filter chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterChip(
                        title: viewModel.selectedFilterOption.rawValue,
                        isSelected: true,
                        action: { showingFilters = true }
                    )
                    
                    FilterChip(
                        title: viewModel.selectedSortOption.rawValue,
                        isSelected: false,
                        action: { showingFilters = true }
                    )
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 12)
        .background(Color(.systemGroupedBackground))
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Loading cities...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .centerInParent()
    }
    
    private var emptyStateView: some View {
        Group {
            if viewModel.searchText.isEmpty {
                EmptyCitiesView(onAddCity: { viewModel.showAddCity() })
            } else {
                EmptySearchView()
            }
        }
        .centerInParent()
    }
    
    private var citiesList: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.filteredCities) { city in
                CityCard(
                    city: city,
                    onTap: { viewModel.selectCity(city) },
                    onFavoriteToggle: { viewModel.toggleFavorite(city) }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.blue : Color(.systemBackground))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CitiesListView(viewModel: AeroPathViewModel())
        .preferredColorScheme(.dark)
}
