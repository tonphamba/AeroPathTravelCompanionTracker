import SwiftUI

struct LaunchScreenView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.launchBackground, Color.launchAccent.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated background elements
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(Color.launchAccent.opacity(0.1))
                    .frame(width: CGFloat.random(in: 50...150))
                    .offset(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -400...400)
                    )
                    .animation(
                        .easeInOut(duration: Double.random(in: 3...6))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.5),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: 30) {
                // App Icon/Logo
                ZStack {
                    // Background circle with glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.launchAccent.opacity(0.3),
                                    Color.launchAccent.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .blur(radius: 20)
                    
                    // Main icon circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.launchAccent, Color.aeroSecondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
                        .shadow(color: Color.launchAccent.opacity(0.5), radius: 20, x: 0, y: 10)
                    
                    // App icon symbol
                    Image(systemName: "airplane.departure")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .scaleEffect(scale)
                .opacity(opacity)
                
                // App name
                VStack(spacing: 8) {
                    Text("AeroPath")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    
                    Text("Your Travel Companion")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
                }
                .opacity(opacity)
                
                // Loading indicator
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                    
                    Text("Loading...")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                scale = 1.0
                opacity = 1.0
                isAnimating = true
            }
        }
    }
}

#Preview {
    LaunchScreenView()
        .preferredColorScheme(.dark)
}
