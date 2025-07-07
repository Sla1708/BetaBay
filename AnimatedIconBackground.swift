import SwiftUI

struct AnimatedIconBackground: View {
    private let symbols = ["checkmark","calendar","wind","flame",
                           "graduationcap","iphone","message","book",
                           "function","sparkles"]
    private let rows = 24
    private let cols = 8

    @State private var grid: [[String]] = []

    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 28
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: cols),
                spacing: spacing
            ) {
                ForEach(0..<rows*cols, id: \.self) { idx in
                    let r = idx / cols, c = idx % cols
                    if r < grid.count, c < grid[r].count {
                        Image(systemName: grid[r][c])
                            .resizable().scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white.opacity(0.25))
                            .onAppear { randomize(r,c) }
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .onAppear {
                grid = (0..<rows).map { _ in
                    (0..<cols).map { _ in symbols.randomElement()! }
                }
            }
        }
    }

    private func randomize(_ row: Int, _ col: Int) {
        let delay = Double.random(in: 0.8...2)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if row < grid.count && col < grid[row].count {
                grid[row][col] = symbols.randomElement()!
                randomize(row, col)
            }
        }
    }
}