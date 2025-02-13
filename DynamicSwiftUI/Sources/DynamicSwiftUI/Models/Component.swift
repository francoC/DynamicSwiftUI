//
//  Component.swift
//  DynamicSwiftUI
//
//  Created by Franco Castellano on 13/02/25.
//

import Foundation

struct Component: Decodable, Identifiable {
    let id: String
    let type: String
    let content: String?
    let url: String?
    let width: CGFloat?
    let height: CGFloat?
    let padding: CGFloat?
    let foregroundColor: String?
    let backgroundColor: String?
    let fontSize: CGFloat?
    let alignment: String?
    let components: [Component]?
    let action: DynamicAction?
    let stateKey: String?
    let placeholder: String?
    let cornerRadius: CGFloat?
    let borderWidth: CGFloat?
    let borderColor: String?
    let animation: String?
    let minValue: CGFloat?
    let maxValue: CGFloat?
    let columns: Int?
    let rows: Int?
}
