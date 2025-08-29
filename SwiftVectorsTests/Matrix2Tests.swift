//
//  Matrix2Tests.swift
//  SwiftVector
//
//  Created by Igor on 8/29/25.
//

import SwiftVectors
import Testing

@Suite("Matrix2 tests")
struct MAtrix2Tests {
    @Test("isSquare", arguments: [
        (Matrix2<Int>([[1]]), true),
        (Matrix2<Int>([[1, 2], [3, 4]]), true),
        (Matrix2<Int>([[1, 2, 3], [4, 5, 6]]), false),
        (Matrix2<Int>([[1], [2], [3]]), false),
    ])
    func isSquare(matrix: Matrix2<Int>, expected: Bool) async throws {
        #expect(matrix.isSquare == expected)
    }

    @Test("row()", arguments: [
        (Matrix2<Int>([[1, 2, 3], [4, 5, 6]]), 0, [1, 2, 3]),
        (Matrix2<Int>([[1, 2, 3], [4, 5, 6]]), 1, [4, 5, 6]),
    ])
    func rows(matrix: Matrix2<Int>, i: Int, expected: [Int]) async throws {
        #expect(matrix.row(i) == expected)
    }

    @Test("col()", arguments: [
        (Matrix2<Int>([[1, 2, 3], [4, 5, 6]]), 0, [1, 4]),
        (Matrix2<Int>([[1, 2, 3], [4, 5, 6]]), 2, [3, 6]),
    ])
    func cols(matrix: Matrix2<Int>, j: Int, expected: [Int]) async throws {
        #expect(matrix.col(j) == expected)
    }

    @Test("submatrix(removingRow:col:)", arguments: [
        (Matrix2<Int>([
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
        ]), 1, 1, Matrix2<Int>([
            [1, 3],
            [7, 9],
        ])),
        (Matrix2<Int>([
            [3, 1, 7],
            [5, 4, 1],
            [1, 2, 9],
        ]), 0, 2, Matrix2<Int>([
            [5, 4],
            [1, 2],
        ])),
    ])
    func submatrix(matrix: Matrix2<Int>, r: Int, c: Int, expected: Matrix2<Int>) async throws {
        #expect(matrix.submatrix(removingRow: r, col: c) == expected)
    }

    @Test("minor(ofRow:col:) on square 4x4")
    func minor() async throws {
        let m = Matrix2<Int>([
            [4, 0, 1, 2],
            [3, 1, -1, 3],
            [2, 0, 3, 1],
            [2, -2, 3, 1],
        ])
        let mn = m.minor(ofRow: 2, col: 1)
        #expect(mn == Matrix2<Int>([
            [4, 1, 2],
            [3, -1, 3],
            [2, 3, 1],
        ]))
    }

    @Test("identity()", arguments: [
        (1, Matrix2<Int>([[1]])),
        (2, Matrix2<Int>([[1, 0], [0, 1]])),
        (4, Matrix2<Int>([[1, 0, 0, 0], [0, 1, 0, 0], [0, 0,1, 0], [0, 0, 0, 1]])),
    ])
    func identity(size: Int, expected: Matrix2<Int>) async throws {
        let matrix = Matrix2<Int>.identity(size)
        let matrix2 = Matrix2<Int>(identity: size)
        #expect(matrix == matrix2)
        #expect(matrix == expected)
    }

    @Test("isZero", arguments: [
        (Matrix2<Int>([[0]]), true),
        (Matrix2<Int>([[1]]), false),
        (Matrix2<Int>([[0, 0], [0, 0]]), true),
        (Matrix2<Int>([[0, 1], [0, 0]]), false),
    ])
    func isZero(matrix: Matrix2<Int>, expected: Bool) async throws {
        #expect(matrix.isZero == expected)
    }

    @Test("isIdentity", arguments: [
        (Matrix2<Int>([[1]]), true),
        (Matrix2<Int>([[1, 0], [0, 1]]), true),
        (Matrix2<Int>([[1, 0, 0, 0], [0, 1, 0, 0], [0, 0,1, 0], [0, 0, 0, 1]]), true),
        (Matrix2<Int>([[0, 1, 0, 0], [0, 1, 0, 0], [0, 0,1, 0], [0, 0, 0, 1]]), false),
        (Matrix2<Int>([[1, 0]]), false),
        (Matrix2<Int>([[1, 0, 0], [0, 1, 0]]), false),
    ])
    func isIdentity(matrix: Matrix2<Int>, expected: Bool) async throws {
        #expect(matrix.isIdentity == expected)
    }

    @Test("determinant", arguments: [
        (Matrix2<Int>([
            [7],
        ]), 7),

        (Matrix2<Int>([
            [4, -5, 7],
            [1, -4, 9],
            [-4, 0, 5],
        ]), 13),

        (Matrix2<Int>([
            [1, 2, 3],
            [4, 8, 9],
            [2, 4, 5],
        ]), 0),

        (Matrix2<Int>([
            [1, 2, 3],
            [4, 1, 2],
            [3, 5, 1],
        ]), 46),


        (Matrix2<Int>([
            [3, 1, 7],
            [5, 4, 1],
            [1, 2, 9],
        ]), 100),

        (Matrix2<Int>([
            [4, 0, 1, 2],
            [3, 1, -1, 3],
            [2, 0, 3, 1],
            [2, -2, 3, 1],
        ]), 30),


        (Matrix2<Int>([
            [2, 4, 5, 1],
            [5, 1, 3, 0],
            [1, 6, 7, 2],
            [4, 3, 2, 4],
        ]), -36),

    ])
    func determinant(matrix: Matrix2<Int>, determinant: Int) async throws {
        #expect(matrix.determinant == determinant)
    }

    @Test("add +", arguments: [
            (Matrix2<Int>([[1, 2], [3, 4]]),
             Matrix2<Int>([[5, 6], [7, 8]]),
             Matrix2<Int>([[6, 8], [10, 12]])),
            (Matrix2<Int>([[0, -2, 3]]),
             Matrix2<Int>([[1, 2, -7]]),
             Matrix2<Int>([[1, 0, -4]])),
        ])
    func add(lhs: Matrix2<Int>, rhs: Matrix2<Int>, expected: Matrix2<Int>) async throws {
        #expect(lhs + rhs == expected)
    }


    @Test("add and assign +=", arguments: [
            (Matrix2<Int>([[1, 2], [3, 4]]),
             Matrix2<Int>([[5, 6], [7, 8]]),
             Matrix2<Int>([[6, 8], [10, 12]])),
            (Matrix2<Int>([[0, -2, 3]]),
             Matrix2<Int>([[1, 2, -7]]),
             Matrix2<Int>([[1, 0, -4]])),
        ])
    func addAssign(lhs: Matrix2<Int>, rhs: Matrix2<Int>, expected: Matrix2<Int>) async throws {
        var a = lhs
        a += rhs
        #expect(a == expected)
        var b = rhs
        b += lhs
        #expect(b == expected)
    }

    @Test("scalar multiply *", arguments: [
           (Matrix2<Int>([[1, 2], [3, 4]]), 3, Matrix2<Int>([[3, 6], [9, 12]])),
           (Matrix2<Int>([[0, -2, 3]]), -2, Matrix2<Int>([[0, 4, -6]])),
       ])
   func scalarMultiply(lhs: Matrix2<Int>, k: Int, expected: Matrix2<Int>) async throws {
       #expect(lhs * k == expected)
       #expect(k * lhs == expected)
   }

    @Test("scalar multiply and assign *= ")
    func scalarMultiplyAssign() async throws {
        var m = Matrix2<Int>([[1, 0], [2, 3]])
        m *= 5
        #expect(m == Matrix2<Int>([[5, 0], [10, 15]]))
    }

    @Test("subtraction -", arguments: [
        (Matrix2<Int>([[5, 6], [7, 8]]),
         Matrix2<Int>([[1, 2], [3, 4]]),
         Matrix2<Int>([[4, 4], [4, 4]])),
    ])
    func subtraction(lhs: Matrix2<Int>, rhs: Matrix2<Int>, expected: Matrix2<Int>) async throws {
        #expect(lhs - rhs == expected)
    }

    @Test("subratraction and assign-=")
    func subtractionAssign() async throws {
        var a = Matrix2<Int>([[1, -2], [3, -4]])
        a -= Matrix2<Int>([[1, 1], [1, 1]])
        #expect(a == Matrix2<Int>([[0, -3], [2, -5]]))
    }

    @Test("divide /", arguments: [
        (Matrix2<Double>([
            [4, 6],
            [8, 2]
        ]), 2.0,
         Matrix2<Double>([
             [2, 3],
             [4, 1]
         ])),
    ])
    func divide(lhs: Matrix2<Double>, rhs: Double, expected: Matrix2<Double>) async throws {
        #expect(lhs / rhs == expected)
    }

    @Test("divide and assign /=", arguments: [
        (Matrix2<Double>([
            [4, 6],
            [8, 2]
        ]), 2.0,
         Matrix2<Double>([
             [2, 3],
             [4, 1]
         ])),
    ])
    func divideAssign(lhs: Matrix2<Double>, rhs: Double, expected: Matrix2<Double>) async throws {
        var a = lhs
        a /= rhs
        #expect(a == expected)
    }



    @Test("prefix -")
    func prefixMinus() async throws {
        let a = Matrix2<Int>([[1, -2], [3, -4]])
        #expect(-a == Matrix2<Int>([[-1, 2], [-3, 4]]))
    }

    @Test("multiply *", arguments: [
        (Matrix2<Int>([
            [1, 2, 2],
            [3, 1, 1],
        ]),
         Matrix2<Int>([
            [4, 2],
            [3, 1],
            [1, 5],
         ]),
         Matrix2<Int>([
            [12, 14],
            [16, 12],
         ])),

        (Matrix2<Int>([
            [4, 2],
            [3, 1],
            [1, 5],
        ]),
         Matrix2<Int>([
            [1, 2, 2],
            [3, 1, 1],
         ]),
         Matrix2<Int>([
            [10, 10, 10],
            [6, 7, 7],
            [16, 7, 7],
         ])),


        (Matrix2<Int>([
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
            [1, 0, 2],
            [3, 1, 4],
        ]),
         Matrix2<Int>([
            [1, 2, 1, 0],
            [0, 1, 3, 2],
            [4, 0, 2, 1],
         ]),
         Matrix2<Int>([
            [13, 4, 13, 7],
            [28, 13, 31, 16],
            [43, 22, 49, 25],
            [9, 2, 5, 2],
            [19, 7, 14, 6],
         ])),
    ])
    func multiply(lhs: Matrix2<Int>, rhs: Matrix2<Int>, expected: Matrix2<Int>) async throws {
        #expect(lhs * rhs == expected)
    }

    @Test("transposed() and transpose()")
    func transpose() async throws {
        let m = Matrix2<Int>([[1, 2, 3], [4, 5, 6]])
        let t = m.transposed()
        #expect(t == Matrix2<Int>([[1, 4], [2, 5], [3, 6]]))
        #expect(m.transposed().transposed() == m)

        var mm = m
        mm.transpose()
        #expect(mm == t)
   }

    @Test("determinant (Double) & A * I == A", arguments: [
        Matrix2<Double>([
            [1, 2],
            [3, 4],
        ]),
        Matrix2<Double>([
            [2.5, -1, 0],
            [0,  1.5, 2],
            [3,   1,  1],
        ]),
    ])
    func determinantDoubleAndIdentity(m: Matrix2<Double>) async throws {
        if m.rows == 2 {
            #expect(m.determinant == -2.0)
        } else {
            #expect(m.determinant == -7.25)
        }
        let I = Matrix2<Double>.identity(m.cols)
        #expect(m * I == m)
    }
}
