# SwiftUI FlowLayout

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2015+%20|%20macOS%2012+-blue.svg)](https://developer.apple.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![CI](https://github.com/nilkanthdesai76/swiftui-flow-layout/actions/workflows/ci.yml/badge.svg)](https://github.com/nilkanthdesai76/swiftui-flow-layout/actions/workflows/ci.yml)

A high-performance, modern multi-line wrapping layout container for SwiftUI and UIKit. Built with Apple's modern `Layout` protocol (iOS 16+ / macOS 13+) and backwards-compatible with iOS 15, offering customizable alignments (`leading`, `center`, `trailing`, `justified`), independent spacing, and dynamic chip/tag wrapping.

![SwiftUI FlowLayout Architecture](assets/flow_layout_diagram.svg)

---

## Features

- 🧩 **Native SwiftUI Layout Protocol** — Implemented using Apple's official `Layout` protocol (`sizeThatFits` and `placeSubviews`) with zero frame-calculation latency or UI lag.
- 📐 **Multiple Alignment Modalities** — Supports `.leading`, `.center`, `.trailing`, and `.justified` horizontal distributions.
- ↕️ **Smart Vertical Alignment** — Supports `.top`, `.center`, and `.bottom` baseline alignment when items in the same row have varying heights.
- 🏷️ **Dynamic Tag & Chip Wrapping** — Automatically wraps any SwiftUI views (tags, filter chips, pill buttons, badges) to the next line when exceeding container width.
- 📱 **Universal Backport (iOS 15 & macOS 12)** — Includes `FlowCollection` utilizing alignment guides and preference keys for older deployment targets.
- 🏛️ **UIKit UICollectionView Support** — Includes `UICollectionViewLeftAlignedLayout` for hybrid or legacy UIKit collection views.
- ⚡ **Zero External Dependencies** — Written purely with standard Swift and CoreGraphics APIs.

---

## Requirements

| Platform | Minimum Deployment Target |
| :--- | :--- |
| **iOS** | 15.0+ (iOS 16+ for native `Layout` protocol) |
| **macOS** | 12.0+ (macOS 13+ for native `Layout` protocol) |
| **Swift** | 5.9+ / Swift 6 Ready |

---

## Installation

Add **FlowLayout** to your Xcode project or `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/nilkanthdesai76/swiftui-flow-layout.git", from: "1.0.0")
]
```

---

## Quick Start

### 1. Modern SwiftUI (iOS 16+ / macOS 13+)

```swift
import SwiftUI
import FlowLayout

struct TagListView: View {
    let tags = ["Swift", "SwiftUI", "Combine", "Concurrency", "CoreData", "Metal", "Vision", "AppKit"]

    var body: some View {
        FlowLayout(horizontalSpacing: 8, verticalSpacing: 10, alignment: .leading) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.subheadline)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.blue.opacity(0.15)))
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
```

### 2. Centered Alignment

```swift
FlowLayout(horizontalSpacing: 12, verticalSpacing: 12, alignment: .center) {
    ForEach(filters, id: \.self) { filter in
        FilterPill(title: filter)
    }
}
```

### 3. Backwards-Compatible FlowCollection (iOS 15+)

```swift
struct Item: Identifiable {
    let id: String
    let title: String
}

FlowCollection(items, horizontalSpacing: 8, verticalSpacing: 8) { item in
    Text(item.title)
        .padding(8)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(6)
}
```

### 4. UIKit Collection View Integration

```swift
import UIKit
import FlowLayout

let layout = UICollectionViewLeftAlignedLayout()
layout.minimumInteritemSpacing = 8
layout.minimumLineSpacing = 8
layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
```

---

## Architecture

| Component | Responsibility |
| :--- | :--- |
| `FlowCalculator` | Pure mathematical algorithm calculating row bounds, line breaks, item offsets, and alignments without touching UI hierarchies. |
| `FlowLayout` | Modern SwiftUI `Layout` engine delegating proposal sizes and placing subviews using calculated frames. |
| `FlowCollection` | PreferenceKey-based wrapping container for iOS 15 and macOS 12 compatibility. |
| `UICollectionViewLeftAlignedLayout` | UIKit flow layout subclass calculating leading margins per row. |

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
