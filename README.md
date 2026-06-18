# GodTimer

A compact macOS timer app built with SwiftUI. Tracks time across three categories in a small, always-on-top floating window.

## Categories

| Code | Category   | Color  |
|------|------------|--------|
| G    | Meditation | Orange |
| O    | Office     | Blue   |
| D    | Idle       | Red    |

## Features

- Live timer with monospaced display
- Colored category badge (G / O / D)
- Tap the timer to open a dropdown with a bar chart breakdown
- Right-click context menu to switch categories
- Always-on-top, draggable window with minimal chrome (no title bar or window controls)

## Tech

- Swift / SwiftUI
- Custom window handling (`WindowAccessor`, `DraggableWindow`) for status-bar-level floating UI
- Reusable views: `PushCardView`, `DropDownList`, `TimeTracker`

## Requirements

- macOS
- Xcode
