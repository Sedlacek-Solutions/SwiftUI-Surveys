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
        HStack(spacing: 10) {
            configuration.icon
                .foregroundStyle(iconColor)
                .font(.title3.weight(.medium))

            configuration.title
                .foregroundStyle(textColor)
        }
        .font(.body.weight(.medium))
    }
}

extension LabelStyle where Self == ColoredIconLabelStyle {
    @MainActor @preconcurrency
    static var coloredIcon: ColoredIconLabelStyle {
        .init(iconColor: .blue, textColor: .primary)
    }

    @MainActor @preconcurrency
    static func coloredIcon(
        iconColor: Color = .blue,
        textColor: Color = .primary
    ) -> ColoredIconLabelStyle {
        .init(iconColor: iconColor, textColor: textColor)
    }
}
