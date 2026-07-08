//
//  OtherTextField.swift
//
//  Created by James Sedlacek on 12/17/24.
//

import SwiftUI

@MainActor
struct OtherTextField {
    @FocusState private var focusState: Bool
    @Environment(\.surveyAccentColor) private var surveyAccentColor
    @Binding private var text: String

    var borderColor: Color {
        isSelected ? surveyAccentColor.opacity(0.6) : .clear
    }

    var isSelected: Bool {
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
            TextField(text: $text, prompt: Text(.other, bundle: .module)) {
                Text(.other, bundle: .module)
            }
                .focused($focusState)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)

            selectionIndicator
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(backgroundView)
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

    private var backgroundView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.background.secondary)

            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .fill(surveyAccentColor.opacity(0.03))
            }
        }
    }

    @ViewBuilder
    private var selectionIndicator: some View {
        if isSelected {
            Image(.checkmarkCircleFill)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, surveyAccentColor)
                .font(.title3.weight(.semibold))
        } else {
            Image(.circle)
                .foregroundStyle(.secondary)
                .font(.title3.weight(.semibold))
                .opacity(0.7)
        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    OtherTextField(text: $text)
}
