//
//  SurveyAnswer.swift
//
//  Created by James Sedlacek on 2/3/25.
//

public struct SurveyAnswer: Hashable, ExpressibleByStringLiteral {
    public let title: String
    public let systemImage: String?

    public init(title: String, systemImage: String? = nil) {
        self.title = title
        self.systemImage = systemImage
    }

    // MARK: - ExpressibleByStringLiteral Conformance
    
    /// Creates a SurveyAnswer from a string literal.
    /// - Parameter value: The string value to use as the answer title.
    public init(stringLiteral value: String) {
        self.title = value
        self.systemImage = nil
    }

    public static func == (lhs: SurveyAnswer, rhs: SurveyAnswer) -> Bool {
        lhs.title == rhs.title
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
