//
//  SurveyAnswer.swift
//
//  Created by James Sedlacek on 2/3/25.
//

public struct SurveyAnswer: Hashable {
    public let identifier: String?
    public let title: String
    public let systemImage: String?

    public init(identifier: String? = nil, title: String, systemImage: String? = nil) {
        self.identifier = identifier
        self.title = title
        self.systemImage = systemImage
    }

    public static func == (lhs: SurveyAnswer, rhs: SurveyAnswer) -> Bool {
        lhs.title == rhs.title
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
