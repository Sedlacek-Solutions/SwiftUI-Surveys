//
//  SurveyQuestion.swift
//
//  Created by James Sedlacek on 11/13/24.
//

import SwiftUI

/// A question with a localized title and a list of selectable answers.
public struct SurveyQuestion: Identifiable, Codable {
    /// Stable identifier for this question.
    public let id: String
    /// Localization key for the question title.
    public let titleKey: String
    /// Available answers for the question.
    public let answers: [SurveyAnswer]
    /// Whether multiple answers can be selected.
    public let isMultipleChoice: Bool
    /// Whether an "Other" free-text field is included.
    public let includeOther: Bool

    /// Creates a survey question with localized content and configuration.
    /// - Parameters:
    ///   - id: Stable identifier for the question.
    ///   - titleKey: Localization key for the question title.
    ///   - answers: Available answers for the question.
    ///   - isMultipleChoice: Whether multiple answers can be selected.
    ///   - includeOther: Whether an "Other" free-text field is included.
    public init(
        id: String = UUID().uuidString,
        titleKey: String,
        answers: [SurveyAnswer],
        isMultipleChoice: Bool = false,
        includeOther: Bool = false
    ) {
        self.id = id
        self.titleKey = titleKey
        self.answers = answers
        self.isMultipleChoice = isMultipleChoice
        self.includeOther = includeOther
    }

    /// Localized SwiftUI title derived from ``titleKey``.
    public var title: LocalizedStringKey {
        LocalizedStringKey(titleKey)
    }
}

extension SurveyQuestion: Hashable {
    public static func == (lhs: SurveyQuestion, rhs: SurveyQuestion) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
