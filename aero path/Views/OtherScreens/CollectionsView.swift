import SwiftUI

struct CollectionsView: View {
    @State var viewModel: AeroPathViewModel
    @State private var collections: [Collection] = []
    @State private var showingAddCollection = false
    @State private var selectedCollection: Collection?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if collections.isEmpty {
                    emptyStateView
                } else {
                    collectionsList
                }
            }
            .navigationTitle("Collections")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCollection = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCollection) {
                AddEditCollectionView(collections: $collections)
            }
            .sheet(item: $selectedCollection) { collection in
                CollectionDetailView(collection: collection, viewModel: viewModel)
            }
            .onAppear {
                loadCollections()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            VStack(spacing: 8) {
                Text("No Collections Yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Create collections to organize your cities by theme, trip, or any other way you like")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Create Collection") {
                showingAddCollection = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 32)
        .centerInParent()
    }
    
    private var collectionsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(collections) { collection in
                    CollectionCard(
                        collection: collection,
                        cityCount: getCityCount(for: collection),
                        onTap: {
                            selectedCollection = collection
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
    
    private func getCityCount(for collection: Collection) -> Int {
        collection.cityIds.count
    }
    
    private func loadCollections() {
        // Load default collections
        collections = [
            Collection(name: "Favorites", description: "My favorite cities", color: .red, isDefault: true),
            Collection(name: "Europe", description: "Cities in Europe", color: .blue, isDefault: true),
            Collection(name: "Asia", description: "Cities in Asia", color: .green, isDefault: true),
            Collection(name: "Recent", description: "Recently visited cities", color: .orange, isDefault: true)
        ]
    }
}

struct CollectionCard: View {
    let collection: Collection
    let cityCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Color indicator
                Circle()
                    .fill(collection.color.color)
                    .frame(width: 12, height: 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(collection.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    if !collection.description.isEmpty {
                        Text(collection.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Text("\(cityCount) cities")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddEditCollectionView: View {
    @Binding var collections: [Collection]
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedColor: CollectionColor = .blue
    
    var body: some View {
        NavigationView {
            Form {
                Section("Collection Details") {
                    TextField("Name", text: $name)
                    TextField("Description (Optional)", text: $description)
                }
                
                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                        ForEach(CollectionColor.allCases, id: \.self) { color in
                            Button(action: {
                                selectedColor = color
                            }) {
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("New Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCollection()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveCollection() {
        let newCollection = Collection(
            name: name,
            description: description,
            color: selectedColor
        )
        collections.append(newCollection)
        dismiss()
    }
}

struct CollectionDetailView: View {
    let collection: Collection
    @State var viewModel: AeroPathViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var citiesInCollection: [City] {
        viewModel.cities.filter { city in
            collection.cityIds.contains(city.id)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if citiesInCollection.isEmpty {
                    emptyStateView
                } else {
                    citiesList
                }
            }
            .navigationTitle(collection.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "folder")
                .font(.system(size: 64))
                .foregroundColor(collection.color.color)
            
            VStack(spacing: 8) {
                Text("No Cities in Collection")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Add cities to this collection to organize them")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 32)
        .centerInParent()
    }
    
    private var citiesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(citiesInCollection) { city in
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
}

#Preview {
    CollectionsView(viewModel: AeroPathViewModel())
        .preferredColorScheme(.dark)
}
