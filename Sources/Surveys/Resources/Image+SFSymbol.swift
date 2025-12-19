//
//  Image+SFSymbol.swift
//
//  Created by James Sedlacek on 2/1/25.
//

import SwiftUI

public enum SFSymbol: String, Hashable {
    case checkmarkCircleFill = "checkmark.circle.fill"
    case circle
    case xmarkCircleFill = "xmark.circle.fill"
    case handThumbsup = "hand.thumbsup"
    case rectangleGrid2x2 = "rectangle.grid.2x2"
    case phone
    case sparkles
}

extension Image {
    init(_ symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}
