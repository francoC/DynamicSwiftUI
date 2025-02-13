//
//  DynamicViewModel.swift
//  DynamicSwiftUI
//
//  Created by Franco Castellano on 13/02/25.
//

import SwiftUI

@MainActor
public class DynamicScreenViewModel: ObservableObject {
    @Published var screenData: ScreenData?
    @Published var dynamicStates: [String: String] = [:]
    private var componentDefaults: ComponentDefaults?
    @Published public var navigationPath: NavigationPath = NavigationPath()
    
    private let pluginConfig: PluginConfig
        
    init(config: PluginConfig = PluginConfig()) {
        self.pluginConfig = config
    }
    
    public convenience init(configuration: PluginConfig = PluginConfig()) {
        self.init(config: configuration)
    }
    
    public func loadScreen(from url: String) {
        loadComponentDefaults(from: pluginConfig.componentsDefaultsFile ?? "componentDefaults")
        if url.starts(with: "http") {
            loadScreenFromNetwork(url: url)
        } else {
            loadScreenFromLocalJSON(named: pluginConfig.defaultScreenFile ?? url)
        }
    }
    
    private func loadScreenFromNetwork(url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                Task { @MainActor in
                    self.decodeScreenData(from: data)
                }
            }
        }.resume()
    }
    
    private func loadScreenFromLocalJSON(named fileName: String) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            decodeScreenData(from: data)
        }
    }
    
    private func decodeScreenData(from data: Data) {
        if let decoded = try? JSONDecoder().decode(ScreenData.self, from: data) {
            DispatchQueue.main.async {
                self.screenData = decoded
            }
        }
    }
    
    func loadComponentDefaults(from fileName: String) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let defaults = try? JSONDecoder().decode(ComponentDefaults.self, from: data) {
            componentDefaults = defaults
        }
    }
    
    func binding(for key: String?) -> Binding<String> {
        let safeKey = key ?? UUID().uuidString
        if dynamicStates[safeKey] == nil {
            dynamicStates[safeKey] = ""
        }
        return Binding(
            get: { self.dynamicStates[safeKey] ?? "" },
            set: { self.dynamicStates[safeKey] = $0 }
        )
    }
    
    func getDefault(for type: String) -> ComponentStyleDefaults? {
        switch type {
        case "Text": return componentDefaults?.text
        case "Button": return componentDefaults?.button
        case "TextField": return componentDefaults?.textfield
        case "Toggle": return componentDefaults?.toggle
        case "Slider": return componentDefaults?.slider
        case "Grid": return componentDefaults?.grid
        default: return nil
        }
    }
    
    func handleAction(_ actionData: DynamicAction) {
        switch actionData.type {
        case "navigate":
            if let destination = actionData.payload?["destination"] {
                Task { @MainActor in
                    self.navigationPath.append(destination)
                }
            }
        case "updateState":
            if let key = actionData.payload?["key"], let value = actionData.payload?["value"] {
                withAnimation(.easeInOut) {
                    dynamicStates[key] = value
                }
            }
        case "openURL":
            if let urlString = actionData.payload?["url"], let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        case "toggle":
            if let key = actionData.payload?["key"] {
                withAnimation(.spring()) {
                    dynamicStates[key] = (dynamicStates[key] == "true" ? "false" : "true")
                }
            }
        default:
            print("Unhandled action: \(actionData.type)")
        }
    }
}
