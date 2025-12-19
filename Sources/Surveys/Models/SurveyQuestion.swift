//
//  SurveyQuestion.swift
//
//  Created by James Sedlacek on 11/13/24.
//

public struct SurveyQuestion: Hashable {
    public let title: String
    public let answers: [SurveyAnswer]
    public let isMultipleChoice: Bool
    public let includeOther: Bool

    public init(
        title: String,
        answers: [SurveyAnswer],
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
                    .init(title: "Very satisfied", systemImage: "hand.thumbsup"),
                    .init(title: "Satisfied", systemImage: "hand.thumbsup"),
                    .init(title: "Neutral", systemImage: "hand.raised"),
                    .init(title: "Dissatisfied", systemImage: "hand.thumbsdown"),
                    .init(title: "Very dissatisfied", systemImage: "hand.thumbsdown.fill")
                ]
            ),
            .init(
                title: "Which features do you use most often?",
                answers: [
                    .init(title: "Messaging", systemImage: "message"),
                    .init(title: "File sharing", systemImage: "folder"),
                    .init(title: "Video calls", systemImage: "video"),
                    .init(title: "Calendar", systemImage: "calendar"),
                    .init(title: "Task management", systemImage: "checklist")
                ],
                isMultipleChoice: true
            ),
            .init(
                title: "What is your preferred method of contact?",
                answers: [
                    .init(title: "Email", systemImage: "envelope"),
                    .init(title: "Phone", systemImage: "phone"),
                    .init(title: "Text message", systemImage: "text.bubble"),
                    .init(title: "In-app notification", systemImage: "bell")
                ],
                includeOther: true
            ),
            .init(
                title: "Which improvements would you like to see?",
                answers: [
                    .init(title: "Faster performance", systemImage: "speedometer"),
                    .init(title: "Better UI/UX", systemImage: "paintbrush"),
                    .init(title: "More features", systemImage: "sparkles"),
                    .init(title: "Better integration", systemImage: "link"),
                    .init(title: "Enhanced security", systemImage: "lock.shield")
                ],
                isMultipleChoice: true,
                includeOther: true
            )
        ]
    }
}
