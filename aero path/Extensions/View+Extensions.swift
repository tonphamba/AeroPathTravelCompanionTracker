import SwiftUI

extension View {
    // MARK: - Animation Extensions (AeroPath Unique)
    func fadeIn(delay: Double = 0) -> some View {
        self.opacity(0)
            .animation(.easeInOut(duration: 0.8).delay(delay), value: true)
            .onAppear {
                withAnimation {
                    _ = self.opacity(1)
                }
            }
    }
    
    func slideIn(from edge: Edge = .trailing, delay: Double = 0) -> some View {
        self.offset(x: edge == .leading ? -300 : edge == .trailing ? 300 : 0,
                   y: edge == .top ? -300 : edge == .bottom ? 300 : 0)
            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(delay), value: true)
            .onAppear {
                withAnimation {
                    _ = self.offset(.zero)
                }
            }
    }
    
    func bounceIn(delay: Double = 0) -> some View {
        self.scaleEffect(0.3)
            .opacity(0)
            .animation(.spring(response: 0.6, dampingFraction: 0.5).delay(delay), value: true)
            .onAppear {
                withAnimation {
                    _ = self.scaleEffect(1.0)
                    _ = self.opacity(1.0)
                }
            }
    }
    
    func floatIn(delay: Double = 0) -> some View {
        self
            .offset(y: 50)
            .opacity(0)
            .onAppear {
                withAnimation(.easeOut(duration: 1.0).delay(delay)) {
                    _ = self.offset(y: 0)
                    _ = self.opacity(1)
                }
            }
    }
    
    func rotateIn(delay: Double = 0) -> some View {
        self
            .rotationEffect(.degrees(-180))
            .opacity(0)
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(delay)) {
                    _ = self.rotationEffect(.degrees(0))
                    _ = self.opacity(1)
                }
            }
    }
    
    func scaleIn(delay: Double = 0) -> some View {
        self
            .scaleEffect(0.1)
            .opacity(0)
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.5).delay(delay)) {
                    _ = self.scaleEffect(1.0)
                    _ = self.opacity(1)
                }
            }
    }
    
    func waveIn(delay: Double = 0) -> some View {
        self
            .offset(y: 30)
            .opacity(0)
            .rotationEffect(.degrees(5))
            .onAppear {
                withAnimation(.spring(response: 0.9, dampingFraction: 0.6).delay(delay)) {
                    _ = self.offset(y: 0)
                    _ = self.opacity(1)
                    _ = self.rotationEffect(.degrees(0))
                }
            }
    }
    
    func pulseIn(delay: Double = 0) -> some View {
        self
            .scaleEffect(0.8)
            .opacity(0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.6).delay(delay)) {
                    _ = self.scaleEffect(1.0)
                    _ = self.opacity(1)
                }
                withAnimation(.easeInOut(duration: 0.3).delay(delay + 0.3)) {
                    _ = self.scaleEffect(1.05)
                }
                withAnimation(.easeInOut(duration: 0.2).delay(delay + 0.6)) {
                    _ = self.scaleEffect(1.0)
                }
            }
    }
    
    // MARK: - Styling Extensions (AeroPath Unique)
    func cardStyle() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.glassBorder, lineWidth: 1)
                    )
                    .shadow(color: Color.glassShadow, radius: 10, x: 0, y: 5)
            )
    }
    
    func glassCardStyle() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.glassBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.3), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
            )
    }
    
    func neonCardStyle() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.aeroDarkSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.aeroPrimary.opacity(0.8), Color.aeroAccent.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: Color.aeroPrimary.opacity(0.3), radius: 15, x: 0, y: 8)
            )
    }
    
    func glassmorphism() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
            )
    }
    
    func gradientBackground(colors: [Color] = [.aeroPrimary, .aeroSecondary]) -> some View {
        self
            .background(
                LinearGradient(
                    colors: colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    func auroraBackground() -> some View {
        self
            .background(
                LinearGradient(
                    colors: [Color.aeroSuccess, Color.aeroPrimary, Color.aeroAccent, Color.aeroWarning],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    func oceanBackground() -> some View {
        self
            .background(
                LinearGradient(
                    colors: [Color.aeroDark, Color.aeroPrimary.opacity(0.3), Color.aeroSecondary.opacity(0.5)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
    
    // MARK: - Special Effects
    func glow(color: Color = Color.aeroPrimary, radius: CGFloat = 10) -> some View {
        self
            .shadow(color: color, radius: radius)
            .shadow(color: color, radius: radius * 0.5)
    }
    
    func shimmer() -> some View {
        self
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.3),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .rotationEffect(.degrees(30))
                    .offset(x: -200)
                    .animation(
                        .linear(duration: 2.0)
                        .repeatForever(autoreverses: false),
                        value: UUID()
                    )
            )
            .clipped()
    }
    
    func gradientBorder(
        colors: [Color] = [Color.aeroPrimary, Color.aeroAccent],
        lineWidth: CGFloat = 2
    ) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: lineWidth
                    )
            )
    }
    
    func hoverEffect() -> some View {
        self
            .scaleEffect(1.0)
            .onHover { isHovered in
                withAnimation(.easeInOut(duration: 0.2)) {
                    _ = self.scaleEffect(isHovered ? 1.05 : 1.0)
                }
            }
    }
    
    // MARK: - Layout Extensions
    func centerInParent() -> some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                self
                Spacer()
            }
            Spacer()
        }
    }
    
    func fillWidth() -> some View {
        self.frame(maxWidth: .infinity)
    }
    
    func fillHeight() -> some View {
        self.frame(maxHeight: .infinity)
    }
    
    // MARK: - Conditional Modifiers
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if trueTransform: (Self) -> TrueContent,
        else falseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            trueTransform(self)
        } else {
            falseTransform(self)
        }
    }
}

// MARK: - Edge Extension
extension Edge {
    static var all: [Edge] { [.top, .bottom, .leading, .trailing] }
}
