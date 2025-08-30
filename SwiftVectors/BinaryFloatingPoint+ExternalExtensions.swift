//
//  BinaryFloatingPoint+ExternalExtensions.swift
//  SwiftVector
//
//  Created by Igor on 8/28/25.
//

import Foundation
#if os(Linux)
import Glibc
#else
import Darwin
#endif

extension BinaryFloatingPoint {
    @inlinable
    static func Sin(_ x: Self) -> Self {
        .init(sin(Double(x)))
    }

    @inlinable
    static func Cos(_ x: Self) -> Self {
        .init(cos(Double(x)))
    }

    @inlinable
    static func Atan2(_ y: Self, _ x: Self) -> Self {
        .init(atan2(Double(y), Double(x)))
    }
}
