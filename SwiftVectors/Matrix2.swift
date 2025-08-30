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

    @inlinable
    public var shape: Vector2<Int> {
        Vector2(x: rows, y: cols)
    }
}

extension Matrix2: CustomStringConvertible where T: CustomStringConvertible {

    public var description: String {
        return (0..<rows).map {
            let prefix = rows == 1 ? "[" : ($0 == 0 ? "┏" : ($0 == rows - 1 ? "┗" : "┃"))
            let suffix = rows == 1 ? "[" : ($0 == 0 ? "┓" : ($0 == rows - 1 ? "┛" : "┃"))
            return"\(prefix) \(row($0).map(\.description).joined(separator: " ")) \(suffix)"
        }.joined(separator: "\n")
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
        let m = lhs.rows, n = lhs.cols, p = rhs.cols
        var c = Array(repeating: T.zero, count: m * p)
        for i in 0..<m {
            let aRow = i * n
            let cRow = i * p
            for k in 0..<n {
                let aik = lhs.elements[aRow + k]
                if aik == .zero { continue }
                let bRow = k * p
                for j in 0..<p {
                    c[cRow + j] += aik * rhs.elements[bRow + j]
                }
            }
        }
        return Matrix2(rows: m, cols: p, elements: c)
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

extension Matrix2 where T: Numeric {
    public func multiplying(vector x: [T]) -> [T] {
        return (self * Matrix2(rows: x.count, cols: 1, elements: x)).elements
    }
}

extension Matrix2 where T: BinaryFloatingPoint {
    public func isAround(_ other: Matrix2<T>, rtol: T = 1e-5, atol: T = 1e-5) -> Bool {
        precondition(cols == other.cols)
        precondition(rows == other.rows)
        for (a, b) in zip(elements, other.elements) {
            guard a != b else { continue }
            guard !a.isNaN, !b.isNaN else {
                return false
            }

            let diff = (a - b).magnitude
            let limit = max(atol, rtol * max(a.magnitude, b.magnitude))
            if diff > limit {
                return false
            }
        }
        return true
    }

    public func solveUsingGaussianElimination(_ B: Matrix2<T>) -> Matrix2<T>? {
        precondition(isSquare, "Square matrix required")
        precondition(B.rows == rows, "B.rows must equal rows")

        var A = self
        var R = B
        let n = rows
        let p = B.cols
        for k in 0..<n {
            var pivotRow = k
            var maxVal = Swift.abs(A[k, k])
            if k + 1 < n {
                for i in (k + 1)..<n {
                    let v = Swift.abs(A[i, k])
                    if v > maxVal { maxVal = v; pivotRow = i }
                }
            }
            if maxVal == .zero { return nil }
            if pivotRow != k {
                for j in k..<n {
                    let t = A[k, j]; A[k, j] = A[pivotRow, j]; A[pivotRow, j] = t
                }
                for c in 0..<p {
                    let t = R[k, c]; R[k, c] = R[pivotRow, c]; R[pivotRow, c] = t
                }
            }
            let akk = A[k, k]
            for i in (k + 1)..<n {
                let m = A[i, k] / akk
                if m != .zero {
                    A[i, k] = .zero
                    for j in (k + 1)..<n { A[i, j] -= m * A[k, j] }
                    for c in 0..<p { R[i, c] -= m * R[k, c] }
                }
            }
        }
        var X = Matrix2<T>(rows: n, cols: p, elements: Array(repeating: .zero, count: n * p))
        for i in stride(from: n - 1, through: 0, by: -1) {
            let aii = A[i, i]
            if aii == .zero { return nil } // на всякий случай
            for c in 0..<p {
                var s = R[i, c]
                if i + 1 < n {
                    for j in (i + 1)..<n { s -= A[i, j] * X[j, c] }
                }
                X[i, c] = s / aii
            }
        }
        return X
    }

    public func luDecomposition(partialPivoting: Bool = true)
    -> (permutation: [Int], L: Matrix2, U: Matrix2)? {
        precondition(isSquare, "Square matrix required")
        let n = rows
        var U = self
        var L = Matrix2(rows: n, cols: n, elements: Array(repeating: .zero, count: n*n))
        var P = Array(0..<n)

        for k in 0..<n {
            var pivot = k
            if partialPivoting {
                var maxVal = Swift.abs(U[k,k])
                for i in (k+1)..<n {
                    let v = Swift.abs(U[i,k])
                    if v > maxVal { maxVal = v; pivot = i }
                }
                if maxVal == .zero { return nil }
            } else {
                if U[k,k] == .zero { return nil }
            }

            if pivot != k {
                for j in 0..<n { let t = U[k,j]; U[k,j] = U[pivot,j]; U[pivot,j] = t }
                if k > 0 {
                    for j in 0..<k { let t = L[k,j]; L[k,j] = L[pivot,j]; L[pivot,j] = t }
                }
                let t = P[k]; P[k] = P[pivot]; P[pivot] = t
            }
            L[k,k] = 1
            if k+1 < n {
                for i in (k+1)..<n {
                    let f = U[i,k] / U[k,k]
                    L[i,k] = f
                    U[i,k] = .zero
                    for j in (k+1)..<n { U[i,j] -= f * U[k,j] }
                }
            }
        }
        return (P, L, U)
    }

    public func solveUsingLu(_ b: [T]) -> [T]? {
        precondition(b.count == rows, "b.count must equal rows")
        guard let (P,L,U) = luDecomposition() else { return nil }
        let n = rows
        var bp = Array(repeating: T.zero, count: n)
        for i in 0..<n { bp[i] = b[P[i]] }
        var y = Array(repeating: T.zero, count: n)
        for i in 0..<n {
            var s = bp[i]
            for j in 0..<i { s -= L[i,j] * y[j] }
            y[i] = s / L[i,i]
        }
        var x = Array(repeating: T.zero, count: n)
        for i in stride(from: n-1, through: 0, by: -1) {
            var s = y[i]
            for j in i+1..<n { s -= U[i,j] * x[j] }
            x[i] = s / U[i,i]
        }
        return x
    }

    @inlinable
    public func solveUsingLu(_ B: Matrix2<T>) -> Matrix2<T>? {
        precondition(B.rows == rows, "b.rows must equal rows")
        guard let result = solveUsingLu(B.elements) else { return nil }
        return Matrix2(rows: rows, cols: 1, elements: result)
    }

    public func symmetricEigenDecomposition(maxSweeps: Int = 50, tol: T = .zero) -> (values: [T], vectors: Matrix2)? {
        precondition(isSquare, "Square matrix required")
        let n = rows
        var A = self
        for i in 0..<n { for j in 0..<n { precondition(Swift.abs(A[i,j] - A[j,i]) <= tol, "Matrix must be symmetric") } }
        var V = Matrix2<T>.identity(n)
        if n == 1 { return ([A[0,0]], Matrix2.identity(1)) }
        for _ in 0..<maxSweeps {
            var p = 0, q = 1
            var maxVal = Swift.abs(A[p,q])
            if n > 2 {
                for i in 0..<n {
                    for j in i+1..<n {
                        let v = Swift.abs(A[i,j])
                        if v > maxVal { maxVal = v; p = i; q = j }
                    }
                }
            }
            if maxVal <= tol { break }
            let app = A[p,p], aqq = A[q,q], apq = A[p,q]
            let tau = (aqq - app) / (2.0 * apq)
            let t: T = tau >= 0.0 ? 1.0 / (tau + (1.0 + tau*tau).squareRoot())
                                 : -1.0 / (-tau + (1.0 + tau*tau).squareRoot())
            let c = 1.0 / ( (1.0 + t * t).squareRoot() )
            let s = t * c
            for k in 0..<n where k != p && k != q {
                let aip = A[k,p], aiq = A[k,q]
                A[k,p] = aip * c - aiq * s
                A[p,k] = A[k,p]
                A[k,q] = aiq * c + aip * s
                A[q,k] = A[k,q]
            }
            let aqqss = aqq * s * s
            let appss = app * s * s
            let appNew = app * c * c - 2.0 * apq * c * s + aqqss
            let aqqNew = aqq * c * c + 2.0 * apq * c * s + appss
            A[p,p] = appNew
            A[q,q] = aqqNew
            A[p,q] = .zero
            A[q,p] = .zero
            for k in 0..<n {
                let vkp = V[k,p], vkq = V[k,q]
                V[k,p] = vkp * c - vkq * s
                V[k,q] = vkq * c + vkp * s
            }
        }
        var values = [T](repeating: .zero, count: n)
        for i in 0..<n { values[i] = A[i,i] }
        return (values, V)
    }

    public func pseudoinverse(tol: T? = nil, maxSweeps: Int = 50) -> Matrix2 {
        let At = self.transposed()
        let AtA = At * self
        guard var (evals, V) = AtA.symmetricEigenDecomposition(maxSweeps: maxSweeps) else {
            return Matrix2(rows: cols, cols: rows, elements: Array(repeating: .zero, count: cols*rows))
        }
        let n = evals.count
        var idx = Array(0..<n)
        idx.sort { evals[$0] > evals[$1] }
        evals = idx.map { evals[$0] }
        var Vsorted = Matrix2(rows: n, cols: n, elements: Array(repeating: .zero, count: n*n))
        for j in 0..<n { for i in 0..<n { Vsorted[i,j] = V[i, idx[j]] } }
        V = Vsorted
        let sigma = evals.map { max($0, .zero).squareRoot() }
        let sigmaMax = sigma.max() ?? .zero
        let defaultTol = T(1e-12) * T(Swift.max(rows, cols)) * (sigmaMax == .zero ? 1 : sigmaMax)
        let thr = tol ?? defaultTol
        var U = Matrix2(rows: rows, cols: n, elements: Array(repeating: .zero, count: rows*n))
        for j in 0..<n {
            let s = sigma[j]
            if s > thr {
                var vj = [T](repeating: .zero, count: n)
                for i in 0..<n { vj[i] = V[i,j] }
                let Av = self.multiplying(vector: vj)
                for i in 0..<rows { U[i,j] = Av[i] / s }
            }
        }
        var VSigmaPlus = V
        for j in 0..<n {
            let s = sigma[j]
            let f: T = s > thr ? 1 / s : .zero
            for i in 0..<n { VSigmaPlus[i,j] *= f }
        }
        let Ut = U.transposed()
        return VSigmaPlus * Ut
    }

    public func eigenDecomposition2x2() -> (values: (T, T), vectors: Matrix2)? {
        precondition(rows == 2 && cols == 2, "2×2 matrix required")
        let a = self[0,0], b = self[0,1], c = self[1,0], d = self[1,1]
        let tr = a + d
        let det = a*d - b*c
        let disc = tr*tr - 4*det
        if disc < .zero { return nil }
        let s = disc.squareRoot()
        let l1 = (tr + s) / 2
        let l2 = (tr - s) / 2
        func eigenvector(_ λ: T) -> (T,T) {
            let m00 = a - λ, m01 = b, m10 = c, m11 = d - λ
            let s0 = Swift.abs(m00) + Swift.abs(m01)
            let s1 = Swift.abs(m10) + Swift.abs(m11)
            var x: T, y: T
            if s0 >= s1 {
                x = -m01; y = m00
            } else {
                x = -m11; y = m10
            }
            let n = (x*x + y*y).squareRoot()
            if n != .zero { x /= n; y /= n }
            return (x, y)
        }
        var (x1,y1) = eigenvector(l1)
        var (x2,y2) = eigenvector(l2)
        let n1 = (x1*x1 + y1*y1).squareRoot()
        let n2 = (x2*x2 + y2*y2).squareRoot()
        if n1 != .zero { x1 /= n1; y1 /= n1 }
        if n2 != .zero { x2 /= n2; y2 /= n2 }
        let V = Matrix2([[x1, x2],[y1, y2]])
        return ((l1, l2), V)
    }

    
}
