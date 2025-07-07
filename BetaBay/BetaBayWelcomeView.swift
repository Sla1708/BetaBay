//
//  BetaBayWelcomeView.swift
//  BetaBay
//
//  Created by Sayan on 01.07.2025.
//


import SwiftUI

struct BetaBayWelcomeView: View {
    /// Callback triggered when user taps "Get Started"
    let onGetStarted: () -> Void
    
    @State private var isButtonPressed = false
    @State private var showGetStartedButton = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // This now displays the new red gradient background
                BetaBayRedGradientBackground()
                
                BetaBayAnimatedIconBackground()

                // Displaying the PNG image
                Image("BetaBayIcon-Onboarding")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: min(geo.size.width * 0.9, 900),
                        height: min(geo.size.height * 0.9, 900)
                    )
                    .allowsHitTesting(false)
            }
            .overlay(
                Group {
                    if showGetStartedButton {
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                BetaBayGetStartedButton(isPressed: $isButtonPressed) {
                                    onGetStarted()
                                }
                                
                                Text("Get Started")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white) // Reverted to white
                            }
                            Spacer()
                        }
                        .padding(.bottom, 40)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                },
                alignment: .bottom
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    showGetStartedButton = true
                }
            }
        }
    }
}

// MARK: - Red Gradient Background
struct BetaBayRedGradientBackground: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        LinearGradient(
            colors: colorScheme == .dark ?
                [Color(hex: "#640A14"), Color(hex: "#3C000A")] :
                [Color(hex: "#FF3B30"), Color(hex: "#C8281E")],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

// MARK: - AnimatedIconBackground
struct BetaBayAnimatedIconBackground: View {
    private let symbols = [
        "checkmark", "calendar", "wind", "flame",
        "graduationcap", "iphone", "message", "book",
        "function", "sparkles"
    ]
    private let rows = 24
    private let cols = 8
    
    @State private var gridSymbols: [[String]] = []
    
    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 28
            let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: cols)
            
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(0 ..< (rows * cols), id: \.self) { idx in
                    let r = idx / cols
                    let c = idx % cols
                    if r < gridSymbols.count, c < gridSymbols[r].count {
                        Image(systemName: gridSymbols[r][c])
                            .resizable().scaledToFit().frame(width: 24, height: 24)
                            .foregroundColor(.white.opacity(0.25)) // Reverted to white
                            .onAppear { scheduleRandomizeSymbol(row: r, col: c) }
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .onAppear {
                gridSymbols = (0 ..< rows).map { _ in (0 ..< cols).map { _ in symbols.randomElement() ?? "square" } }
            }
        }
    }
    
    private func scheduleRandomizeSymbol(row: Int, col: Int) {
        let delay = Double.random(in: 0.8 ... 2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if row < gridSymbols.count && col < gridSymbols[row].count {
                gridSymbols[row][col] = symbols.randomElement() ?? "square"
                scheduleRandomizeSymbol(row: row, col: col)
            }
        }
    }
}

// MARK: - GetStartedButton
struct BetaBayGetStartedButton: View {
    @Binding var isPressed: Bool
    let onTap: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial) // Reverted
                .frame(width: 56, height: 56)
                .overlay(Circle().stroke(Color.white.opacity(colorScheme == .dark ? 0.2 : 0.1), lineWidth: 1))
            
            Image(systemName: "arrow.right.circle")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white) // Reverted to white
        }
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeInOut(duration: 0.1)) { isPressed = true } }
                .onEnded { _ in withAnimation(.easeInOut(duration: 0.1)) { isPressed = false }; onTap() }
        )
    }
}

// MARK: - Hex Color Helper
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        let r = Double((hexNumber & 0xff0000) >> 16) / 255
        let g = Double((hexNumber & 0x00ff00) >> 8) / 255
        let b = Double(hexNumber & 0x0000ff) / 255
        self.init(red: r, green: g, blue: b)
    }
}
