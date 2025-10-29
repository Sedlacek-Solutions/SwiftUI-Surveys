//
//  SurveyQuestion.swift
//
//  Created by James Sedlacek on 11/13/24.
//

public struct SurveyQuestion: Hashable {
    public let title: String
    public let answers: [String]
    public let isMultipleChoice: Bool
    public let includeOther: Bool

    public init(
        title: String,
        answers: [String],
        isMultipleChoice: Bool = false,
        includeOther: Bool = false
    ) {
        self.title = title
        self.answers = answers
        self.isMultipleChoice = isMultipleChoice
        self.includeOther = includeOther
    }
}

extension [SurveyQuestion] {
    public static func mock() -> Self {
        [
            .init(
                title: "How satisfied are you with our service?",
                answers: [
                    "Very satisfied",
                    "Satisfied",
                    "Neutral",
                    "Dissatisfied",
                    "Very dissatisfied"
                ]
            ),
            .init(
                title: "Which features do you use most often?",
                answers: [
                    "Messaging",
                    "File sharing",
                    "Video calls",
                    "Calendar",
                    "Task management"
                ],
                isMultipleChoice: true
            ),
            .init(
                title: "What is your preferred method of contact?",
                answers: [
                    "Email",
                    "Phone",
                    "Text message",
                    "In-app notification"
                ],
                includeOther: true
            ),
            .init(
                title: "Which improvements would you like to see?",
                answers: [
                    "Faster performance",
                    "Better UI/UX",
                    "More features",
                    "Better integration",
                    "Enhanced security"
                ],
                isMultipleChoice: true,
                includeOther: true
            )
        ]
    }
}
