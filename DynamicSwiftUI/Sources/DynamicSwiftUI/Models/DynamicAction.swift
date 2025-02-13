//
//  DynamicAction.swift
//  DynamicSwiftUI
//
//  Created by Franco Castellano on 13/02/25.
//

struct DynamicAction: Decodable {
    let type: String
    let payload: [String: String]?
}
