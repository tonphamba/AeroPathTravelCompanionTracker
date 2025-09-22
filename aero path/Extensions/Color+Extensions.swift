import SwiftUI

extension Color {
    // MARK: - App Theme Colors (AeroPath Unique Palette)
    static let aeroPrimary = Color(red: 0.2, green: 0.8, blue: 0.9)      // Cyan Blue
    static let aeroSecondary = Color(red: 0.4, green: 0.6, blue: 1.0)    // Electric Blue
    static let aeroAccent = Color(red: 1.0, green: 0.4, blue: 0.6)       // Coral Pink
    static let aeroSuccess = Color(red: 0.2, green: 0.8, blue: 0.4)      // Emerald Green
    static let aeroWarning = Color(red: 1.0, green: 0.7, blue: 0.2)      // Amber Orange
    static let aeroError = Color(red: 0.9, green: 0.3, blue: 0.4)        // Rose Red
    
    // MARK: - Launch Colors
    static let launchBackground = Color(red: 0.05, green: 0.1, blue: 0.15)  // Deep Navy for launch
    static let launchAccent = Color(red: 0.2, green: 0.8, blue: 0.9)        // Cyan Blue for launch
    
    // Dark theme colors
    static let aeroDark = Color(red: 0.05, green: 0.1, blue: 0.15)       // Deep Navy
    static let aeroDarkSecondary = Color(red: 0.1, green: 0.15, blue: 0.2) // Dark Blue Gray
    static let aeroDarkTertiary = Color(red: 0.15, green: 0.2, blue: 0.25) // Medium Blue Gray
    
    // Light theme colors
    static let aeroLight = Color(red: 0.98, green: 0.99, blue: 1.0)      // Off White
    static let aeroLightSecondary = Color(red: 0.95, green: 0.97, blue: 0.99) // Light Blue White
    static let aeroLightTertiary = Color(red: 0.9, green: 0.94, blue: 0.98)   // Light Blue Gray
    
    // MARK: - Unique Gradients
    static let aeroGradient = LinearGradient(
        colors: [aeroPrimary, aeroSecondary, aeroAccent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let skyGradient = LinearGradient(
        colors: [aeroLight, aeroPrimary.opacity(0.8), aeroSecondary],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let sunsetGradient = LinearGradient(
        colors: [aeroAccent, aeroWarning, aeroPrimary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let oceanGradient = LinearGradient(
        colors: [aeroDark, aeroPrimary.opacity(0.3), aeroSecondary.opacity(0.5)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let auroraGradient = LinearGradient(
        colors: [aeroSuccess, aeroPrimary, aeroAccent, aeroWarning],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Rating Colors (AeroPath Style)
    static func ratingColor(for rating: Int) -> Color {
        switch rating {
        case 5:
            return aeroSuccess
        case 4:
            return aeroPrimary
        case 3:
            return aeroWarning
        case 2:
            return aeroAccent
        default:
            return aeroError
        }
    }
    
    // MARK: - Glassmorphism Colors
    static let glassBackground = Color.white.opacity(0.1)
    static let glassBorder = Color.white.opacity(0.2)
    static let glassShadow = Color.black.opacity(0.1)
    
    // MARK: - Dynamic Colors
    static func dynamic(light: Color, dark: Color) -> Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
    
    // MARK: - Animated Colors
    static func animatedColor(from: Color, to: Color, progress: Double) -> Color {
        let fromComponents = UIColor(from).cgColor.components ?? [0, 0, 0, 1]
        let toComponents = UIColor(to).cgColor.components ?? [0, 0, 0, 1]
        
        let red = fromComponents[0] + (toComponents[0] - fromComponents[0]) * progress
        let green = fromComponents[1] + (toComponents[1] - fromComponents[1]) * progress
        let blue = fromComponents[2] + (toComponents[2] - fromComponents[2]) * progress
        let alpha = fromComponents[3] + (toComponents[3] - fromComponents[3]) * progress
        
        return Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}

