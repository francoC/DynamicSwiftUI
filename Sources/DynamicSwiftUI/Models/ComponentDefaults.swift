//
//  ComponentDefaults.swift
//  DynamicSwiftUI
//
//  Created by Franco Castellano on 13/02/25.
//

import Foundation

struct ComponentDefaults: Decodable {
    let text: ComponentStyleDefaults?
    let button: ComponentStyleDefaults?
    let textfield: ComponentStyleDefaults?
    let slider: ComponentStyleDefaults?
    let toggle: ComponentStyleDefaults?
    let grid: ComponentStyleDefaults?
}

struct ComponentStyleDefaults: Decodable {
    let cornerRadius: CGFloat?
    let borderWidth: CGFloat?
    let borderColor: String?
    let backgroundColor: String?
    let foregroundColor: String?
    let fontSize: CGFloat?
    let minValue: CGFloat?
    let maxValue: CGFloat?
}
