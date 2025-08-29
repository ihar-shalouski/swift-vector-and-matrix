//
//  TestsUtils.swift
//  SwiftVector
//
//  Created by Igor on 8/29/25.
//

import Foundation
import SwiftVectors

func approx(_ a: Double, _ b: Double, eps: Double = 1e-9) -> Bool {
    abs(a - b) <= eps
}

func approx(_ a: Vector2<Double>, _ b: Vector2<Double>, eps: Double = 1e-9) -> Bool {
    approx(a.x, b.x, eps: eps) && approx(a.y, b.y, eps: eps)
}

func approxf(_ a: Float, _ b: Float, eps: Float = 1e-6) -> Bool {
    abs(a - b) <= eps
}
