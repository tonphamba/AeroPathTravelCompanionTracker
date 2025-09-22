import SwiftUI

struct ProgressBar: View {
    let progress: Double // 0.0 to 1.0
    let height: CGFloat
    let color: Color
    let backgroundColor: Color
    
    init(progress: Double, height: CGFloat = 8, color: Color = .blue, backgroundColor: Color = .gray.opacity(0.3)) {
        self.progress = max(0, min(1, progress))
        self.height = height
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(backgroundColor)
                    .frame(height: height)
                
                // Progress
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress, height: height)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: height)
    }
}

struct CircularProgressBar: View {
    let progress: Double // 0.0 to 1.0
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    let backgroundColor: Color
    
    init(progress: Double, size: CGFloat = 60, lineWidth: CGFloat = 6, color: Color = .blue, backgroundColor: Color = .gray.opacity(0.3)) {
        self.progress = max(0, min(1, progress))
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [color, color.opacity(0.7)],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            
            // Progress text
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressBar(progress: 0.7, height: 12, color: .blue)
            .frame(width: 200, height: 12)
        
        CircularProgressBar(progress: 0.75, size: 80, color: .green)
    }
    .padding()
    .preferredColorScheme(.dark)
}
