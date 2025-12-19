//
//  SurveyQuestion+Mock.swift
//  SwiftUISurveys
//
//  Created by James Sedlacek on 12/19/25.
//

extension [SurveyQuestion] {
    public static func mock() -> Self {
        [
            .init(
                title: "What best describes you?",
                answers: [
                    .init(title: "Learning & exploring", systemImage: "graduationcap"),
                    .init(title: "Solo founder", systemImage: "person"),
                    .init(title: "Small team", systemImage: "person.2"),
                    .init(title: "Startup", systemImage: "person.3"),
                    .init(title: "Agency / Studio", systemImage: "briefcase"),
                    .init(title: "Enterprise", systemImage: "building.columns")
                ]
            ),
            .init(
                title: "How many apps do you manage?",
                answers: [
                    .init(title: "None yet", systemImage: "app.dashed"),
                    .init(title: "One app", systemImage: "app"),
                    .init(title: "A few apps (2–5)", systemImage: "square.stack.3d.up"),
                    .init(title: "Several apps (6–20)", systemImage: "square.stack.3d.up.fill"),
                    .init(title: "Many apps (20+)", systemImage: "building.2")
                ]
            ),
            .init(
                title: "How did you hear about us?",
                answers: [
                    .init(title: "App Store search", systemImage: "magnifyingglass"),
                    .init(title: "Social media", systemImage: "bubble.left.and.bubble.right"),
                    .init(title: "Friend or colleague", systemImage: "person.2"),
                    .init(title: "Online article or blog", systemImage: "doc.text"),
                    .init(title: "Podcast or video", systemImage: "play.rectangle")
                ],
                includeOther: true
            ),
            .init(
                title: "What do you find most frustrating?",
                answers: [
                    .init(title: "Annoying sign-in", systemImage: "person.badge.key"),
                    .init(title: "Hard to spot trends", systemImage: "waveform.path.ecg"),
                    .init(title: "Unclear sentiment", systemImage: "face.smiling.inverse"),
                    .init(title: "Confusing interface", systemImage: "rectangle.and.pencil.and.ellipsis"),
                    .init(title: "Poor multi-platform support", systemImage: "macbook.and.iphone"),
                    .init(title: "Nothing yet", systemImage: "questionmark.circle")
                ],
                isMultipleChoice: true
            ),
            .init(
                title: "How often do you expect to use this app?",
                answers: [
                    .init(title: "Multiple times per day", systemImage: "bolt"),
                    .init(title: "Daily", systemImage: "sun.max"),
                    .init(title: "Weekly", systemImage: "calendar"),
                    .init(title: "Occasionally", systemImage: "clock"),
                    .init(title: "Just trying it out", systemImage: "hand.thumbsup")
                ]
            )
        ]
    }
}
