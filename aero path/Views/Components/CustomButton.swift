import SwiftUI

enum ButtonStyle {
    case primary
    case secondary
    case destructive
    case ghost
}

struct CustomButton: View {
    let title: String
    let style: ButtonStyle
    let icon: String?
    let isLoading: Bool
    let action: () -> Void
    
    init(
        _ title: String,
        style: ButtonStyle = .primary,
        icon: String? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.icon = icon
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(textColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .disabled(isLoading)
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return Color.blue
        case .secondary:
            return Color(.systemGray5)
        case .destructive:
            return Color.red
        case .ghost:
            return Color.clear
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return .primary
        case .destructive:
            return .white
        case .ghost:
            return .blue
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary:
            return .clear
        case .secondary:
            return Color(.systemGray4)
        case .destructive:
            return .clear
        case .ghost:
            return .blue
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary, .destructive:
            return 0
        case .secondary, .ghost:
            return 1
        }
    }
    
    private var cornerRadius: CGFloat {
        12
    }
}

struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .blue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomButton("Primary Button", style: .primary, icon: "plus") {}
        
        CustomButton("Secondary Button", style: .secondary, icon: "heart") {}
        
        CustomButton("Destructive Button", style: .destructive, icon: "trash") {}
        
        CustomButton("Ghost Button", style: .ghost, icon: "arrow.right") {}
        
        CustomButton("Loading Button", style: .primary, isLoading: true) {}
        
        FloatingActionButton(icon: "plus") {}
    }
    .padding()
    .preferredColorScheme(.dark)
}
