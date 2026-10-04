//
//  FlowCalculator.swift
//  FlowLayout
//
//  Created by Nilkanth Desai.
//  Copyright © 2026 Nilkanth Desai. All rights reserved.
//

import CoreGraphics

/// Pure calculation engine for flow wrapping, line breaking, and alignment offsets.
public enum FlowCalculator {

    public struct LayoutResult: Sendable, Equatable {
        public let totalSize: CGSize
        public let frames: [CGRect]
        public let rows: [FlowRow]

        public init(totalSize: CGSize, frames: [CGRect], rows: [FlowRow]) {
            self.totalSize = totalSize
            self.frames = frames
            self.rows = rows
        }
    }

    /// Computes the complete flow layout frames given item sizes and constraints.
    public static func calculateLayout(
        sizes: [CGSize],
        containerWidth: CGFloat,
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8,
        alignment: FlowHorizontalAlignment = .leading,
        verticalAlignment: FlowVerticalAlignment = .center
    ) -> LayoutResult {
        guard !sizes.isEmpty, containerWidth > 0 else {
            return LayoutResult(totalSize: .zero, frames: [], rows: [])
        }

        var rows: [FlowRow] = []
        var currentRow = FlowRow()
        var currentLineWidth: CGFloat = 0

        // 1. Group into rows based on width constraint
        for (index, size) in sizes.enumerated() {
            let itemWidth = size.width
            let spacing = currentRow.items.isEmpty ? 0 : horizontalSpacing

            if !currentRow.items.isEmpty && (currentLineWidth + spacing + itemWidth) > containerWidth {
                // Wrap to next row
                rows.append(currentRow)
                currentRow = FlowRow()
                currentLineWidth = 0
            }

            let effectiveSpacing = currentRow.items.isEmpty ? 0 : horizontalSpacing
            let itemX = currentLineWidth + effectiveSpacing
            let placement = ItemPlacement(index: index, frame: CGRect(origin: CGPoint(x: itemX, y: 0), size: size))

            currentRow.items.append(placement)
            currentRow.height = max(currentRow.height, size.height)
            currentLineWidth += effectiveSpacing + itemWidth
            currentRow.width = currentLineWidth
        }

        if !currentRow.items.isEmpty {
            rows.append(currentRow)
        }

        // 2. Compute final frames applying horizontal & vertical alignments
        var finalFrames = [CGRect](repeating: .zero, count: sizes.count)
        var currentY: CGFloat = 0
        var maxRowWidth: CGFloat = 0

        for rowIndex in 0..<rows.count {
            let row = rows[rowIndex]
            let extraSpace = max(0, containerWidth - row.width)

            var xOffset: CGFloat = 0
            var extraSpacingPerItem: CGFloat = 0

            switch alignment {
            case .leading:
                xOffset = 0
            case .center:
                xOffset = extraSpace / 2.0
            case .trailing:
                xOffset = extraSpace
            case .justified:
                if row.items.count > 1 && rowIndex < rows.count - 1 {
                    extraSpacingPerItem = extraSpace / CGFloat(row.items.count - 1)
                }
            }

            for (itemIndexInRow, placement) in row.items.enumerated() {
                let size = placement.frame.size
                var itemX = placement.frame.origin.x + xOffset
                if extraSpacingPerItem > 0 {
                    itemX += CGFloat(itemIndexInRow) * extraSpacingPerItem
                }

                // Vertical alignment within row
                var itemY = currentY
                switch verticalAlignment {
                case .top:
                    itemY = currentY
                case .center:
                    itemY = currentY + (row.height - size.height) / 2.0
                case .bottom:
                    itemY = currentY + (row.height - size.height)
                }

                let finalFrame = CGRect(x: itemX, y: itemY, width: size.width, height: size.height)
                finalFrames[placement.index] = finalFrame
            }

            maxRowWidth = max(maxRowWidth, row.width)
            currentY += row.height + (rowIndex < rows.count - 1 ? verticalSpacing : 0)
        }

        let totalSize = CGSize(width: containerWidth, height: currentY)
        return LayoutResult(totalSize: totalSize, frames: finalFrames, rows: rows)
    }
}
