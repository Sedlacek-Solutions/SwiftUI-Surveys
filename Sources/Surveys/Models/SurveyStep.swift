//
//  SurveyStep.swift
//
//  Created by James Sedlacek on 7/4/26.
//

import SwiftUI

/// A single screen in a survey flow.
public enum SurveyStep: Identifiable, Codable, Hashable {
    /// A screen that asks the user to select one or more answers.
    case question(SurveyQuestion)
    /// A screen that presents informational content without collecting an answer.
    case content(SurveyContentStep)

    /// Stable identifier for this step.
    public var id: String {
        switch self {
        case .question(let question):
            question.id
        case .content(let content):
            content.id
        }
    }
}

/// Informational content shown as a step in a survey flow.
public struct SurveyContentStep: Identifiable, Codable, Hashable {
    /// Stable identifier for this content step.
    public let id: String
    /// Localization key for the content title.
    public let titleKey: String
    /// Optional localization key for supporting body text.
    public let bodyKey: String?
    /// Optional media displayed between the title and body.
    public let media: SurveyContentMedia?

    /// Creates an informational survey step.
    /// - Parameters:
    ///   - id: Stable identifier for the content step.
    ///   - titleKey: Localization key for the content title.
    ///   - bodyKey: Optional localization key for supporting body text.
    ///   - media: Optional media displayed between the title and body.
    public init(
        id: String = UUID().uuidString,
        titleKey: String,
        bodyKey: String? = nil,
        media: SurveyContentMedia? = nil
    ) {
        self.id = id
        self.titleKey = titleKey
        self.bodyKey = bodyKey
        self.media = media
    }

    /// Localized SwiftUI title derived from ``titleKey``.
    public var title: LocalizedStringKey {
        LocalizedStringKey(titleKey)
    }

    /// Localized SwiftUI body text derived from ``bodyKey``.
    public var body: LocalizedStringKey? {
        bodyKey.map { LocalizedStringKey($0) }
    }
}

/// Media that can be displayed in a ``SurveyContentStep``.
public enum SurveyContentMedia: Codable, Hashable {
    /// An SF Symbol name.
    case systemImage(String)
    /// An image asset name resolved by SwiftUI.
    case asset(name: String)
}
