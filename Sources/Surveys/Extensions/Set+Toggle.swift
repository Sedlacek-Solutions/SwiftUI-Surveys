//
//  Set+Toggle.swift
//
//  Created by James Sedlacek on 11/13/24.
//

import SwiftUI

extension Set {
    public mutating func toggle(_ element: Element) {
        if contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}
