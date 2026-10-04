//
//  FlowCalculatorTests.swift
//  FlowLayoutTests
//
//  Created by Nilkanth Desai.
//  Copyright © 2026 Nilkanth Desai. All rights reserved.
//

import XCTest
@testable import FlowLayout

final class FlowCalculatorTests: XCTestCase {

    func testEmptyInputReturnsZeroSize() {
        let result = FlowCalculator.calculateLayout(sizes: [], containerWidth: 300)
        XCTAssertEqual(result.totalSize, .zero)
        XCTAssertTrue(result.frames.isEmpty)
        XCTAssertTrue(result.rows.isEmpty)
    }

    func testSingleLineWrapping() {
        let sizes = [
            CGSize(width: 50, height: 30),
            CGSize(width: 60, height: 30),
            CGSize(width: 70, height: 30)
        ]

        // Container is 300px wide, 50+8+60+8+70 = 196px fits easily
        let result = FlowCalculator.calculateLayout(
            sizes: sizes,
            containerWidth: 300,
            horizontalSpacing: 8,
            verticalSpacing: 10,
            alignment: .leading
        )

        XCTAssertEqual(result.rows.count, 1)
        XCTAssertEqual(result.frames.count, 3)
        XCTAssertEqual(result.frames[0].origin.x, 0)
        XCTAssertEqual(result.frames[1].origin.x, 58)
        XCTAssertEqual(result.frames[2].origin.x, 126)
        XCTAssertEqual(result.totalSize.height, 30)
    }

    func testMultipleLineWrapping() {
        let sizes = [
            CGSize(width: 60, height: 25),
            CGSize(width: 60, height: 25),
            CGSize(width: 60, height: 25)
        ]

        // Container is 100px wide -> each 60px item wraps to its own row
        let result = FlowCalculator.calculateLayout(
            sizes: sizes,
            containerWidth: 100,
            horizontalSpacing: 8,
            verticalSpacing: 10,
            alignment: .leading
        )

        XCTAssertEqual(result.rows.count, 3)
        XCTAssertEqual(result.frames[0].origin.y, 0)
        XCTAssertEqual(result.frames[1].origin.y, 35) // 25 + 10
        XCTAssertEqual(result.frames[2].origin.y, 70) // 25 + 10 + 25 + 10
        XCTAssertEqual(result.totalSize.height, 95)  // 70 + 25
    }

    func testCenterAlignment() {
        let sizes = [CGSize(width: 100, height: 30)]
        let result = FlowCalculator.calculateLayout(
            sizes: sizes,
            containerWidth: 300,
            alignment: .center
        )

        // (300 - 100) / 2 = 100
        XCTAssertEqual(result.frames[0].origin.x, 100)
    }

    func testTrailingAlignment() {
        let sizes = [CGSize(width: 100, height: 30)]
        let result = FlowCalculator.calculateLayout(
            sizes: sizes,
            containerWidth: 300,
            alignment: .trailing
        )

        // 300 - 100 = 200
        XCTAssertEqual(result.frames[0].origin.x, 200)
    }

    func testVerticalCenterAlignmentWithVariedHeights() {
        let sizes = [
            CGSize(width: 40, height: 20),
            CGSize(width: 40, height: 50)
        ]

        let result = FlowCalculator.calculateLayout(
            sizes: sizes,
            containerWidth: 200,
            verticalAlignment: .center
        )

        XCTAssertEqual(result.rows.count, 1)
        XCTAssertEqual(result.rows[0].height, 50)
        // Item 0 height 20 in row height 50 -> y offset = (50 - 20) / 2 = 15
        XCTAssertEqual(result.frames[0].origin.y, 15)
        // Item 1 height 50 in row height 50 -> y offset = 0
        XCTAssertEqual(result.frames[1].origin.y, 0)
    }
}
