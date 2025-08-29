//
//  Matrix2.swift
//  SwiftVector
//
//  Created by Igor on 8/29/25.
//

import Foundation

public struct Matrix2<T> {
    public let rows: Int
    public let cols: Int
    public var elements: [T]

    public init(rows: Int, cols: Int, elements: [T]) {
        precondition(rows > 0 && cols > 0, "Size must be positive")
        precondition(elements.count == rows * cols, "Need rows*cols elements")
        self.rows = rows
        self.cols = cols
        self.elements = elements
    }

    public init(_ rowsArray: [[T]]) {
       precondition(!rowsArray.isEmpty, "Must provide at least one row")
       let rowCount = rowsArray.count
       let colCount = rowsArray[0].count
       precondition(colCount > 0, "Must provide at least one column")
       precondition(rowsArray.allSatisfy { $0.count == colCount },
                    "All rows must have the same number of columns")

       self.rows = rowCount
       self.cols = colCount
       self.elements = rowsArray.flatMap { $0 }
   }

    @inlinable
    public subscript(_ row: Int, _ col: Int) -> T {
        get {
            precondition((0..<rows).contains(row) && (0..<cols).contains(col),
                         "Index out of range")
            return elements[row * cols + col]
        }
        set {
            precondition((0..<rows).contains(row) && (0..<cols).contains(col),
                         "Index out of range")
            elements[row * cols + col] = newValue
        }
    }

    @inlinable
    public var isSquare: Bool { rows == cols }

    @inlinable
    public func row(_ i: Int) -> [T] {
        precondition((0..<rows).contains(i), "Row index out of range")
        let start = i * cols
        let end = start + cols
        return Array(elements[start..<end])
    }

    @inlinable
    public func col(_ j: Int) -> [T] {
        precondition((0..<cols).contains(j), "Column index out of range")
        var out: [T] = []
        out.reserveCapacity(rows)
        for i in 0..<rows {
            out.append(self[i, j])
        }
        return out
    }

    @inlinable
    public func submatrix(removingRow r: Int, col c: Int) -> Matrix2 {
        precondition((0..<rows).contains(r), "Row index out of range")
        precondition((0..<cols).contains(c), "Column index out of range")
        var out: [T] = []
        out.reserveCapacity((rows - 1) * (cols - 1))
        for i in 0..<rows where i != r {
            for j in 0..<cols where j != c {
                out.append(self[i, j])
            }
        }
        return Matrix2(rows: rows - 1, cols: cols - 1, elements: out)
    }

    @inlinable
    public func minor(ofRow i: Int, col j: Int) -> Matrix2 {
        precondition(isSquare && rows >= 2, "Minor defined for square matrices of size ≥ 2")
        return submatrix(removingRow: i, col: j)
    }
}


extension Matrix2: Codable where T: Codable {}
extension Matrix2: Hashable where T: Hashable {}
extension Matrix2: Sendable where T: Sendable {}
extension Matrix2: Equatable where T: Equatable {}

extension Matrix2 where T: Numeric {
    @inlinable
    public static func identity(_ size: Int) -> Matrix2 {
        Matrix2(identity: size)
    }

    @inlinable
    public var isZero: Bool {
        elements.allSatisfy { $0 == .zero }
    }

    public init(identity size: Int) {
        precondition(size > 0, "Size must be positive")
        self.rows = size
        self.cols = size
        self.elements = Array(repeating: .zero, count: size * size)
        for i in 0..<size {
            self[i, i] = 1
        }
    }

    @inlinable
    public static func + (lhs: Matrix2, rhs: Matrix2) -> Matrix2 {
        precondition(lhs.rows == rhs.rows && lhs.cols == rhs.cols,
                     "Matrix sizes must match for addition")
        let elements = zip(lhs.elements, rhs.elements).map { $0 + $1 }
        return Matrix2(rows: lhs.rows, cols: lhs.cols, elements: elements)
    }

    @inlinable
    public static func += (lhs: inout Matrix2, rhs: Matrix2) {
        precondition(lhs.rows == rhs.rows && lhs.cols == rhs.cols,
                     "Matrix sizes must match for addition")
        for i in lhs.elements.indices {
            lhs.elements[i] = lhs.elements[i] + rhs.elements[i]
        }
    }

    @inlinable
    public static func * (lhs: Matrix2, rhs: T) -> Matrix2 {
        Matrix2(rows: lhs.rows, cols: lhs.cols,
                elements: lhs.elements.map { $0 * rhs })
    }

    @inlinable
    public static func * (lhs: T, rhs: Matrix2) -> Matrix2 {
        rhs * lhs
    }

    @inlinable
    public static func *= (lhs: inout Matrix2, rhs: T) {
        for i in lhs.elements.indices {
            lhs.elements[i] = lhs.elements[i] * rhs
        }
    }

    @inlinable
    public static func * (lhs: Matrix2, rhs: Matrix2) -> Matrix2 {
        precondition(lhs.cols == rhs.rows, "Matrix multiplication requires lhs.cols == rhs.rows")
        var resultElements: [T] = Array(repeating: .zero, count: lhs.rows * rhs.cols)
        for i in 0..<lhs.rows {
            for j in 0..<rhs.cols {
                var sum: T = .zero
                for k in 0..<lhs.cols {
                    sum = sum + lhs[i, k] * rhs[k, j]
                }
                resultElements[i * rhs.cols + j] = sum
            }
        }
        return Matrix2(rows: lhs.rows, cols: rhs.cols, elements: resultElements)
    }

    @inlinable
    public static func - (lhs: Matrix2, rhs: Matrix2) -> Matrix2 {
        precondition(lhs.rows == rhs.rows && lhs.cols == rhs.cols,
                     "Matrix sizes must match for subtraction")
        let elems = zip(lhs.elements, rhs.elements).map { $0 - $1 }
        return Matrix2(rows: lhs.rows, cols: lhs.cols, elements: elems)
    }

    @inlinable
    public static func -= (lhs: inout Matrix2, rhs: Matrix2) {
        precondition(lhs.rows == rhs.rows && lhs.cols == rhs.cols,
                     "Matrix sizes must match for subtraction")
        for i in lhs.elements.indices {
            lhs.elements[i] = lhs.elements[i] - rhs.elements[i]
        }
    }

    @inlinable
    public static prefix func - (m: Matrix2) -> Matrix2 {
        Matrix2(rows: m.rows, cols: m.cols, elements: m.elements.map { $0 * -1 })
    }

    @inlinable
    public func transposed() -> Matrix2 {
        var out: [T] = []
        out.reserveCapacity(rows * cols)
        for j in 0..<cols {
            for i in 0..<rows {
                out.append(self[i, j])
            }
        }
        return Matrix2(rows: cols, cols: rows, elements: out)
    }

    @inlinable
    public mutating func transpose() {
        self = transposed()
    }

    @inlinable
    public var determinant: T {
        precondition(isSquare, "Determinant is defined only for square matrices")
        if rows == 1 {
            return elements[0]
        }
        if rows == 2 {
            let a = self[0, 0], b = self[0, 1]
            let c = self[1, 0], d = self[1, 1]
            return a * d - b * c
        }
        var det: T = .zero
        for j in 0..<cols {
            let a0j = self[0, j]
            guard a0j != .zero else { continue }
            let cofactorSign: T = (j % 2 == 0) ? 1 : -1
            let m = submatrix(removingRow: 0, col: j).determinant
            det = det + cofactorSign * a0j * m
        }
        return det
    }
}

extension Matrix2 where T: Numeric & Equatable {
    @inlinable
    public var isIdentity: Bool {
        guard isSquare else { return false }
        return self == .identity(cols)
    }
}

extension Matrix2 where T: BinaryFloatingPoint {
    @inlinable
    public static func / (lhs: Matrix2, rhs: T) -> Matrix2 {
        Matrix2(rows: lhs.rows, cols: lhs.cols,
                elements: lhs.elements.map { $0 / rhs })
    }

    @inlinable
    public static func /= (lhs: inout Matrix2, rhs: T) {
        for i in lhs.elements.indices {
            lhs.elements[i] = lhs.elements[i] / rhs
        }
    }
}
