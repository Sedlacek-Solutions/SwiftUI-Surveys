//
//  SurveyFlowStep.swift
//
//  Created by James Sedlacek on 7/4/26.
//

import SwiftUI

/// A runtime-only survey step that can contain arbitrary SwiftUI content.
@MainActor
public struct SurveyFlowStep: Identifiable {
    enum CustomFooter {
        case automatic
        case hidden
        case custom(@MainActor (SurveyFlowContinuation) -> AnyView)
    }

    enum Storage {
        case question(SurveyQuestion)
        case discoveryQuestion(SurveyDiscoveryQuestion)
        case content(SurveyContentStep)
        case custom(
            isScrollable: Bool,
            footer: CustomFooter,
            content: @MainActor (SurveyFlowContinuation) -> AnyView
        )
    }

    /// Stable identifier for this flow step.
    public let id: String
    let storage: Storage

    /// Creates a question step.
    public static func question(_ question: SurveyQuestion) -> Self {
        .init(id: question.id, storage: .question(question))
    }

    /// Creates a runtime discovery-source question step.
    public static func discoveryQuestion(_ question: SurveyDiscoveryQuestion) -> Self {
        .init(id: question.id, storage: .discoveryQuestion(question))
    }

    /// Creates a Codable content step.
    public static func content(_ content: SurveyContentStep) -> Self {
        .init(id: content.id, storage: .content(content))
    }

    /// Creates a custom SwiftUI content step.
    public static func custom<Content: View>(
        id: String = UUID().uuidString,
        isScrollable: Bool = true,
        @ViewBuilder content: @escaping @MainActor () -> Content
    ) -> Self {
        .init(
            id: id,
            storage: .custom(
                isScrollable: isScrollable,
                footer: .automatic,
                content: { _ in AnyView(content()) }
            )
        )
    }

    /// Creates custom SwiftUI content that can control its survey navigation.
    ///
    /// Use `footer: .hidden` when the content owns all bottom actions. The default
    /// package Continue button remains available with `footer: .automatic`.
    public static func custom<Content: View>(
        id: String = UUID().uuidString,
        isScrollable: Bool = true,
        footer: SurveyFlowStepFooter,
        @ViewBuilder content: @escaping @MainActor (SurveyFlowContinuation) -> Content
    ) -> Self {
        .init(
            id: id,
            storage: .custom(
                isScrollable: isScrollable,
                footer: footer.storage,
                content: { continuation in AnyView(content(continuation)) }
            )
        )
    }

    /// Creates custom SwiftUI content with an app-owned bottom section.
    ///
    /// The footer is placed in the flow's bottom safe-area inset and receives the
    /// same continuation as the main content.
    public static func custom<Content: View, Footer: View>(
        id: String = UUID().uuidString,
        isScrollable: Bool = true,
        @ViewBuilder content: @escaping @MainActor (SurveyFlowContinuation) -> Content,
        @ViewBuilder footer: @escaping @MainActor (SurveyFlowContinuation) -> Footer
    ) -> Self {
        .init(
            id: id,
            storage: .custom(
                isScrollable: isScrollable,
                footer: .custom { continuation in AnyView(footer(continuation)) },
                content: { continuation in AnyView(content(continuation)) }
            )
        )
    }

    init(id: String, storage: Storage) {
        self.id = id
        self.storage = storage
    }
}

/// Controls whether a continuation-aware custom step uses the package footer.
public enum SurveyFlowStepFooter: Sendable {
    /// Show the package-owned Continue button.
    case automatic
    /// Do not show a package-owned footer.
    case hidden

    fileprivate var storage: SurveyFlowStep.CustomFooter {
        switch self {
        case .automatic:
            .automatic
        case .hidden:
            .hidden
        }
    }
}

extension SurveyFlowStep {
    /// The broad type of runtime step.
    public var stepType: SurveyFlowStepType {
        switch storage {
        case .question, .discoveryQuestion:
            .question
        case .content:
            .content
        case .custom:
            .custom
        }
    }

    /// The question carried by this step, if this is a question step.
    public var question: SurveyQuestion? {
        switch storage {
        case .question(let question):
            question
        case .discoveryQuestion(let question):
            question.question
        case .content, .custom:
            nil
        }
    }

    /// The content model carried by this step, if this is a Codable content step.
    public var content: SurveyContentStep? {
        guard case .content(let content) = storage else { return nil }
        return content
    }

    /// The equivalent Codable survey step, if this runtime step can be represented as data.
    public var surveyStep: SurveyStep? {
        switch storage {
        case .question(let question):
            .question(question)
        case .content(let content):
            .content(content)
        case .discoveryQuestion, .custom:
            nil
        }
    }

    /// Whether this step contains custom SwiftUI content.
    public var isCustom: Bool {
        stepType == .custom
    }

    init(_ step: SurveyStep) {
        switch step {
        case .question(let question):
            self = .question(question)
        case .content(let content):
            self = .content(content)
        }
    }
}

/// The broad type of a runtime survey flow step.
public enum SurveyFlowStepType {
    /// A question step that collects answers.
    case question
    /// A data-driven content step.
    case content
    /// A runtime-only custom SwiftUI content step.
    case custom
}
