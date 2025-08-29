//
//  Vector2.swift
//  SwiftVector
//
//  Created by Igor on 8/28/25.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif
#if canImport(simd)
import simd
#endif

public struct Vector2<T> {
    public var x: T
    public var y: T

    public init(x: T, y: T) {
        self.x = x
        self.y = y
    }
    
    public init(array: [T]) {
        precondition(array.count >= 2, "Need at least 2 elements")
        x = array[0]
        y = array[1]
    }

    @inlinable
    public subscript(i: Int) -> T {
        get {
            precondition(i == 0 || i == 1, "Index out of range")
            return i == 0 ? x : y
        }
        set {
            precondition(i == 0 || i == 1, "Index out of range")
            if i == 0 {
                x = newValue
            } else {
                y = newValue
            }
        }
    }

    @inlinable
    public var swapped: Vector2 {
        Vector2(x: y, y: x)
    }

    @inlinable
    public mutating func swap() {
        self = Vector2(x: y, y: x)
    }

    @inlinable
    public func withX(_ newX: T) -> Vector2 {
        Vector2(x: newX, y: y)
    }

    @inlinable
    public func withY(_ newY: T) -> Vector2 {
        Vector2(x: x, y: newY)
    }
}

extension Vector2: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = T
    public init(arrayLiteral elements: T...) {
        precondition(elements.count == 2, "Use exactly 2 elements")
        self.init(x: elements[0], y: elements[1])
    }
}

extension Vector2: CustomStringConvertible {
    public var description: String { "Vector2(\(x), \(y))" }
}

extension Vector2: Codable where T: Codable {}
extension Vector2: Hashable where T: Hashable {}
extension Vector2: Sendable where T: Sendable {}
extension Vector2: Equatable where T: Equatable {}

extension Vector2 where T: ExpressibleByIntegerLiteral {
    public static var unitX: Vector2 {
        Vector2(x: 1, y: 0)
    }

    public static var unitY: Vector2 {
        Vector2(x: 0, y: 1)
    }
}

extension Vector2 where T: Numeric {
    @inlinable
    public static var zero: Vector2 { .init(x: .zero, y: .zero) }

    @inlinable
    public var length2: T {
        x * x + y * y
    }

    @inlinable
    public static func + (lhs: Vector2, rhs: Vector2) -> Vector2 {
        Vector2<T>(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    @inlinable
    public static func - (lhs: Vector2, rhs: Vector2) -> Vector2 {
        Vector2<T>(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    @inlinable
    public static func * (lhs: Vector2, rhs: T) -> Vector2 {
        Vector2<T>(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    @inlinable
    public static func * (lhs: Vector2, rhs: Vector2) -> T {
        lhs.x * rhs.y - lhs.y * rhs.x
    }

    @inlinable
    public func dot(_ other: Vector2) -> T {
        x * other.x + y * other.y
    }

    @inlinable
    public static func * (lhs: T, rhs: Vector2) -> Vector2 {
        rhs * lhs
    }

    @inlinable
    public static func += (lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs + rhs
    }

    @inlinable
    public static func -= (lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs - rhs
    }

    @inlinable
    public static func *= (lhs: inout Vector2, rhs: T) {
        lhs = lhs * rhs
    }
}

extension Vector2 where T: BinaryFloatingPoint {
    @inlinable
    public var length: T {
        length2.squareRoot()
    }

    @inlinable
    public func normalized() -> Vector2 {
        let l = length
        return Vector2(x: x / l, y: y / l)
    }

    @inlinable
    public mutating func normalize() {
        self = normalized()
    }

    @inlinable
    public static prefix func - (lhs: Vector2) -> Vector2 {
        Vector2(x: -lhs.x, y: -lhs.y)
    }

    @inlinable
    public static func / (lhs: Vector2, rhs: T) -> Vector2 {
        Vector2(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    @inlinable
    public static func /= (lhs: inout Vector2, rhs: T) {
        lhs = lhs / rhs
    }


    @inlinable
    public func rotated(by angle: T) -> Vector2 {
        let c = T.Cos(angle), s = T.Sin(angle)
        return Vector2(x: x * c - y * s, y: x * s + y * c)
    }

    @inlinable
    public mutating func rotate(by angle: T) {
        self = rotated(by: angle)
    }

    @inlinable
    public func rotated(by angle: T, around center: Vector2) -> Vector2 {
        let translated = self - center
        let rotated = translated.rotated(by: angle)
        return rotated + center
    }

    @inlinable
    public mutating func rotate(by angle: T, around center: Vector2) {
        self = rotated(by: angle, around: center)
    }

    @inlinable
    public var perp: Vector2 {
        Vector2(x: -y, y: x)
    }

    @inlinable
    public var angle: T {
        T.Atan2(y, x)
    }

    @inlinable
    public func distance(to other: Vector2) -> T {
        (self - other).length
    }

    @inlinable
    public func distance2(to other: Vector2) -> T {
        (self - other).length2
    }

    @inlinable
    public func scalarProjection(on other: Vector2) -> T {
        dot(other) / other.length
    }

    @inlinable
    public func project(on other: Vector2) -> Vector2 {
        let denom = other.length2
        let k = denom == 0 ? T.nan : dot(other) / denom
        return other * k
    }

    @inlinable
    public func reject(from other: Vector2) -> Vector2 {
        self - project(on: other)
    }

    @inlinable
    public func lerp(to b: Vector2, t: T) -> Vector2 {
        self + (b - self) * t
    }
}

#if canImport(CoreGraphics)

extension Vector2 where T == CGFloat {
    public init(_ p: CGPoint) {
        self.init(x: p.x, y: p.y)
    }

    @inlinable
    public var cgPoint: CGPoint {
        CGPoint(x: x, y: y)
    }
}

extension CGPoint {
    public init(_ p: Vector2<CGFloat>) {
        self.init(x: p.x, y: p.y)
    }

    @inlinable
    public var vector2: Vector2<CGFloat> {
        Vector2(self)
    }
}

#endif

#if canImport(simd)

extension Vector2 where T == Float {
    public init(_ v: SIMD2<Float>) {
        self.init(x: v.x, y: v.y)
    }

    @inlinable
    public var simd: SIMD2<Float> {
        SIMD2<Float>(x, y)
    }
}

extension Vector2 where T == Double {
    public init(_ v: SIMD2<Double>) {
        self.init(x: v.x, y: v.y)
    }

    @inlinable
    public var simd: SIMD2<Double> {
        SIMD2<Double>(x, y)
    }
}

#endif
