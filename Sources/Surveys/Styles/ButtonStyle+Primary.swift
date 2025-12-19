//
//  ButtonStyle+Primary.swift
//
//  Created by James Sedlacek on 11/12/24.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    private var backgroundColor: Color {
        isEnabled ? .blue : .blue.opacity(0.2)
    }

    private var foregroundColor: Color {
        isEnabled ? .white : .blue
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                backgroundColor,
                in: .capsule
            )
            .foregroundStyle(foregroundColor)
            .font(.title3.weight(.semibold))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .sensoryFeedback(.selection, trigger: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    @MainActor @preconcurrency
    static var primary: PrimaryButtonStyle { .init() }
}

#Preview {
    VStack(spacing: 16) {
        Button("Hello, World!") {}
            .buttonStyle(.primary)

        Button("Hello, World!") {}
            .buttonStyle(.primary)
            .disabled(true)
    }
    .padding()
}
