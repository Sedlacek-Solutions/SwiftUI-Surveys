//
//  SurveyAnswer.swift
//
//  Created by James Sedlacek on 2/3/25.
//

import SwiftUI

public struct SurveyAnswer: Identifiable {
    public let id: String
    public let title: LocalizedStringKey
    public let systemImage: String?
    
    // Internal string representation for "other" answers and debugging
    internal let titleString: String?

    public init(
        id: String = UUID().uuidString,
        title: LocalizedStringKey,
        systemImage: String? = nil
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.titleString = nil
    }
    
    internal init(
        id: String = UUID().uuidString,
        title: LocalizedStringKey,
        titleString: String,
        systemImage: String? = nil
    ) {
        self.id = id
        self.title = title
        self.titleString = titleString
        self.systemImage = systemImage
    }
}

extension SurveyAnswer: Hashable {
    public static func == (lhs: SurveyAnswer, rhs: SurveyAnswer) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension SurveyAnswer: ExpressibleByStringLiteral {
    /// Creates a SurveyAnswer from a string literal.
    /// - Parameter value: The string value to use as the answer title.
    public init(stringLiteral value: String) {
        self.id = UUID().uuidString
        self.title = LocalizedStringKey(value)
        self.titleString = nil
        self.systemImage = nil
    }
}
