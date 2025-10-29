//
//  ButtonStyle+BezeledGray.swift
//
//  Created by James Sedlacek on 11/12/24.
//

import SwiftUI

struct BezeledGrayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                .background.secondary,
                in: .rect(cornerRadius: 10)
            )
            .foregroundStyle(.primary)
            .font(.body.weight(.medium))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .sensoryFeedback(.selection, trigger: configuration.isPressed)
    }
}

extension ButtonStyle where Self == BezeledGrayButtonStyle {
    @MainActor @preconcurrency
    static var bezeledGray: BezeledGrayButtonStyle { .init() }
}

#Preview {
    VStack(spacing: 16) {
        Button("Default Bezeled Gray") {}
            .buttonStyle(.bezeledGray)

        Button("Disabled Bezeled Gray") {}
            .buttonStyle(.bezeledGray)
            .disabled(true)
    }
    .padding()
}
