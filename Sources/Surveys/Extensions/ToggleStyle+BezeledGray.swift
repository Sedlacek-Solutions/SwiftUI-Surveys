//
//  ToggleStyle+BezeledGray.swift
//
//  Created by James Sedlacek on 11/12/24.
//

import SwiftUI

struct BezeledGrayToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        let symbol: Image.SFSymbol = configuration.isOn ? .checkmarkCircleFill : .circle
        let borderColor = configuration.isOn ? Color.blue : .clear

        Button(
            action: {
                configuration.isOn.toggle()
            },
            label: {
                HStack {
                    Image(symbol)
                        .foregroundStyle(.blue)
                    configuration.label
                    Spacer(minLength: .zero)
                }
            }
        )
        .buttonStyle(.bezeledGray)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    borderColor,
                    style: .init(lineWidth: 2)
                )
        )
    }
}

extension ToggleStyle where Self == BezeledGrayToggleStyle {
    @MainActor @preconcurrency
    static var bezeledGray: BezeledGrayToggleStyle { .init() }
}

#Preview {
    @Previewable @State var isOn = false

    VStack {
        Toggle(
            "Hello World",
            isOn: $isOn
        )
        .toggleStyle(.bezeledGray)
    }
}
