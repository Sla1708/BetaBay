import SwiftUI

struct GetStartedButton: View {
    @Binding var isPressed: Bool
    let onTap: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(Material.ultraThinMaterial)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(colorScheme == .dark ? 0.2 : 0.1), lineWidth: 1)
                    )
                Image(systemName: "arrow.right.circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
            }
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
            .scaleEffect(isPressed ? 0.96 : 1)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in withAnimation { isPressed = true } }
                    .onEnded   { _ in withAnimation { isPressed = false } }
            )
        }
    }
}