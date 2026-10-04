//
//  FlowLayout.swift
//  FlowLayout
//
//  Created by Nilkanth Desai.
//  Copyright © 2026 Nilkanth Desai. All rights reserved.
//

import SwiftUI

#if swift(>=5.7)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct FlowLayout: Layout {
    public var horizontalSpacing: CGFloat
    public var verticalSpacing: CGFloat
    public var alignment: FlowHorizontalAlignment
    public var verticalAlignment: FlowVerticalAlignment

    public init(
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8,
        alignment: FlowHorizontalAlignment = .leading,
        verticalAlignment: FlowVerticalAlignment = .center
    ) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.alignment = alignment
        self.verticalAlignment = verticalAlignment
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let result = FlowCalculator.calculateLayout(
            sizes: sizes,
            containerWidth: width,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            alignment: alignment,
            verticalAlignment: verticalAlignment
        )
        return result.totalSize
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let result = FlowCalculator.calculateLayout(
            sizes: sizes,
            containerWidth: bounds.width,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            alignment: alignment,
            verticalAlignment: verticalAlignment
        )

        for (index, frame) in result.frames.enumerated() {
            guard index < subviews.count else { break }
            let position = CGPoint(
                x: bounds.origin.x + frame.origin.x,
                y: bounds.origin.y + frame.origin.y
            )
            subviews[index].place(
                at: position,
                proposal: ProposedViewSize(frame.size)
            )
        }
    }
}
#endif

// MARK: - iOS 15 Fallback Container

/// Universal wrapping flow view supporting iOS 15+, macOS 12+, with data collection.
public struct FlowCollection<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let horizontalSpacing: CGFloat
    private let verticalSpacing: CGFloat
    private let alignment: FlowHorizontalAlignment
    private let content: (Data.Element) -> Content

    @State private var totalHeight: CGFloat = .zero

    public init(
        _ data: Data,
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8,
        alignment: FlowHorizontalAlignment = .leading,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var lastHeight = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(data) { item in
                content(item)
                    .padding(.horizontal, horizontalSpacing / 2)
                    .padding(.vertical, verticalSpacing / 2)
                    .alignmentGuide(.leading) { d in
                        if abs(width - d.width) > geometry.size.width {
                            width = 0
                            height -= lastHeight
                        }
                        let result = width
                        if item.id == data.last?.id {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        if item.id == data.last?.id {
                            height = 0
                        }
                        lastHeight = d.height
                        return result
                    }
            }
        }
        .background(
            GeometryReader { geo in
                Color.clear.preference(key: FlowHeightPreferenceKey.self, value: geo.size.height)
            }
        )
        .onPreferenceChange(FlowHeightPreferenceKey.self) { newHeight in
            totalHeight = newHeight
        }
    }
}

private struct FlowHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
