# SwiftVectors
[![License](https://img.shields.io/github/license/ihar-shalouski/swift-vector-and-matrix)](LICENSE)
[![Release](https://img.shields.io/github/v/release/ihar-shalouski/swift-vector-and-matrix?sort=semver)](https://github.com/ihar-shalouski/swift-vector-and-matrix/releases)
[![Tag](https://img.shields.io/github/v/tag/ihar-shalouski/swift-vector-and-matrix?sort=semver)](https://github.com/ihar-shalouski/swift-vector-and-matrix/tags)
[![codecov](https://codecov.io/gh/ihar-shalouski/swift-vector-and-matrix/branch/main/graph/badge.svg)](https://codecov.io/gh/ihar-shalouski/swift-vector-and-matrix)
[![Swift Versions](https://img.shields.io/endpoint?url=https://swiftpackageindex.com/api/packages/ihar-shalouski/swift-vector-and-matrix/badge?type=swift-versions)](https://swiftpackageindex.com/ihar-shalouski/swift-vector-and-matrix)
[![Platforms](https://img.shields.io/endpoint?url=https://swiftpackageindex.com/api/packages/ihar-shalouski/swift-vector-and-matrix/badge?type=platforms)](https://swiftpackageindex.com/ihar-shalouski/swift-vector-and-matrix)


A tiny, fast, generic library for working with **vectors** and **matrices** in Swift. Intended for learning and day‑to‑day **linear algebra** and 2D geometry tasks, with a clean, test‑covered API.

_Keywords: vectors, matrices, linear algebra._

## Features

- **`Vector2<T>`** — a generic 2D vector:
  - Arithmetic (`+`, `-`, multiply by scalar, dot product via `dot`, 2D pseudo‑cross via `*` returning a scalar).
  - Length / squared length, normalization, rotation, perpendicular vector `perp`, angle, projection/rejection, `lerp`.
  - Convenient subscript (`v[0]`, `v[1]`), `swapped`, `withX`/`withY`, `ExpressibleByArrayLiteral`.
  - Interop with `CGPoint` (CoreGraphics) and `SIMD2` (simd) when those modules are available.

- **`Matrix2<T>`** — a compact, dynamically‑sized matrix (historical name):
  - Initializers from `(rows, cols, elements)` and from rows `[[T]]`.
  - Safe indexing, extracting rows/cols, submatrices and minors, transpose/in‑place transpose.
  - Matrix arithmetic (`+`, `-`, scalar multiply, matrix×matrix multiply).
  - Determinant (fast paths for 1×1 and 2×2; otherwise expansion by first row).
  - Identity matrix factory and `isIdentity` (for `Numeric & Equatable`).

- Modern protocols: `Codable`, `Hashable`, `Sendable`, `Equatable`.
- Safety first: strict `precondition` checks for dimensions and indices.
- Performance: row‑major storage, reserved capacity, `@inlinable` in hot paths.

> ✅ The current codebase is fully covered by unit tests.

---

## Installation (Swift Package Manager)

### Xcode
**File → Add Packages…** and paste this repo URL.

Import in code:
```swift
import SwiftVectors
```

---

## Quick start

### `Vector2`

```swift
// Doubles
var a = Vector2<Double>(x: 3, y: 4)
let b: Vector2<Double> = [1, 2]   // ExpressibleByArrayLiteral

let sum   = a + b                  // Vector2(4, 6)
let diff  = a - b                  // Vector2(2, 2)
let dot   = a.dot(b)               // 11
let cross = a * b                  // 2D pseudo-cross: 3*2 - 4*1 = 2

let len   = a.length               // 5
let unit  = a.normalized()         // Vector2(0.6, 0.8)

a.rotate(by: .pi / 2)              // +90° (radians)

let proj = a.project(on: b)        // projection of a onto b
let rej  = a.reject(from: b)       // orthogonal component
```

### `Matrix2` (dynamically sized)

```swift
let A = Matrix2(rows: 2, cols: 3, elements: [1, 2, 3,
                                             4, 5, 6])

let B = Matrix2([[7, 8],
                 [9, 10],
                 [11, 12]])        // init from rows

let C = A * B                       // 2×3 · 3×2 = 2×2

let I = Matrix2<Int>.identity(3)    // 3×3
let AT = A.transposed()             // transpose

let D = Matrix2([[1.0, 2.0],
                 [3.0, 4.0]])
let det = D.determinant             // -2.0
let minor = D.minor(ofRow: 0, col: 1)
```

---

## Type constraints & notes

- Most operations require `T: Numeric`. Division, normalization, rotations, etc. require `T: BinaryFloatingPoint`.
- `Matrix2.identity(_:)` and `isIdentity` require `T: Numeric & Equatable`.
- Determinant for `n > 2` uses expansion by first row (fine for small `n`; for larger matrices consider LU in the roadmap).

---

## Testing

Run tests with:
```bash
swift test
```
All public APIs and edge cases are covered: arithmetic, indexing bounds, determinants, transposition, projections, etc.

---

## Roadmap

- `Vector3`, `Vector4`, `Matrix3x3`, `Matrix4x4`, and a general `MatrixN` (fixed and dynamic sizes).
- Inverse, trace, rank; LU/QR/Cholesky; faster determinant via LU.
- Linear system solvers (Gaussian elimination, LU), pseudo‑inverse (SVD), eigenvalues/eigenvectors.
- Performance: SIMD‑accelerated kernels, custom memory layouts, micro‑benchmarks (`swift-benchmark`).
- Protocols (`AdditiveArithmetic`, `VectorArithmetic`) and utilities (row/column slices).
- DocC documentation, richer examples, playgrounds; CI (GitHub Actions); coverage reports.
- SwiftUI demos and small visual inspectors.

---

## Contributing

PRs and issues are welcome! Please include tests and a short motivation for changes.

---

## License

MIT — see `LICENSE`.
