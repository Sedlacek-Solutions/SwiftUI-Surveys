//
//  OtherTextField.swift
//
//  Created by James Sedlacek on 12/17/24.
//

import SwiftUI

@MainActor
struct OtherTextField {
    @FocusState private var focusState: Bool
    @Binding private var text: String

    var symbol: SFSymbol {
        text.isEmpty ? .circle : .checkmarkCircleFill
    }

    var borderColor: Color {
        text.isEmpty ? Color.clear : .blue
    }

    var isShowingClearButton: Bool {
        !text.isEmpty
    }

    init(text: Binding<String>) {
        self._text = text
    }

    func onTapGesture() {
        focusState.toggle()
    }
}

extension OtherTextField: View {
    var body: some View {
        HStack(spacing: .zero) {
            TextField(.other, text: $text)
                .focused($focusState)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)

            Image(symbol)
                .foregroundStyle(.blue)
                .font(.title3.weight(.semibold))
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(
            .background.secondary,
            in: .rect(cornerRadius: 10)
        )
        .foregroundStyle(.primary)
        .font(.body.weight(.medium))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    borderColor,
                    style: .init(lineWidth: 2)
                )
        )
        .contentShape(.rect)
        .onTapGesture(perform: onTapGesture)
    }
}

#Preview {
    @Previewable @State var text: String = ""
    OtherTextField(text: $text)
}
