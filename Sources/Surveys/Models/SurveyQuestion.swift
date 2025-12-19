//
//  SurveyQuestion.swift
//
//  Created by James Sedlacek on 11/13/24.
//

import SwiftUI

public struct SurveyQuestion: Identifiable {
    public let id: String
    public let title: LocalizedStringKey
    public let answers: [SurveyAnswer]
    public let isMultipleChoice: Bool
    public let includeOther: Bool

    public init(
        id: String = UUID().uuidString,
        title: LocalizedStringKey,
        answers: [SurveyAnswer],
        isMultipleChoice: Bool = false,
        includeOther: Bool = false
    ) {
        self.id = id
        self.title = title
        self.answers = answers
        self.isMultipleChoice = isMultipleChoice
        self.includeOther = includeOther
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
