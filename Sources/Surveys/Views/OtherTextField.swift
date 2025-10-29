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

    var symbol: Image.SFSymbol {
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

    func clearButtonAction() {
        text = ""
    }
}

extension OtherTextField: View {
    var body: some View {
        HStack(spacing: .zero) {
            Image(symbol)
                .foregroundStyle(.blue)

            TextField(.other, text: $text)
                .focused($focusState)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)

            clearButton
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
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

    @ViewBuilder
    private var clearButton: some View {
        if isShowingClearButton {
            Button(action: clearButtonAction) {
                Image(.xmarkCircleFill)
                    .imageScale(.medium)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    OtherTextField(text: $text)
}
