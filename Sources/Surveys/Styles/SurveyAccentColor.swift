//
//  SurveyAccentColor.swift
//
//  Created by James Sedlacek on 7/7/26.
//

import SwiftUI

private struct SurveyAccentColorKey: EnvironmentKey {
    static let defaultValue: Color = .blue
}

public extension EnvironmentValues {
    var surveyAccentColor: Color {
        get { self[SurveyAccentColorKey.self] }
        set { self[SurveyAccentColorKey.self] = newValue }
    }
}

public extension View {
    func surveyAccentColor(_ color: Color) -> some View {
        environment(\.surveyAccentColor, color)
    }
}
