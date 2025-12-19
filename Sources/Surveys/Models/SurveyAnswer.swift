//
//  SurveyAnswer.swift
//
//  Created by James Sedlacek on 2/3/25.
//

import Foundation

public struct SurveyAnswer: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let systemImage: String?

    public init(
        id: String = UUID().uuidString,
        title: String,
        systemImage: String? = nil
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
    }
}
