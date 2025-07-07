import SwiftUI
import UIKit

struct BetaBayFeature: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let description: String
}

struct BetaBayFeaturesView: View {
    let onFinish: () -> Void

    let features: [BetaBayFeature] = [
        .init(iconName: "puzzlepiece.extension", title: "Seamless Integration", description: "Easily integrate and test your beta builds."),
        .init(iconName: "bubble.left.and.bubble.right", title: "Real-time Feedback", description: "Get instant feedback and crash reports from your testers."),
        .init(iconName: "lock.shield", title: "Secure Testing", description: "Distribute your apps securely to a trusted group of testers."),
        .init(iconName: "globe", title: "Global Reach", description: "Share your beta apps with testers from all around the world.")
    ]

    @State private var animateGradient = false
    @State private var currentIndex = 0
    @State private var isButtonPressed = false
    @State private var showFinalOverlay = false
    @State private var showConfetti = false
    @State private var finalOverlayScale: CGFloat = 1
    @State private var finalOverlayOpacity: Double = 1
    @State private var blurOpacity: Double = 0

    var body: some View {
        ScrollViewReader { proxy in
            ZStack {
                BetaBayAnimatedBackground(animate: $animateGradient)

                GeometryReader { outerGeo in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 30) {
                            ForEach(Array(features.enumerated()), id: \.element.id) { index, feature in
                                GeometryReader { geo in
                                    let midX = geo.frame(in: .global).midX
                                    let screenW = UIScreen.main.bounds.width
                                    let dist = abs(screenW / 2 - midX)
                                    let scale = max(1 - dist / screenW, 0.75)
                                    let angle = Angle(degrees: Double((screenW / 2 - midX) / 20))

                                    BetaBayFeatureCard(feature: feature)
                                        .scaleEffect(scale)
                                        .rotation3DEffect(angle, axis: (x: 0, y: 1, z: 0))
                                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: scale)
                                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                                        .gesture(
                                            DragGesture().onEnded { value in
                                                let threshold: CGFloat = 50
                                                if value.translation.width < -threshold, currentIndex < features.count - 1 {
                                                    currentIndex += 1
                                                    withAnimation { proxy.scrollTo(currentIndex, anchor: .center) }
                                                } else if value.translation.width > threshold, currentIndex > 0 {
                                                    currentIndex -= 1
                                                    withAnimation { proxy.scrollTo(currentIndex, anchor: .center) }
                                                }
                                            }
                                        )
                                }
                                .frame(width: 350, height: 450)
                                .id(index)
                            }
                        }
                        .padding(.horizontal, (outerGeo.size.width - 350) / 2)
                    }
                    .onAppear {
                        proxy.scrollTo(currentIndex, anchor: .center)
                    }
                }
                .frame(height: 450)

                if showFinalOverlay {
                    BetaBayBlurBackgroundOverlay()
                        .opacity(blurOpacity)
                        .zIndex(2)
                    
                    BetaBayBinocularsOverlay(name: "")
                        .scaleEffect(finalOverlayScale)
                        .opacity(finalOverlayOpacity)
                        .zIndex(3)
                }
                if showConfetti {
                    BetaBayConfettiOverlay(confettiCount: 120, spreadXRange: 300)
                        .zIndex(4)
                }
            }
            .ignoresSafeArea()
            .overlay(
                ZStack {
                    if !showFinalOverlay {
                        VStack {
                            Text("Explore Features")
                                .font(.largeTitle).fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.top, 60)
                    }

                    if !showFinalOverlay {
                        VStack {
                            Spacer()
                            VStack(spacing: 8) {
                                BetaBayContinueButton(isPressed: $isButtonPressed) {
                                    if currentIndex < features.count - 1 {
                                        currentIndex += 1
                                        withAnimation {
                                            proxy.scrollTo(currentIndex, anchor: .center)
                                        }
                                    } else {
                                        handleFinalSubmission()
                                    }
                                }
                                Text(currentIndex == features.count - 1 ? "Start" : "Continue")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
                .allowsHitTesting(!showFinalOverlay)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
        }
    }

    private func handleFinalSubmission() {
        showFinalOverlay = true
        withAnimation(.easeIn(duration: 0.5)) {
            blurOpacity = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                showConfetti = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 1)) {
                finalOverlayScale = 1.3
                finalOverlayOpacity = 0
                // Removed blurOpacity = 0 per instructions
                showConfetti = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            onFinish()
        }
    }
}

struct BetaBayFeatureCard: View {
    let feature: BetaBayFeature

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: feature.iconName)
                .resizable().scaledToFit()
                .frame(width: 90, height: 90)
                .foregroundColor(.white)
                .padding()
                .background(Circle().fill(Color.white.opacity(0.2)))
                .shadow(radius: 10)
            Text(feature.title)
                .font(.title2).fontWeight(.bold)
                .foregroundColor(.white)
            Text(feature.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.red, Color.pink]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
    }
}

struct BetaBayAnimatedBackground: View {
    @Binding var animate: Bool

    var body: some View {
        let grad1 = Gradient(colors: [Color(red: 1, green: 0.2, blue: 0.2), Color(red: 1, green: 0.4, blue: 0.4)])
        let grad2 = Gradient(colors: [Color(red: 0.8, green: 0, blue: 0), Color(red: 1, green: 0.1, blue: 0.1)])
        LinearGradient(gradient: animate ? grad1 : grad2, startPoint: .topLeading, endPoint: .bottomTrailing)
            .animation(.easeInOut(duration: 8), value: animate)
            .ignoresSafeArea()
    }
}

struct BetaBayContinueButton: View {
    @Binding var isPressed: Bool
    let onTap: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 56, height: 56)
                .overlay(Circle().stroke(Color.white.opacity(colorScheme == .dark ? 0.2 : 0.1), lineWidth: 1))
            Image(systemName: "arrow.right.circle")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
        }
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        .scaleEffect(isPressed ? 0.96 : 1)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) { isPressed = true }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) { isPressed = false }
                    onTap()
                }
        )
    }
}

struct BetaBayBlurBackgroundOverlay: View {
    var body: some View {
        VisualEffectBlurView(style: .dark)
            .ignoresSafeArea()
    }
}

struct BetaBayBinocularsOverlay: View {
    let name: String
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "binoculars.fill")
                .resizable().scaledToFit().frame(width: 80, height: 80)
                .foregroundColor(.white)
                .shadow(color: .white.opacity(0.7), radius: 5)
            Text(name.isEmpty ? "Your turn to explore" : "Your turn to explore, \(name)!")
                .font(.headline).foregroundColor(.white)
            Spacer()
        }
    }
}

struct BetaBayConfettiOverlay: View {
    let confettiCount: Int
    let spreadXRange: Double
    @State private var confettiPieces: [ConfettiPiece] = []
    @State private var animate = false

    private let colors: [Color] = [.red, .pink, .orange, .yellow]
    private let types: [ConfettiShapeType] = [.rectangle, .circle, .triangle, .diamond]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(confettiPieces) { piece in
                    ConfettiShape(type: piece.shapeType)
                        .fill(piece.color)
                        .frame(width: piece.size.width, height: piece.size.height)
                        .rotationEffect(.degrees(animate ? piece.endRotation : piece.startRotation))
                        .offset(x: animate ? piece.endX : piece.startX, y: animate ? piece.endY : piece.startY)
                        .opacity(animate ? 1 : 0.85)
                        .animation(.easeInOut(duration: piece.duration).delay(piece.delay), value: animate)
                }
            }
            .onAppear {
                let w = geo.size.width, h = geo.size.height
                confettiPieces = (0..<confettiCount).map { _ in
                    let shape = types.randomElement()!
                    let color = colors.randomElement()!
                    let sx = Double.random(in: 0...w)
                    let sy = Double.random(in: -100...(-20))
                    let dx = Double.random(in: -spreadXRange...spreadXRange)
                    return ConfettiPiece(id: UUID(), shapeType: shape, color: color, startX: sx, startY: sy, endX: sx + dx, endY: h + Double.random(in: 100...250), startRotation: Double.random(in: 0...360), endRotation: Double.random(in: 720...1440), size: CGSize(width: CGFloat.random(in: 10...20), height: CGFloat.random(in: 10...20)), duration: Double.random(in: 1.8...2.5), delay: Double.random(in: 0...0.4))
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                DispatchQueue.main.async { animate = true }
            }
        }
        .ignoresSafeArea()
    }
}

struct ConfettiPiece: Identifiable {
    let id: UUID
    let shapeType: ConfettiShapeType
    let color: Color
    let startX, startY, endX, endY, startRotation, endRotation: Double
    let size: CGSize
    let duration, delay: Double
}

enum ConfettiShapeType { case rectangle, circle, triangle, diamond }

struct ConfettiShape: Shape {
    let type: ConfettiShapeType
    func path(in rect: CGRect) -> Path {
        switch type {
        case .rectangle: return Rectangle().path(in: rect)
        case .circle:    return Circle().path(in: rect)
        case .diamond:
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.closeSubpath()
            return path
        case .triangle:
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.closeSubpath()
            return path
        }
    }
}

struct VisualEffectBlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct BetaBayFeaturesView_Previews: PreviewProvider {
    static var previews: some View {
        BetaBayFeaturesView {
            print("Finished onboarding flow.")
        }
        .preferredColorScheme(.dark)
    }
}
