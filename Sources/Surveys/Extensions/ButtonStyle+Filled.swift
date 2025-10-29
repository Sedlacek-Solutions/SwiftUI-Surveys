//
//  ButtonStyle+Filled.swift
//
//  Created by James Sedlacek on 11/12/24.
//

import SwiftUI

struct FilledButtonStyle: ButtonStyle {
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
            .frame(height: 50)
            .background(
                backgroundColor,
                in: .rect(cornerRadius: 10)
            )
            .foregroundStyle(foregroundColor)
            .font(.body.weight(.medium))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .sensoryFeedback(.selection, trigger: configuration.isPressed)
    }
}

extension ButtonStyle where Self == FilledButtonStyle {
    @MainActor @preconcurrency
    static var filled: FilledButtonStyle { .init() }
}

#Preview {
    VStack(spacing: 16) {
        Button("Hello, World!") {}
            .buttonStyle(.filled)

        Button("Hello, World!") {}
            .buttonStyle(.filled)
            .disabled(true)
    }
    .padding()
}
