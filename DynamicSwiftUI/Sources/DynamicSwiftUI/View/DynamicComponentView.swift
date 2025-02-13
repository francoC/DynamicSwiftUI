//
//  DynamicComponentView.swift
//  DynamicSwiftUI
//
//  Created by Franco Castellano on 13/02/25.
//

import SwiftUI

struct DynamicComponentView: View {
    let component: Component
    @ObservedObject var viewModel: DynamicScreenViewModel
    
    var body: some View {
        generateView(from: component)
            .applyAnimation(named: component.animation, value: viewModel.dynamicStates[component.stateKey ?? ""] ?? "")
    }
    
    @ViewBuilder
    private func generateView(from component: Component) -> some View {
        let defaults = viewModel.getDefault(for: component.type)
        
        switch component.type {
        case "Text":
            generateText(from: component, with: defaults)
        case "Button":
            generateButton(from: component, with: defaults)
        case "VStack": VStack { generateChildren(for: component) }
        case "HStack": HStack { generateChildren(for: component) }
        case "ZStack": ZStack { generateChildren(for: component) }
        case "ScrollView": ScrollView { LazyVStack { generateChildren(for: component) } }
        case "Divider": Divider()
        case "Stepper": generateStepper(from: component, with: defaults)
        case "List": List(component.components ?? [], id: \.id) { child in
            generateChildren(for: child)
        }
        case "NavigationView": NavigationView { generateChildren(for: component) }
        case "TabView": TabView { generateChildren(for: component) }
        case "Image":
            generateImage(from: component)
        case "TextField":
            generateTextField(from: component, with: defaults)
        case "Toggle":
            generateToggle(from: component)
        case "Slider":
            generateSlider(from: component)
        case "Grid":
            generateGrid(from: component)
        case "LazyVGrid":
            generateLazyVGrid(from: component)
        case "LazyHGrid":
            generateLazyHGrid(from: component)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func generateChildren(for component: Component) -> some View {
        ForEach(component.components ?? [], id: \.id) { child in
            DynamicComponentView(component: child, viewModel: viewModel)
        }
    }
    
    private func replaceDynamicStates(in text: String) -> String {
        var updatedText = text
        for (key, value) in viewModel.dynamicStates {
            updatedText = updatedText.replacingOccurrences(of: "{\(key)}", with: value)
        }
        return updatedText
    }
    
    @ViewBuilder
    private func generateText(from component: Component, with defaults: ComponentStyleDefaults? = nil) -> some View {
        Text(replaceDynamicStates(in: component.content ?? ""))
            .font(.system(size: component.fontSize ?? defaults?.fontSize ?? 16))
            .foregroundColor(Color(hex: component.foregroundColor ?? defaults?.foregroundColor ?? "000000"))
            .padding(component.padding ?? 0)
    }
    
    @ViewBuilder
    private func generateTextField(from component: Component, with defaults: ComponentStyleDefaults? = nil) -> some View {
        TextField(component.content ?? "", text: viewModel.binding(for: component.stateKey))
            .padding()
            .background(Color(hex: component.foregroundColor ?? defaults?.foregroundColor ?? "#78787833"))
            .cornerRadius(component.cornerRadius ?? defaults?.cornerRadius ?? 8)
    }
    
    @ViewBuilder
    private func generateButton(from component: Component, with defaults: ComponentStyleDefaults? = nil) -> some View {
        Button(action: {
            if let action = component.action {
                viewModel.handleAction(action)
            }
        }) {
            Text(component.content ?? "Button")
                .padding()
                .background(Color(hex: component.backgroundColor ?? defaults?.backgroundColor ?? "007AFF"))
                .foregroundColor(Color(hex: component.foregroundColor ?? defaults?.foregroundColor ?? "FFFFFF"))
                .cornerRadius(component.cornerRadius ?? defaults?.cornerRadius ?? 8)
        }
    }
    
    @ViewBuilder
    private func generateGrid(from component: Component, with defaults: ComponentStyleDefaults? = nil) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: component.columns ?? 2)) {
            ForEach(component.components ?? [], id: \.id) { child in
                generateChildren(for: child)
            }
        }
    }
    
    @ViewBuilder
    private func generateLazyVGrid(from component: Component, with defaults: ComponentStyleDefaults? = nil) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: component.columns ?? 2)) {
            ForEach(component.components ?? [], id: \.id) { child in
                generateChildren(for: child)
            }
        }
    }
    
    @ViewBuilder
    private func generateLazyHGrid(from component: Component, with defaults: ComponentStyleDefaults? = nil) -> some View {
        LazyHGrid(rows: Array(repeating: GridItem(), count: component.rows ?? 2)) {
            ForEach(component.components ?? [], id: \.id) { child in
                generateChildren(for: child)
            }
        }
    }
    
    @ViewBuilder
    private func generateToggle(from component: Component, with defaults: ComponentStyleDefaults? = nil) -> some View {
        Toggle(isOn: Binding(
            get: { viewModel.dynamicStates[component.stateKey ?? ""] == "true" },
            set: { viewModel.dynamicStates[component.stateKey ?? ""] = $0 ? "true" : "false" }
        )) {
            Text(component.content ?? "Toggle")
        }
    }
    
    @ViewBuilder
    private func generateSlider(from component: Component, with defaults: ComponentStyleDefaults? = nil) -> some View {
        let key = component.stateKey ?? ""
        let minValue = component.minValue ?? defaults?.minValue ?? 0
        let maxValue = component.maxValue ?? defaults?.maxValue ?? 100
        Slider(value: Binding(
            get: { Double(viewModel.dynamicStates[key] ?? "\(minValue)") ?? minValue },
            set: { viewModel.dynamicStates[key] = "\($0)" }
        ), in: minValue...maxValue)
    }
    
    @ViewBuilder
    private func generateStepper(from component: Component, with defaults: ComponentStyleDefaults? = nil) -> some View {
        let key = component.stateKey ?? ""
        let minValue = component.minValue ?? defaults?.minValue ?? 0
        let maxValue = component.maxValue ?? defaults?.maxValue ?? 100
        Stepper(value: Binding(
            get: { Double(viewModel.dynamicStates[key] ?? "\(minValue)") ?? minValue },
            set: { viewModel.dynamicStates[key] = "\($0)" }
        ), in: minValue...maxValue)
        {
            Text(component.content ?? "Stepper")
        }
    }
    
    @ViewBuilder
    private func generateImage(from component: Component, with defaults: ComponentStyleDefaults? = nil) -> some View {
        if let urlString = component.url, let url = URL(string: urlString) {
            AsyncImage(url: url) { image in image.resizable() } placeholder: { ProgressView() }
        }
    }
}

