import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    let buttonTitle: String?
    let buttonAction: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        description: String,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.1), .blue.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(.blue)
            }
            
            // Text content
            VStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
            // Action button
            if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
                CustomButton(buttonTitle, style: .primary, icon: "plus") {
                    buttonAction()
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 48)
    }
}

// Specific empty states for different screens
struct EmptyCitiesView: View {
    let onAddCity: () -> Void
    
    var body: some View {
        EmptyStateView(
            icon: "airplane.departure",
            title: "Start Your Journey",
            description: "Add your first visited city to create your travel map",
            buttonTitle: "Add City",
            buttonAction: onAddCity
        )
    }
}

struct EmptySearchView: View {
    var body: some View {
        EmptyStateView(
            icon: "magnifyingglass",
            title: "Nothing Found",
            description: "Try changing your search query or filters"
        )
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        EmptyStateView(
            icon: "heart",
            title: "No Favorite Cities",
            description: "Mark cities as favorites to quickly return to them"
        )
    }
}

#Preview {
    VStack(spacing: 40) {
        EmptyCitiesView(onAddCity: {})
        
        Divider()
        
        EmptySearchView()
        
        Divider()
        
        EmptyFavoritesView()
    }
    .padding()
    .preferredColorScheme(.dark)
}
