//
//  BinaryFloatingPointExtensionsTests.swift
//  SwiftVector
//
//  Created by Igor on 8/29/25.
//

import Foundation
@testable import SwiftVectors
import Testing

@Suite("BinaryFloatingPoint extensions tests")
struct BinaryFloatingPointExtensionsTests {

    @Test("Double.Sin")
    func doubleSin() async throws {
        let s2 = sqrt(2.0) / 2.0
        #expect(approx(Double.Sin(0.0), 0.0))
        #expect(approx(Double.Sin(.pi / 6), 0.5))
        #expect(approx(Double.Sin(.pi / 4), s2))
        #expect(approx(Double.Sin(.pi / 2), 1.0))
        #expect(approx(Double.Sin(.pi), 0.0))
        #expect(approx(Double.Sin(-.pi / 2), -1.0))
    }

    @Test("Double.Cos")
    func doubleCos() async throws {
        let s2 = sqrt(2.0) / 2.0
        let s3 = sqrt(3.0) / 2.0
        #expect(approx(Double.Cos(0.0), 1.0))
        #expect(approx(Double.Cos(.pi / 6), s3))
        #expect(approx(Double.Cos(.pi / 4), s2))
        #expect(approx(Double.Cos(.pi / 2), 0.0))
        #expect(approx(Double.Cos(.pi), -1.0))
        #expect(approx(Double.Cos(-.pi / 2), 0.0))
    }

    @Test("Double.Atan2")
    func doubleAtan2() async throws {
        #expect(approx(Double.Atan2(0.0, 1.0), 0.0))
        #expect(approx(Double.Atan2(1.0, 0.0), .pi / 2))
        #expect(approx(Double.Atan2(1.0, 1.0), .pi / 4))
        #expect(approx(Double.Atan2(1.0, -1.0), 3 * .pi / 4))
        #expect(approx(Double.Atan2(-1.0, -1.0), -3 * .pi / 4))
        #expect(approx(Double.Atan2(-1.0, 1.0), -.pi / 4))
    }

    // ========= Float =========

    @Test("Float.Sin")
    func floatSin() async throws {
        let s2: Float = sqrt(2.0) / 2.0
        #expect(approxf(Float.Sin(0.0), 0.0))
        #expect(approxf(Float.Sin(.pi / 6), 0.5))
        #expect(approxf(Float.Sin(.pi / 4), s2))
        #expect(approxf(Float.Sin(.pi / 2), 1.0))
        #expect(approxf(Float.Sin(.pi), 0.0))
        #expect(approxf(Float.Sin(-.pi / 2), -1.0))
    }

    @Test("Float.Cos")
    func floatCos() async throws {
        let s2: Float = sqrt(2.0) / 2.0
        let s3: Float = sqrt(3.0) / 2.0
        #expect(approxf(Float.Cos(0.0), 1.0))
        #expect(approxf(Float.Cos(.pi / 6), s3))
        #expect(approxf(Float.Cos(.pi / 4), s2))
        #expect(approxf(Float.Cos(.pi / 2), 0.0))
        #expect(approxf(Float.Cos(.pi), -1.0))
        #expect(approxf(Float.Cos(-.pi / 2), 0.0))
    }

    @Test("Float.Atan2")
    func floatAtan2() async throws {
        #expect(approxf(Float.Atan2(0.0, 1.0), 0.0))
        #expect(approxf(Float.Atan2(1.0, 0.0), .pi / 2))
        #expect(approxf(Float.Atan2(1.0, 1.0), .pi / 4))
        #expect(approxf(Float.Atan2(1.0, -1.0), 3 * .pi / 4))
        #expect(approxf(Float.Atan2(-1.0, -1.0), -3 * .pi / 4))
        #expect(approxf(Float.Atan2(-1.0, 1.0), -.pi / 4))
    }
}
