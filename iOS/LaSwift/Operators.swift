//
//  Operators.swift
//  LaSwift
//
//  Created by Ikuo Kudo on March,18,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Accelerate


public func + (left: Complex, right: Complex) -> Complex {
    if left.isImagPerfectZero && left.isRealPerfectZero && right.isImagPerfectZero && right.isRealPerfectZero {
        return Complex()
    }
    else if left.isRealPerfectZero && right.isRealPerfectZero {
        if left.isImagPerfectZero {
            return Complex(real: right.real)
        }
        else if right.isImagPerfectZero {
            return Complex(real: left.real)
        }
        else {
            return Complex(real: left.real + right.real)
        }
    }
    else if left.isImagPerfectZero && right.isImagPerfectZero {
        if left.isRealPerfectZero {
            return Complex(imag: right.imag)
        }
        else if right.isRealPerfectZero {
            return Complex(imag: left.imag)
        }
        else {
            return Complex(imag: left.imag + right.imag)
        }
    }
    else {
        return Complex(real: left.real + right.real, imag: left.imag + right.imag)
    }
}

public func - (left: Complex, right: Complex) -> Complex {
    if left.isImagPerfectZero && left.isRealPerfectZero && right.isImagPerfectZero && right.isRealPerfectZero {
        return Complex()
    }
    else if left.isRealPerfectZero && right.isRealPerfectZero {
        if left.isImagPerfectZero {
            return Complex(real: -right.real)
        }
        else if right.isImagPerfectZero {
            return Complex(real: left.real)
        }
        else {
            return Complex(real: left.real - right.real)
        }
    }
    else if left.isImagPerfectZero && right.isImagPerfectZero {
        if left.isRealPerfectZero {
            return Complex(imag: -right.imag)
        }
        else if right.isRealPerfectZero {
            return Complex(imag: left.imag)
        }
        else {
            return Complex(imag: left.imag - right.imag)
        }
    }
    else {
        return Complex(real: left.real - right.real, imag: left.imag - right.imag)
    }
}

// ------------

public func + (left: Double, right: RMatrix) -> RMatrix {
    let splat = la_splat_from_double(left, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    let sum = la_sum(splat, right.la)
    return RMatrix(la: sum)
}

public func + (left: RMatrix, right: Double) -> RMatrix {
    let splat = la_splat_from_double(right, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    let sum = la_sum(left.la, splat)
    return RMatrix(la: sum)
}

public func + (left: RMatrix, right: RMatrix) -> RMatrix {
    if left.isOneElement {
        return left.first + right
    }
    else if right.isOneElement {
        return left + right.first
    }
    else {
        assert(left.rowSize == right.rowSize && left.colSize == right.colSize)
        return RMatrix(la: la_sum(left.la, right.la))
    }
}

public func += (inout left: RMatrix, right: RMatrix) {
    left = left + right
}

public func - (left: Double, right: RMatrix) -> RMatrix {
    let splat = la_splat_from_double(left, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    return RMatrix(la: la_difference(splat, right.la))
}

public func - (left: RMatrix, right: Double) -> RMatrix {
    let splat = la_splat_from_double(right, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    return RMatrix(la: la_difference(left.la, splat))
}

public func - (left: RMatrix, right: RMatrix) -> RMatrix {
    if left.isOneElement {
        return left.first - right
    }
    else if right.isOneElement {
        return left - right.first
    }
    else {
        assert(left.rowSize == right.rowSize && left.colSize == right.colSize)
        return RMatrix(la: la_difference(left.la, right.la))
    }
}

public func -= (inout left: RMatrix, right: RMatrix) {
    left = left - right
}

public func * (left: Double, right: RMatrix) -> RMatrix {
    let splat = la_splat_from_double(left, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    let mul = la_elementwise_product( splat, right.la)
    return RMatrix(la: mul)
}

public func * (left: RMatrix, right: Double) -> RMatrix {
    let splat = la_splat_from_double(right, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    return RMatrix(la: la_elementwise_product(left.la, splat))
}

public func * (left: RMatrix, right: RMatrix) -> RMatrix {
    if left.isOneElement {
        return left.first * right
    }
    else if right.isOneElement {
        return left * right.first
    }
    else {
        assert(left.rowSize == right.rowSize && left.colSize == right.colSize)
        return RMatrix(la: la_elementwise_product(left.la, right.la))
    }
}

public prefix func - (matrix: RMatrix) -> RMatrix {
    return -1 * matrix
}

public func / (left: Double, right: RMatrix) -> RMatrix {
    let splat = la_splat_from_double(left, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    let mul = la_elementwise_product(splat, right.inv().la)
    return RMatrix(la: mul)
}

public func / (left: RMatrix, right: Double) -> RMatrix {
    var value = 0.0
    if abs(right) > 1e-50 {
        value = 1.0 / right
    }
    
    let splat = la_splat_from_double(value, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    let mul = la_elementwise_product(left.la, splat)
    return RMatrix(la: mul)
}

public func / (left: RMatrix, right: RMatrix) -> RMatrix {
    assert(left.rowSize == left.colSize)
    return RMatrix(la: la_solve(left.la, right.la))
}

public func > (left: RMatrix, right: Double) -> RMatrix {
    let flat = left.flat
    let array = flat.map{$0 > right ? 1.0 : -1.0}
    return RMatrix(array: array, rows: left.rowSize, cols: left.colSize)
}


// ------------

public func + (left: Double, right: Matrix) -> Matrix {
    if right.isRealPart && right.isImagPart {
        return Matrix(real: left + right.realPart, imag: right.imagPart)
    }
    else if right.isRealPart{
        return Matrix(real: left + right.realPart)
    }
    else if right.isImagPart {
        let real = RMatrix(value: left, rows: right.rowSize, cols: right.colSize)
        return Matrix(real: real, imag: right.imagPart)
    }
    else {
        let real = RMatrix(value: left, rows: right.rowSize, cols: right.colSize)
        return Matrix(real: real)
    }
}

public func + (left: Matrix, right: Double) -> Matrix {
    if left.isRealPart && left.isImagPart {
        return Matrix(real: right + left.realPart, imag: left.imagPart)
    }
    else if left.isRealPart{
        return Matrix(real: right + left.realPart)
    }
    else if left.isImagPart {
        let real = RMatrix(value: right, rows: left.rowSize, cols: left.colSize)
        return Matrix(real: real, imag: left.imagPart)
    }
    else {
        let real = RMatrix(value: right, rows: left.rowSize, cols: left.colSize)
        return Matrix(real: real)
    }
}

public func + (left: Complex, right: Matrix) -> Matrix {
    if right.isRealPart && right.isImagPart {
        return Matrix(real: left.real + right.realPart, imag: left.imag + right.imagPart)
    }
    else if right.isRealPart {
        let imag = RMatrix(value: left.imag, rows: right.rowSize, cols: right.colSize)
        return Matrix(real: left.real + right.realPart, imag: imag)
    }
    else if right.isImagPart {
        let real = RMatrix(value: left.real, rows: right.rowSize, cols: right.colSize)
        return Matrix(real: real, imag: left.imag + right.imagPart)
    }
    else {
        return Matrix()
    }
}

public func + (left: Matrix, right: Matrix) -> Matrix {
    if left.isOneElement {
        return left.first.real + right
    }
    else if right.isOneElement {
        return left + right.first.real
    }
    else {
        assert(left.rowSize == right.rowSize && left.colSize == right.colSize)
        return Matrix(real: left.realPart + right.realPart, imag: left.imagPart + right.imagPart)
    }
}

public func += (inout left: Matrix, right: Matrix) {
    left = left + right
}

public func - (left: Double, right: Matrix) -> Matrix {
    if right.isRealPart && right.isImagPart {
        return Matrix(real: left - right.realPart, imag: right.imagPart)
    }
    else if right.isRealPart{
        return Matrix(real: left - right.realPart)
    }
    else if right.isImagPart {
        let real = RMatrix(value: left, rows: right.rowSize, cols: right.colSize)
        return Matrix(real: real, imag: right.imagPart)
    }
    else {
        let real = RMatrix(value: left, rows: right.rowSize, cols: right.colSize)
        return Matrix(real: real)
    }
}

public func - (left: Matrix, right: Double) -> Matrix {
    if left.isRealPart && left.isImagPart {
        return Matrix(real: right - left.realPart, imag: left.imagPart)
    }
    else if left.isRealPart{
        return Matrix(real: right - left.realPart)
    }
    else if left.isImagPart {
        let real = RMatrix(value: -right, rows: left.rowSize, cols: left.colSize)
        return Matrix(real: real, imag: left.imagPart)
    }
    else {
        let real = RMatrix(value: right, rows: left.rowSize, cols: left.colSize)
        return Matrix(real: real)
    }
}

public func - (left: Complex, right: Matrix) -> Matrix {
    if right.isRealPart && right.isImagPart {
        return Matrix(real: left.real - right.realPart, imag: left.imag - right.imagPart)
    }
    else if right.isRealPart {
        let imag = RMatrix(value: left.imag, rows: right.rowSize, cols: right.colSize)
        return Matrix(real: left.real - right.realPart, imag: imag)
    }
    else if right.isImagPart {
        let real = RMatrix(value: left.real, rows: right.rowSize, cols: right.colSize)
        return Matrix(real: real, imag: left.imag - right.imagPart)
    }
    else {
        return Matrix()
    }
}

public func - (left: Matrix, right: Matrix) -> Matrix {
    if left.isOneElement {
        return left.first.real - right
    }
    else if right.isOneElement {
        return left - right.first.real
    }
    else {
        assert(left.rowSize == right.rowSize && left.colSize == right.colSize)
        return Matrix(real: left.realPart - right.realPart, imag: left.imagPart - right.imagPart)
    }
}

public func -= (inout left: Matrix, right: Matrix) {
    left = left - right
}

public func * (left: Double, right: Matrix) -> Matrix {
    if right.isRealPart && right.isImagPart {
        return Matrix(real: left * right.realPart, imag: left * right.imagPart)
    }
    else if right.isRealPart{
        return Matrix(real: left * right.realPart)
    }
    else if right.isImagPart {
        return Matrix(imag: left * right.imagPart)
    }
    else {
        return Matrix()
    }
}

public func * (left: Matrix, right: Double) -> Matrix {
    if left.isRealPart && left.isImagPart {
        return Matrix(real: right * left.realPart, imag: right * left.imagPart)
    }
    else if left.isRealPart{
        return Matrix(real: right * left.realPart)
    }
    else if left.isImagPart {
        return Matrix(imag: right * left.imagPart)
    }
    else {
        return Matrix()
    }
}

public func * (left: Complex, right: Matrix) -> Matrix {
    if right.isRealPart && right.isImagPart {
        let real = left.real * right.realPart - left.imag * right.imagPart
        let imag = left.imag * right.realPart + right.realPart * left.imag
        return Matrix(real: real, imag: imag)
    }
    else if right.isRealPart {
        let imag = RMatrix(value: left.imag, rows: right.rowSize, cols: right.colSize)
        return Matrix(real: left.real - right.realPart, imag: imag)
    }
    else if right.isImagPart {
        return Matrix(real: left.real * right.realPart)
    }
    else {
        return Matrix()
    }
}

public func * (left: Matrix, right: Matrix) -> Matrix {
    if left.isOneElement {
        return left.first.real * right
    }
    else if right.isOneElement {
        return left * right.first.real
    }
    else {
        assert(left.rowSize == right.rowSize && left.colSize == right.colSize)
        let real = left.realPart * right.realPart - left.imagPart * right.imagPart
        let imag = left.imagPart * right.realPart + right.realPart * left.imagPart
        return Matrix(real: real, imag: imag)
    }
}

public func *= (inout left: Matrix, right: Matrix) {
    left = left * right
}

