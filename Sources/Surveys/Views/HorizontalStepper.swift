//
//  HorizontalStepper.swift
//
//  Created by James Sedlacek on 11/12/24.
//

import SwiftUI

struct HorizontalStepper {
    private let step: Int
    private let total: Int
    private let spacing: CGFloat
    private let primaryColor: Color
    private let secondaryColor: Color

    init(
        step: Int,
        total: Int,
        spacing: CGFloat = 8,
        primaryColor: Color = .blue,
        secondaryColor: Color = .gray.opacity(0.3)
    ) {
        self.step = step
        self.total = total
        self.spacing = spacing
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }

    func fillColor(for index: Int) -> Color {
        index <= step ? primaryColor : secondaryColor
    }
}

extension HorizontalStepper: View {
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(
                1..<total + 1,
                id: \.self,
                content: stepView
            )
        }
    }

    private func stepView(for index: Int) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(fillColor(for: index))
            .frame(maxWidth: .infinity)
            .frame(height: 6)
    }
}

#Preview {
    VStack(spacing: 32) {
        HorizontalStepper(step: 1, total: 5)
        HorizontalStepper(step: 2, total: 5)
        HorizontalStepper(step: 3, total: 5)
        HorizontalStepper(step: 4, total: 5)
        HorizontalStepper(step: 5, total: 5)
    }
    .padding(20)
}
