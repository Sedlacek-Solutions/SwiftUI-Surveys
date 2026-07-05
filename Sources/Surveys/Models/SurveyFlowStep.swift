//
//  SurveyFlowStep.swift
//
//  Created by James Sedlacek on 7/4/26.
//

import SwiftUI

/// A runtime-only survey step that can contain arbitrary SwiftUI content.
@MainActor
public struct SurveyFlowStep: Identifiable {
    enum Storage {
        case question(SurveyQuestion)
        case content(SurveyContentStep)
        case custom(isScrollable: Bool, content: @MainActor () -> AnyView)
    }

    /// Stable identifier for this flow step.
    public let id: String
    let storage: Storage

    /// Creates a question step.
    public static func question(_ question: SurveyQuestion) -> Self {
        .init(id: question.id, storage: .question(question))
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
                content: { AnyView(content()) }
            )
        )
    }

    init(id: String, storage: Storage) {
        self.id = id
        self.storage = storage
    }
}

extension SurveyFlowStep {
    /// The broad type of runtime step.
    public var stepType: SurveyFlowStepType {
        switch storage {
        case .question:
            .question
        case .content:
            .content
        case .custom:
            .custom
        }
    }

    /// The question carried by this step, if this is a question step.
    public var question: SurveyQuestion? {
        guard case .question(let question) = storage else { return nil }
        return question
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
        case .custom:
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
