//
//  ScreenData.swift
//  DynamicSwiftUI
//
//  Created by Franco Castellano on 13/02/25.
//

struct ScreenData: Decodable {
    let screenName: String
    let layout: String
    let components: [Component]
}
