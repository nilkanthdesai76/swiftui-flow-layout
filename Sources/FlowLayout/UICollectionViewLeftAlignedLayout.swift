//
//  UICollectionViewLeftAlignedLayout.swift
//  FlowLayout
//
//  Created by Nilkanth Desai.
//  Copyright © 2026 Nilkanth Desai. All rights reserved.
//

#if canImport(UIKit)
import UIKit

/// A `UICollectionViewFlowLayout` subclass that aligns items in each row tightly to the leading edge.
open class UICollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var copiedAttributes: [UICollectionViewLayoutAttributes] = []
        for attribute in attributes {
            guard let copy = attribute.copy() as? UICollectionViewLayoutAttributes else { continue }
            copiedAttributes.append(copy)
        }

        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0

        for layoutAttribute in copiedAttributes {
            guard layoutAttribute.representedElementCategory == .cell else { continue }

            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        return copiedAttributes
    }
}
#endif
