//
//  Vector2Tests.swift
//  SwiftVector
//
//  Created by Igor on 8/29/25.
//

#if canImport(CoreGraphics)
import CoreGraphics
#endif
#if canImport(simd)
import simd
#endif
import SwiftVectors
import Testing


@Suite("Vector2 tests")
struct Vector2Tests {

    @Test("init(x:y:)")
    func initAndSubscript() async throws {
        let v = Vector2(x: 17, y: 22)
        #expect(v[0] == 17)
        #expect(v[1] == 22)
    }

    @Test("subscript get")
    func subscriptGet() async throws {
        let v = Vector2(x: 1, y: 2)
        #expect(v[0] == 1)
        #expect(v[1] == 2)
    }

    @Test("subscript set")
    func subscriptSet() async throws {
        var v = Vector2(x: 5, y: 10)
        v[0] = 7
        v[1] = 9
        #expect(v.x == 7 && v.y == 9)
    }

    @Test("init(array:)")
    func initArray() async throws {
        let v = Vector2(array: [7, 9, 100])
        #expect(v.x == 7)
        #expect(v.y == 9)
    }

    @Test("ExpressibleByArrayLiteral")
    func arrayLiteral() async throws {
        let v: Vector2<Int> = [3, 4]
        #expect(v.x == 3 && v.y == 4)
    }

    @Test("CustomStringConvertible")
    func description() async throws {
        let v = Vector2(x: 5, y: -2)
        #expect(v.description == "Vector2(5, -2)")
    }

    @Test("swapped")
    func swapped() async throws {
        #expect(Vector2(x: 1, y: 2).swapped == Vector2(x: 2, y: 1))
    }

    @Test("swap()")
    func swapMutating() async throws {
        var v = Vector2(x: 1, y: 2)
        v.swap()
        #expect(v == Vector2(x: 2, y: 1))
    }

    @Test("withX")
    func withX() async throws {
        let v = Vector2(x: 1, y: 2)
        #expect(v.withX(10) == Vector2(x: 10, y: 2))
    }

    @Test("withY")
    func withY() async throws {
        let v = Vector2(x: 1, y: 2)
        #expect(v.withY(20) == Vector2(x: 1, y: 20))
    }

    @Test("unitX")
    func unitX() async throws {
        #expect(Vector2<Int>.unitX == Vector2(x: 1, y: 0))
    }

    @Test("unitY")
    func unitY() async throws {
        #expect(Vector2<Int>.unitY == Vector2(x: 0, y: 1))
    }

    @Test("zero")
    func zero() async throws {
        #expect(Vector2<Int>.zero == Vector2(x: 0, y: 0))
        #expect(Vector2<Double>.zero == Vector2(x: 0.0, y: 0.0))
    }

    @Test("length2 (Int)", arguments: [
        (Vector2(x: 0, y: 0), 0),
        (Vector2(x: 3, y: 4), 25),
        (Vector2(x: -5, y: 7), 74),
    ])
    func length2Int(v: Vector2<Int>, expected: Int) async throws {
        #expect(v.length2 == expected)
    }

    @Test("addition + (Int)", arguments: [
        (Vector2(x: 1, y: 2), Vector2(x: 3, y: 4), Vector2(x: 4, y: 6)),
        (Vector2(x: -1, y: 5), Vector2(x: 2, y: -3), Vector2(x: 1, y: 2)),
    ])
    func additionInt(a: Vector2<Int>, b: Vector2<Int>, sum: Vector2<Int>) async throws {
        #expect(a + b == sum)
    }

    @Test("subtraction - (Int)", arguments: [
        (Vector2(x: 1, y: 2), Vector2(x: 3, y: 4), Vector2(x: -2, y: -2)),
        (Vector2(x: -1, y: 5), Vector2(x: 2, y: -3), Vector2(x: -3, y: 8)),
    ])
    func subtractionInt(a: Vector2<Int>, b: Vector2<Int>, diff: Vector2<Int>) async throws {
        #expect(a - b == diff)
    }

    @Test("scalar multiply v*k (Int)", arguments: [
        (Vector2(x: 1, y: 2), 3, Vector2(x: 3, y: 6)),
        (Vector2(x: -2, y: 5), -2, Vector2(x: 4, y: -10)),
    ])
    func scalarMultiplyRightInt(v: Vector2<Int>, k: Int, expected: Vector2<Int>) async throws {
        #expect(v * k == expected)
    }

    @Test("scalar multiply k*v (Int)", arguments: [
        (2, Vector2(x: 3, y: 4), Vector2(x: 6, y: 8)),
        (-1, Vector2(x: -2, y: 5), Vector2(x: 2, y: -5)),
    ])
    func scalarMultiplyLeftInt(k: Int, v: Vector2<Int>, expected: Vector2<Int>) async throws {
        #expect(k * v == expected)
    }

    @Test("plus-assign += (Int)")
    func plusAssignInt() async throws {
        var v = Vector2(x: 1, y: 2)
        v += Vector2(x: 3, y: 4)
        #expect(v == Vector2(x: 4, y: 6))
    }

    @Test("minus-assign -= (Int)")
    func minusAssignInt() async throws {
        var v = Vector2(x: 4, y: 6)
        v -= Vector2(x: 1, y: 1)
        #expect(v == Vector2(x: 3, y: 5))
    }

    @Test("times-assign *= (Int)")
    func timesAssignInt() async throws {
        var v = Vector2(x: 3, y: 5)
        v *= 2
        #expect(v == Vector2(x: 6, y: 10))
    }

    // MARK: - BinaryFloatingPoint-specific (Double)

    @Test("length (Double)")
    func lengthDouble() async throws {
        #expect(approx(Vector2(x: 3.0, y: 4.0).length, 5.0))
    }

    @Test("normalized() (Double)")
    func normalizedDouble() async throws {
        let v = Vector2(x: 3.0, y: 4.0).normalized()
        #expect(approx(v, Vector2(x: 0.6, y: 0.8)))
    }

    @Test("normalize() (Double)")
    func normalizeMutatingDouble() async throws {
        let v = Vector2(x: 3.0, y: 4.0).normalized()
        var m = Vector2(x: 3.0, y: 4.0)
        m.normalize()
        #expect(approx(m, v))
    }

    @Test("prefix - (Double)")
    func prefixNegDouble() async throws {
        #expect(Vector2(x: 4.0, y: -6.0) == -Vector2(x: -4.0, y: 6.0))
    }

    @Test("/ operator (Double)")
    func divisionDouble() async throws {
        #expect(Vector2(x: 4.0, y: -6.0) / 2.0 == Vector2(x: 2.0, y: -3.0))
    }

    @Test("/= operator (Double)")
    func divisionAssignDouble() async throws {
        var v = Vector2(x: 4.0, y: -6.0)
        v /= 2.0
        #expect(v == Vector2(x: 2.0, y: -3.0))
    }

    @Test("dot (Double)", arguments: [
        (Vector2(x: 1.0, y: 2.0), Vector2(x: 3.0, y: 4.0), 11.0),
        (Vector2(x: 2.0, y: -1.0), Vector2(x: 4.0, y: 5.0), 3.0),
    ])
    func dotDouble(a: Vector2<Double>, b: Vector2<Double>, expected: Double) async throws {
        #expect(approx(a.dot(b), expected))
    }

    @Test("cross-like * (Double)", arguments: [
        (Vector2(x: 1.0, y: 2.0), Vector2(x: 3.0, y: 4.0), -2.0),
        (Vector2(x: 2.0, y: -1.0), Vector2(x: 4.0, y: 5.0), 14.0),
    ])
    func crossLikeDouble(a: Vector2<Double>, b: Vector2<Double>, expected: Double) async throws {
        #expect(approx(a * b, expected))
    }

    @Test("cross-like antisymmetry (Double)", arguments: [
        (Vector2(x: 1.0, y: 2.0), Vector2(x: 3.0, y: 4.0)),
        (Vector2(x: 2.0, y: -1.0), Vector2(x: 4.0, y: 5.0)),
    ])
    func crossAntisymmetry(a: Vector2<Double>, b: Vector2<Double>) async throws {
        #expect(approx(a * b, -(b * a)))
    }

    @Test("perp (Double)")
    func perpDouble() async throws {
        #expect(Vector2(x: 2.0, y: -3.0).perp == Vector2(x: 3.0, y: 2.0))
    }

    @Test("angle (Double)", arguments: [
        (Vector2(x: 1.0, y: 0.0), 0.0),
        (Vector2(x: 0.0, y: 1.0), .pi / 2),
        (Vector2(x: -1.0, y: 0.0), .pi),
        (Vector2(x: 0.0, y: -1.0), -.pi / 2),
    ])
    func angleDouble(v: Vector2<Double>, expected: Double) async throws {
        #expect(approx(v.angle, expected))
    }

    @Test("rotated(by:) (Double)", arguments: [
        (Vector2(x: 1.0, y: 0.0), 0.0, Vector2(x: 1.0, y: 0.0)),
        (Vector2(x: 1.0, y: 0.0), .pi / 2, Vector2(x: 0.0, y: 1.0)),
        (Vector2(x: 1.0, y: 0.0), .pi, Vector2(x: -1.0, y: 0.0)),
        (Vector2(x: 0.0, y: 1.0), -.pi / 2, Vector2(x: 1.0, y: 0.0)),
    ])
    func rotatedBy(v: Vector2<Double>, angle: Double, expected: Vector2<Double>) async throws {
        #expect(approx(v.rotated(by: angle), expected))
    }

    @Test("rotated(by:around:) (Double)")
    func rotatedAroundCenter() async throws {
        let p = Vector2(x: 2.0, y: 3.0)
        let c = Vector2(x: 1.0, y: 1.0)
        let r = p.rotated(by: .pi, around: c)
        #expect(approx(r, Vector2(x: 0.0, y: -1.0)))
    }

    @Test("rotate(by:around:) mutating (Double)")
    func rotateAroundCenterMutating() async throws {
        var p = Vector2(x: 2.0, y: 3.0)
        p.rotate(by: .pi, around: Vector2(x: 1.0, y: 1.0))
        #expect(approx(p, Vector2(x: 0.0, y: -1.0)))
    }

    @Test("rotate(by:) mutating (Double)", arguments: [
        (Vector2<Double>(x: 1.0, y: 0.0), 0.0, Vector2<Double>(x: 1.0, y: 0.0)),
        (Vector2<Double>(x: 1.0, y: 0.0), .pi / 2, Vector2<Double>(x: 0.0, y: 1.0)),
        (Vector2<Double>(x: 0.0, y: 1.0), -.pi / 2, Vector2<Double>(x: 1.0, y: 0.0)),
        (Vector2<Double>(x: 3.0, y: 4.0), .pi, Vector2<Double>(x: -3.0, y: -4.0)),
        (Vector2<Double>(x: -2.0, y: 5.0), .pi / 4, Vector2<Double>(x: (-2.0 - 5.0) / sqrt(2), y: ( -2.0 + 5.0) / sqrt(2))),
    ])
    func rotateMutating(vector: Vector2<Double>, angle: Double, expected: Vector2<Double>) async throws {
        var v = vector
        v.rotate(by: angle)
        #expect(approx(v, expected))
    }


    @Test("distance2(to:) (Double)")
    func distance2Double() async throws {
        #expect(approx(Vector2(x: 1.0, y: 2.0).distance2(to: Vector2(x: 4.0, y: 6.0)), 25.0))
    }

    @Test("distance(to:) (Double)")
    func distanceDouble() async throws {
        #expect(approx(Vector2(x: 1.0, y: 2.0).distance(to: Vector2(x: 4.0, y: 6.0)), 5.0))
    }

    @Test("scalarProjection(on:) (Double)")
    func scalarProjection() async throws {
        #expect(approx(Vector2(x: 3.0, y: 4.0).scalarProjection(on: Vector2(x: 1.0, y: 0.0)), 3.0))
    }

    @Test("project(on:) (Double)")
    func project() async throws {
        let a = Vector2(x: 3.0, y: 4.0)
        let on = Vector2(x: 0.0, y: 2.0)
        #expect(approx(a.project(on: on), Vector2(x: 0.0, y: 4.0)))
    }

    @Test("reject(from:) (Double)")
    func reject() async throws {
        let a = Vector2(x: 3.0, y: 4.0)
        let on = Vector2(x: 0.0, y: 2.0)
        #expect(approx(a.reject(from: on), Vector2(x: 3.0, y: 0.0)))
    }

    @Test("project(on:) zero vector → NaN (Double)")
    func projectOnZero() async throws {
        let p = Vector2<Double>(x: 3, y: 4).project(on: .zero)
        #expect(p.x.isNaN && p.y.isNaN)
    }

    @Test("lerp (Double)", arguments: [
        (Vector2(x: 0.0, y: 0.0), Vector2(x: 10.0, y: 20.0), 0.0, Vector2(x: 0.0, y: 0.0)),
        (Vector2(x: 0.0, y: 0.0), Vector2(x: 10.0, y: 20.0), 1.0, Vector2(x: 10.0, y: 20.0)),
        (Vector2(x: 0.0, y: 0.0), Vector2(x: 10.0, y: 20.0), 0.25, Vector2(x: 2.5, y: 5.0)),
    ])
    func lerp(a: Vector2<Double>, b: Vector2<Double>, t: Double, expected: Vector2<Double>) async throws {
        #expect(approx(a.lerp(to: b, t: t), expected))
    }

    #if canImport(CoreGraphics)

    @Test("init Vector2<CGFloat> from CGPoint")
    func cgInitFromCGPoint() async throws {
        let p = CGPoint(x: 3, y: -2)
        let v = Vector2<CGFloat>(p)
        #expect(v.x == p.x && v.y == p.y)
    }

    @Test("Vector2<CGFloat>.cgPoint")
    func cgPointProperty() async throws {
        let v = Vector2<CGFloat>(x: 3, y: -2)
        #expect(v.cgPoint == CGPoint(x: 3, y: -2))
    }

    @Test("init CGPoint from Vector2<CGFloat>")
    func cgInitFromVector() async throws {
        let v = Vector2<CGFloat>(x: -1, y: 5)
        #expect(CGPoint(v) == CGPoint(x: -1, y: 5))
    }

    @Test("CGPoint.vector2")
    func cgVector2Property() async throws {
        let p = CGPoint(x: 7, y: 8)
        #expect(p.vector2 == Vector2<CGFloat>(x: 7, y: 8))
    }
    #endif

    #if canImport(simd)

    @Test("init Vector2<Float> from SIMD2<Float>")
    func simdInitFloat() async throws {
        let v = Vector2<Float>(SIMD2<Float>(1, 2))
        #expect(v == Vector2<Float>(x: 1, y: 2))
    }

    @Test("Vector2<Float>.simd")
    func simdPropFloat() async throws {
        let v = Vector2<Float>(x: -3, y: 4)
        #expect(v.simd == SIMD2<Float>(-3, 4))
    }

    @Test("init Vector2<Double> from SIMD2<Double>")
    func simdInitDouble() async throws {
        let v = Vector2<Double>(SIMD2<Double>(-3, 4))
        #expect(v == Vector2<Double>(x: -3, y: 4))
    }

    @Test("Vector2<Double>.simd")
    func simdPropDouble() async throws {
        let v = Vector2<Double>(x: 1, y: 2)
        #expect(v.simd == SIMD2<Double>(1, 2))
    }
    #endif
}
