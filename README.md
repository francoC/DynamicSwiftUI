# DynamicSwiftUI SDK

## Overview
Dynamic UI SDK is a Swift-based framework that allows developers to build flexible and dynamic user interfaces from JSON configurations. It supports various SwiftUI components, custom styling, network-based updates, and a plugin system for extensibility.

## Features
- **Dynamic UI Rendering**: Generate UI dynamically from JSON files.
- **Component Defaults & Styling Presets**: Apply global styles for consistency.
- **Network & Local JSON Support**: Fetch UI definitions from a remote server or local files.
- **State Binding & Dynamic Text Replacement**: Bind UI elements to dynamic data.
- **Plugin System**: Extend the SDK by registering custom components.
- **Cached Images & Placeholders**: Support for efficient image loading.

## Installation
To use Dynamic UI SDK in your Swift project:
1. Copy the SDK files into your project.
2. Ensure you have SwiftUI and Foundation frameworks imported.

## JSON Structure
A JSON file defines the screen layout and components:

```json
{
  "screenName": "Home",
  "layout": "VStack",
  "components": [
    {
      "type": "Text",
      "content": "Welcome to Dynamic UI SDK!",
      "fontSize": 24,
      "foregroundColor": "#333333"
    },
    {
      "type": "Button",
      "content": "Click Me",
      "backgroundColor": "#007AFF",
      "cornerRadius": 8
    }
  ]
}
```

## Supported Components
- **Text**: Displays text with optional styling.
- **Button**: Configurable button with actions.
- **Image (AsyncImage)**: Supports cached images and placeholders.
- **Divider**: Adds separators between views.
- **Toggle**: Switch control for boolean values.
- **List**: Displays scrollable content.
- **NavigationView**: Enables navigation support.
- **TabView**: Supports tabbed UI layouts.
- **ScrollView**: Enables vertical and horizontal scrolling.

## Using the SDK
### Loading a Screen
```swift
let viewModel = DynamicScreenViewModel()
viewModel.loadScreen(from: "homeScreen")
```

### Rendering a Screen
```swift
DynamicUIView(viewModel: viewModel, components: viewModel.screenData?.components ?? [])
```

### Dynamic Text Replacement
If a JSON string contains `{username}`, it will be replaced dynamically:
```swift
viewModel.dynamicStates["username"] = "John Doe"
```

## Plugin System
Extend the SDK with custom components:
```swift
struct CustomComponentPlugin: ComponentPlugin {
    var type: String { "CustomView" }
    
    func render(component: Component, viewModel: DynamicScreenViewModel) -> AnyView {
        AnyView(Text("Custom View Rendered"))
    }
}
```

Register the plugin:
```swift
viewModel.registerPlugin(CustomComponentPlugin())
```

## TL;DR
Dynamic UI SDK simplifies UI development by allowing flexible JSON-based rendering. It is extensible, supports network updates, and enables reusable UI configurations.
