//
//  FlowAlignment.swift
//  FlowLayout
//
//  Created by Nilkanth Desai.
//  Copyright © 2026 Nilkanth Desai. All rights reserved.
//

import CoreGraphics

/// Horizontal alignment distribution mode for flow layout rows.
public enum FlowHorizontalAlignment: Sendable, Equatable, Hashable {
    /// Left-aligned / leading edges packed tightly.
    case leading
    /// Centered elements on each line.
    case center
    /// Right-aligned / trailing edges packed tightly.
    case trailing
    /// Evenly spaced between margins across the full available line width.
    case justified
}

/// Vertical alignment within an individual row when elements have varying heights.
public enum FlowVerticalAlignment: Sendable, Equatable, Hashable {
    case top
    case center
    case bottom
}

/// Computed placement position for an individual item in a row.
public struct ItemPlacement: Sendable, Equatable {
    public let index: Int
    public let frame: CGRect

    public init(index: Int, frame: CGRect) {
        self.index = index
        self.frame = frame
    }
}

/// Representation of a single row of wrapped items in flow layout.
public struct FlowRow: Sendable, Equatable {
    public var items: [ItemPlacement]
    public var width: CGFloat
    public var height: CGFloat

    public init(items: [ItemPlacement] = [], width: CGFloat = 0, height: CGFloat = 0) {
        self.items = items
        self.width = width
        self.height = height
    }
}
