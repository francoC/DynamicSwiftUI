//
//  PluginSystem.swift
//  DynamicSwiftUI
//
//  Created by Franco Castellano on 13/02/25.
//

public struct PluginConfig {
    var defaultScreenFile: String?
    var componentsDefaultsFile: String?
    
    public init(defaultScreenFile: String? = nil, componentsDefaultsFile: String? = nil) {
        self.defaultScreenFile = defaultScreenFile
        self.componentsDefaultsFile = componentsDefaultsFile
    }
}
