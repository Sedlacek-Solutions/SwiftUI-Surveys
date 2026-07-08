//
//  ToggleStyle+LabeledCheckmark.swift
//
//  Created by James Sedlacek on 11/12/24.
//

import SwiftUI

struct LabeledCheckmarkToggleStyle: ToggleStyle {
    @Environment(\.surveyAccentColor) private var surveyAccentColor

    func makeBody(configuration: Configuration) -> some View {
        let borderColor = configuration.isOn ? surveyAccentColor : .clear

        Button(
            action: {
                configuration.isOn.toggle()
            },
            label: {
                HStack {
                    configuration.label
                        .labelStyle(.coloredIcon(iconColor: surveyAccentColor))
                    Spacer(minLength: .zero)
                    selectionIndicator(isSelected: configuration.isOn)
                }
            }
        )
        .buttonStyle(.secondary(.rect(cornerRadius: 10), isSelected: configuration.isOn))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    borderColor.opacity(0.6),
                    style: .init(lineWidth: 2)
                )
        )
    }

    @ViewBuilder
    private func selectionIndicator(isSelected: Bool) -> some View {
        if isSelected {
            Image(.checkmarkCircleFill)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, surveyAccentColor)
        } else {
            Image(.circle)
                .foregroundStyle(.secondary)
                .opacity(0.7)
        }
    }
}

extension ToggleStyle where Self == LabeledCheckmarkToggleStyle {
    @MainActor @preconcurrency
    static var labeledCheckmark: LabeledCheckmarkToggleStyle { .init() }
}

#Preview {
    @Previewable @State var isOn = false

    VStack {
        Toggle(
            "Testing",
            systemImage: "house",
            isOn: $isOn
        )
        .toggleStyle(.labeledCheckmark)
    }
}
