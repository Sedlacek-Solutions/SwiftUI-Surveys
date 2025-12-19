//
//  ToggleStyle+LabeledCheckmark.swift
//
//  Created by James Sedlacek on 11/12/24.
//

import SwiftUI

struct LabeledCheckmarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        let symbol: SFSymbol = configuration.isOn ? .checkmarkCircleFill : .circle
        let borderColor = configuration.isOn ? Color.blue : .clear

        Button(
            action: {
                configuration.isOn.toggle()
            },
            label: {
                HStack {
                    configuration.label
                        .labelStyle(.coloredIcon)
                    Spacer(minLength: .zero)
                    Image(symbol)
                        .foregroundStyle(.blue)
                }
            }
        )
        .buttonStyle(.secondary(.rect(cornerRadius: 10)))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    borderColor,
                    style: .init(lineWidth: 2)
                )
        )
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
