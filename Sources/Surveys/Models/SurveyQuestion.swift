//
//  SurveyQuestion.swift
//
//  Created by James Sedlacek on 11/13/24.
//

public struct SurveyQuestion: Hashable, Identifiable {
    public let identifier: String?
    public let title: String
    public let answers: [SurveyAnswer]
    public let isMultipleChoice: Bool
    public let includeOther: Bool
    
    /// Computed ID for Identifiable conformance.
    /// Uses title to be consistent with equality and hashing behavior.
    public var id: String {
        title
    }

    public init(
        identifier: String? = nil,
        title: String,
        answers: [SurveyAnswer],
        isMultipleChoice: Bool = false,
        includeOther: Bool = false
    ) {
        self.identifier = identifier
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
                identifier: "q1",
                title: "What best describes you?",
                answers: [
                    .init(identifier: "q1-a1", title: "Learning & exploring", systemImage: "graduationcap"),
                    .init(identifier: "q1-a2", title: "Solo founder", systemImage: "person"),
                    .init(identifier: "q1-a3", title: "Small team", systemImage: "person.2"),
                    .init(identifier: "q1-a4", title: "Startup", systemImage: "person.3"),
                    .init(identifier: "q1-a5", title: "Agency / Studio", systemImage: "briefcase"),
                    .init(identifier: "q1-a6", title: "Enterprise", systemImage: "building.columns")
                ]
            ),
            .init(
                identifier: "q2",
                title: "How many apps do you manage?",
                answers: [
                    .init(identifier: "q2-a1", title: "None yet", systemImage: "app.dashed"),
                    .init(identifier: "q2-a2", title: "One app", systemImage: "app"),
                    .init(identifier: "q2-a3", title: "A few apps (2–5)", systemImage: "square.stack.3d.up"),
                    .init(identifier: "q2-a4", title: "Several apps (6–20)", systemImage: "square.stack.3d.up.fill"),
                    .init(identifier: "q2-a5", title: "Many apps (20+)", systemImage: "building.2")
                ]
            ),
            .init(
                identifier: "q3",
                title: "How did you hear about us?",
                answers: [
                    .init(identifier: "q3-a1", title: "App Store search", systemImage: "magnifyingglass"),
                    .init(identifier: "q3-a2", title: "Social media", systemImage: "bubble.left.and.bubble.right"),
                    .init(identifier: "q3-a3", title: "Friend or colleague", systemImage: "person.2"),
                    .init(identifier: "q3-a4", title: "Online article or blog", systemImage: "doc.text"),
                    .init(identifier: "q3-a5", title: "Podcast or video", systemImage: "play.rectangle")
                ],
                includeOther: true
            ),
            .init(
                identifier: "q4",
                title: "What do you find most frustrating?",
                answers: [
                    .init(identifier: "q4-a1", title: "Annoying sign-in", systemImage: "person.badge.key"),
                    .init(identifier: "q4-a2", title: "Hard to spot trends", systemImage: "waveform.path.ecg"),
                    .init(identifier: "q4-a3", title: "Unclear sentiment", systemImage: "face.smiling.inverse"),
                    .init(identifier: "q4-a4", title: "Confusing interface", systemImage: "rectangle.and.pencil.and.ellipsis"),
                    .init(identifier: "q4-a5", title: "Poor multi-platform support", systemImage: "macbook.and.iphone"),
                    .init(identifier: "q4-a6", title: "Nothing yet", systemImage: "questionmark.circle")
                ],
                isMultipleChoice: true
            ),
            .init(
                identifier: "q5",
                title: "How often do you expect to use this app?",
                answers: [
                    .init(identifier: "q5-a1", title: "Multiple times per day", systemImage: "bolt"),
                    .init(identifier: "q5-a2", title: "Daily", systemImage: "sun.max"),
                    .init(identifier: "q5-a3", title: "Weekly", systemImage: "calendar"),
                    .init(identifier: "q5-a4", title: "Occasionally", systemImage: "clock"),
                    .init(identifier: "q5-a5", title: "Just trying it out", systemImage: "hand.thumbsup")
                ]
            )
        ]
    }
}
