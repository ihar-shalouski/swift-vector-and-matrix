//
//  BinaryFloatingPoint+ExternalExtensions.swift
//  SwiftVector
//
//  Created by Igor on 8/28/25.
//

import Foundation

extension BinaryFloatingPoint {
    @inlinable
    static func Sin(_ x: Self) -> Self {
        .init(Darwin.sin(Double(x)))
    }

    @inlinable
    static func Cos(_ x: Self) -> Self {
        .init(Darwin.cos(Double(x)))
    }

    @inlinable
    static func Atan2(_ y: Self, _ x: Self) -> Self {
        .init(Darwin.atan2(Double(y), Double(x)))
    }
}
