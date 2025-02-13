//
//  View.swift
//  DynamicSwiftUI
//
//  Created by Franco Castellano on 13/02/25.
//

import SwiftUI

extension View {
    func applyAnimation(named animation: String?, value: String?) -> some View {
        guard let value = value, !value.isEmpty else { return self }
        switch animation {
        case "easeInOut":
            return self.animation(.easeInOut, value: value)
        case "spring":
            return self.animation(.spring(), value: value)
        case "linear":
            return self.animation(.linear, value: value)
        default:
            return self
        }
    }
}
