//
//  DynamicView.swift
//  DynamicSwiftUI
//
//  Created by Franco Castellano on 13/02/25.
//

import SwiftUI

public struct DynamicUIView: View {
    @ObservedObject var viewModel: DynamicScreenViewModel
    
    public var body: some View {
        if let screenData = viewModel.screenData {
            VStack {
                ForEach(screenData.components, id: \.id) { component in
                    let stateValue = viewModel.dynamicStates[component.stateKey ?? ""] ?? ""
                    DynamicComponentView(component: component, viewModel: viewModel)
                        .applyAnimation(named: component.animation, value: stateValue)
                }
            }.navigationDestination(for: String.self) { destination in
                DynamicUIView(viewModel: viewModel)
            }
        } else {
            ProgressView("Loading...")
                .onAppear {
                    viewModel.loadScreen(from: "defaultScreen")
                }
        }
    }
}
