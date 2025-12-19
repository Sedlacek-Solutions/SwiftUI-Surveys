//
//  ButtonStyle+Secondary.swift
//
//  Created by James Sedlacek on 11/12/24.
//

import SwiftUI

struct SecondaryButtonStyle<S: Shape>: ButtonStyle {
    private let shape: S

    init(shape: S) {
        self.shape = shape
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                .background.secondary,
                in: shape
            )
            .foregroundStyle(.primary)
            .font(.title3.weight(.semibold))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .sensoryFeedback(.selection, trigger: configuration.isPressed)
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle<Capsule> {
    @MainActor @preconcurrency
    static var secondary: SecondaryButtonStyle<Capsule> { .init(shape: Capsule()) }

    @MainActor @preconcurrency
    static func secondary<S: Shape>(_ shape: S) -> SecondaryButtonStyle<S> {
        .init(shape: shape)
    }
}

#Preview {
    VStack(spacing: 16) {
        Button("Default Bezeled Gray") {}
            .buttonStyle(.secondary)

        Button("Disabled Bezeled Gray") {}
            .buttonStyle(.secondary)
            .disabled(true)

        Button("Custom Secondary") {}
            .buttonStyle(.secondary(.rect(cornerRadius: 12)))
    }
    .padding()
}
