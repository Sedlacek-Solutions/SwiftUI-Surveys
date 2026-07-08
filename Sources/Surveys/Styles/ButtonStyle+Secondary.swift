//
//  ButtonStyle+Secondary.swift
//
//  Created by James Sedlacek on 11/12/24.
//

import SwiftUI

struct SecondaryButtonStyle<S: Shape>: ButtonStyle {
    @Environment(\.surveyAccentColor) private var surveyAccentColor
    private let shape: S
    private let isSelected: Bool

    init(shape: S, isSelected: Bool = false) {
        self.shape = shape
        self.isSelected = isSelected
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(backgroundView)
            .foregroundStyle(.primary)
            .font(.title3.weight(.semibold))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .sensoryFeedback(.selection, trigger: configuration.isPressed)
    }

    private var backgroundView: some View {
        ZStack {
            shape
                .fill(.background.secondary)

            if isSelected {
                shape
                    .fill(surveyAccentColor.opacity(0.03))
            }
        }
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle<Capsule> {
    @MainActor @preconcurrency
    static var secondary: SecondaryButtonStyle<Capsule> { .init(shape: Capsule()) }

    @MainActor @preconcurrency
    static func secondary<S: Shape>(
        _ shape: S,
        isSelected: Bool = false
    ) -> SecondaryButtonStyle<S> {
        .init(shape: shape, isSelected: isSelected)
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
