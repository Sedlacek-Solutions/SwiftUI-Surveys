//
//  SurveyAnswer.swift
//
//  Created by James Sedlacek on 2/3/25.
//

import SwiftUI

/// A single answer option for a survey question.
public struct SurveyAnswer: Identifiable, Codable {
    /// Stable identifier for this answer.
    public let id: String
    /// Localization key for the answer title.
    public let titleKey: String
    /// Optional SF Symbol name to display with the answer.
    public let systemImage: String?

    // Internal string representation for "other" answers and debugging
    internal let titleString: String?

    /// Creates a survey answer with a localization key and optional system image.
    /// - Parameters:
    ///   - id: Stable identifier for the answer.
    ///   - titleKey: Localization key for the answer title.
    ///   - systemImage: Optional SF Symbol name to display.
    public init(
        id: String = UUID().uuidString,
        titleKey: String,
        systemImage: String? = nil
    ) {
        self.id = id
        self.titleKey = titleKey
        self.systemImage = systemImage
        self.titleString = nil
    }

    internal init(
        id: String = UUID().uuidString,
        titleKey: String,
        titleString: String,
        systemImage: String? = nil
    ) {
        self.id = id
        self.titleKey = titleKey
        self.titleString = titleString
        self.systemImage = systemImage
    }

    /// Localized SwiftUI title derived from ``titleKey``.
    public var title: LocalizedStringKey {
        LocalizedStringKey(titleKey)
    }
}

extension SurveyAnswer: Hashable {
    public static func == (lhs: SurveyAnswer, rhs: SurveyAnswer) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension SurveyAnswer: ExpressibleByStringLiteral {
    /// Creates a survey answer from a string literal used as the localization key.
    /// - Parameter value: The localization key for the answer title.
    public init(stringLiteral value: String) {
        self.id = UUID().uuidString
        self.titleKey = value
        self.titleString = nil
        self.systemImage = nil
    }
}
