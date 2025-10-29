//
//  Image+SFSymbol.swift
//
//  Created by James Sedlacek on 2/1/25.
//

import SwiftUI

extension Image {
    enum SFSymbol: String {
        case checkmarkCircleFill = "checkmark.circle.fill"
        case circle
        case xmarkCircleFill = "xmark.circle.fill"
    }

    init(_ symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}
