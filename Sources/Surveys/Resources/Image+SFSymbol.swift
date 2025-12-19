//
//  Image+SFSymbol.swift
//
//  Created by James Sedlacek on 2/1/25.
//

import SwiftUI

public enum SFSymbol: String, Hashable {
    case checkmarkCircleFill = "checkmark.circle.fill"
    case circle
}

extension Image {
    init(_ symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}
