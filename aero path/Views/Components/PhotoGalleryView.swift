import SwiftUI
import PhotosUI

struct PhotoGalleryView: View {
    let photos: [PhotoData]
    let onAddPhoto: () -> Void
    let onDeletePhoto: (PhotoData) -> Void
    
    @State private var selectedPhoto: PhotoData?
    @State private var showingPhotoPicker = false
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Photos")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: onAddPhoto) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            
            if photos.isEmpty {
                emptyStateView
            } else {
                photoGrid
            }
        }
        .sheet(isPresented: $showingPhotoPicker) {
            PhotoPickerView { photoData in
                // Handle photo selection
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView { photoData in
                // Handle image selection
            }
        }
        .sheet(isPresented: $showingCamera) {
            CameraView { photoData in
                // Handle camera photo
            }
        }
        .fullScreenCover(item: $selectedPhoto) { photo in
            PhotoDetailView(photo: photo) {
                onDeletePhoto(photo)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No photos yet")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Add Photos") {
                onAddPhoto()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private var photoGrid: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(photos) { photo in
                Button(action: {
                    selectedPhoto = photo
                }) {
                    Group {
                        if let uiImage = UIImage(data: photo.imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "photo.fill")
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                    .frame(height: 100)
                    .clipped()
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct PhotoPickerView: View {
    let onPhotoSelected: (PhotoData) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Photo Picker")
                    .font(.title)
                    .padding()
                
                Text("Select photos from your library")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("Add Photos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ImagePickerView: View {
    let onImageSelected: (PhotoData) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Image Picker")
                    .font(.title)
                    .padding()
                
                Text("Select an image")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("Add Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CameraView: View {
    let onPhotoTaken: (PhotoData) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Camera")
                    .font(.title)
                    .padding()
                
                Text("Take a photo")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("Take Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PhotoDetailView: View {
    let photo: PhotoData
    let onDelete: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = photo.uiImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(photo.caption.isEmpty ? "No caption" : photo.caption)
                        .font(.headline)
                    
                    Text("Added: \(photo.formattedDate)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Delete") {
                        onDelete()
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    PhotoGalleryView(
        photos: [],
        onAddPhoto: {},
        onDeletePhoto: { _ in }
    )
    .padding()
}
