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
                titleKey: "What best describes you?",
                answers: [
                    .init(titleKey: "Learning & exploring", systemImage: "graduationcap"),
                    .init(titleKey: "Solo founder", systemImage: "person"),
                    .init(titleKey: "Small team", systemImage: "person.2"),
                    .init(titleKey: "Startup", systemImage: "person.3"),
                    .init(titleKey: "Agency / Studio", systemImage: "briefcase"),
                    .init(titleKey: "Enterprise", systemImage: "building.columns")
                ]
            ),
            .init(
                titleKey: "How many apps do you manage?",
                answers: [
                    .init(titleKey: "None yet", systemImage: "app.dashed"),
                    .init(titleKey: "One app", systemImage: "app"),
                    .init(titleKey: "A few apps (2–5)", systemImage: "square.stack.3d.up"),
                    .init(titleKey: "Several apps (6–20)", systemImage: "square.stack.3d.up.fill"),
                    .init(titleKey: "Many apps (20+)", systemImage: "building.2")
                ]
            ),
            .init(
                titleKey: "How did you hear about us?",
                answers: [
                    .init(titleKey: "App Store search", systemImage: "magnifyingglass"),
                    .init(titleKey: "Social media", systemImage: "bubble.left.and.bubble.right"),
                    .init(titleKey: "Friend or colleague", systemImage: "person.2"),
                    .init(titleKey: "Online article or blog", systemImage: "doc.text"),
                    .init(titleKey: "Podcast or video", systemImage: "play.rectangle")
                ],
                includeOther: true
            ),
            .init(
                titleKey: "What do you find most frustrating?",
                answers: [
                    .init(titleKey: "Annoying sign-in", systemImage: "person.badge.key"),
                    .init(titleKey: "Hard to spot trends", systemImage: "waveform.path.ecg"),
                    .init(titleKey: "Unclear sentiment", systemImage: "face.smiling.inverse"),
                    .init(titleKey: "Confusing interface", systemImage: "rectangle.and.pencil.and.ellipsis"),
                    .init(titleKey: "Poor multi-platform support", systemImage: "macbook.and.iphone"),
                    .init(titleKey: "Nothing yet", systemImage: "questionmark.circle")
                ],
                isMultipleChoice: true
            ),
            .init(
                titleKey: "How often do you expect to use this app?",
                answers: [
                    .init(titleKey: "Multiple times per day", systemImage: "bolt"),
                    .init(titleKey: "Daily", systemImage: "sun.max"),
                    .init(titleKey: "Weekly", systemImage: "calendar"),
                    .init(titleKey: "Occasionally", systemImage: "clock"),
                    .init(titleKey: "Just trying it out", systemImage: "hand.thumbsup")
                ]
            )
        ]
    }
}
