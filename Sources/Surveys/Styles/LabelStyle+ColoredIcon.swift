//
//  LabelStyle+ColoredIcon.swift
//  SwiftUISurveys
//
//  Created by James Sedlacek on 12/18/25.
//

import SwiftUI

struct ColoredIconLabelStyle: LabelStyle {
    var iconColor: Color
    var textColor: Color = .primary

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 12) {
            configuration.icon
                .foregroundStyle(.white)
                .font(.subheadline.weight(.semibold))
                .frame(width: 32, height: 30)
                .background(iconBackground)

            configuration.title
                .foregroundStyle(textColor)
        }
        .font(.body.weight(.medium))
    }

    private var iconBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.quaternary)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.8))
            }
    }
}

extension LabelStyle where Self == ColoredIconLabelStyle {
    @MainActor @preconcurrency
    static var coloredIcon: ColoredIconLabelStyle {
        .init(iconColor: .accentColor, textColor: .primary)
    }

    @MainActor @preconcurrency
    static func coloredIcon(
        iconColor: Color = .accentColor,
        textColor: Color = .primary
    ) -> ColoredIconLabelStyle {
        .init(iconColor: iconColor, textColor: textColor)
    }
}
