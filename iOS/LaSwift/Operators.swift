//
//  Operators.swift
//  LaSwift
//
//  Created by Ikuo Kudo on 18,March,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Accelerate

public func + (left: Double, right: Complex) -> Complex {
    return Complex(real: left) + right
}

public func + (left: Complex, right: Double) -> Complex {
    return left + Complex(real: right)
}

public func + (left: Complex, right: Complex) -> Complex {
    if left.isImag && left.isReal && right.isImag && right.isReal {
        return Complex()
    }
    else if left.isReal && right.isReal {
        if left.isImag {
            return Complex(real: right.real)
        }
        else if right.isImag {
            return Complex(real: left.real)
        }
        else {
            return Complex(real: left.real + right.real)
        }
    }
    else if left.isImag && right.isImag {
        if left.isReal {
            return Complex(imag: right.imag)
        }
        else if right.isReal {
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

public func += (inout left: Complex, right: Complex) {
    left = left + right
}

public func += (inout left: Complex, right: Double) {
    left = left + right
}

public func - (left: Double, right: Complex) -> Complex {
    return Complex(real: left) - right
}

public func - (left: Complex, right: Double) -> Complex {
    return left - Complex(real: right)
}

public func - (left: Complex, right: Complex) -> Complex {
    if left.isImag && left.isReal && right.isImag && right.isReal {
        return Complex()
    }
    else if left.isReal && right.isReal {
        if left.isImag {
            return Complex(real: -right.real)
        }
        else if right.isImag {
            return Complex(real: left.real)
        }
        else {
            return Complex(real: left.real - right.real)
        }
    }
    else if left.isImag && right.isImag {
        if left.isReal {
            return Complex(imag: -right.imag)
        }
        else if right.isReal {
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

public func -= (inout left: Complex, right: Complex) {
    left = left - right
}

public func -= (inout left: Complex, right: Double) {
    left = left - right
}

public func * (left: Double, right: Complex) -> Complex {
    return Complex(real: left) * right
}

public func * (left: Complex, right: Double) -> Complex {
    return left * Complex(real: right)
}

public func * (left: Complex, right: Complex) -> Complex {
    if left.isReal && right.isReal && !left.isImag && !right.isImag {
        return Complex(real: left.real * right.real)
    }
    else if !left.isReal && !right.isReal && left.isImag && right.isImag {
        return Complex(real: -left.imag * right.imag)
    }
    else {
        return Complex(  real: left.real * right.real - left.imag * right.imag,
                        imag: left.real * right.imag + left.imag * right.real)
    }
}

public func *= (inout left: Complex, right: Double) {
    left = left * right
}

public func / (left: Complex, right: Complex) -> Complex {
    if left.isImag && right.isImag {
        return Complex(real: right.real / left.real)
    }
    else {
        let lower = left.real * left.real + left.imag * left.imag
        return Complex( real: (left.real * right.real + left.imag * right.imag) / lower,
                        imag: (left.real * right.imag - left.imag * right.real) / lower)
    }
    
}

public func /= (inout left: Complex, right: Complex) {
    left = left / right
}


public func == (left: Complex, right: Complex) -> Bool {
    if left.isReal != right.isReal || left.isImag != right.isImag {
        return false
    }
    
    return (left.real == right.real && left.imag == right.imag) ? true : false
}

public func ~= (left: Complex, right: Complex) -> Bool {
    if (left.real - right.real) > EPS || (left.imag - right.imag) > EPS {
        return false
    }
    
    return (left.real == right.real && left.imag == right.imag) ? true : false
}

func != (left: Complex, right: Complex) -> Bool {
    return !(left == right)
}

// ---

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
        assert(left.rows == right.rows && left.cols == right.cols)
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
        assert(left.rows == right.rows && left.cols == right.cols)
        return RMatrix(la: la_difference(left.la, right.la))
    }
}

public func -= (inout left: RMatrix, right: RMatrix) {
    left = left - right
}

public func * (left: RMatrix, right: Double) -> RMatrix {
    let splat = la_splat_from_double(right, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    return RMatrix(la: la_elementwise_product(left.la, splat))
}

public func * (left: RMatrix, right: Complex) -> Matrix {
    if right.isReal && right.isImag {
        return Matrix()
    }
    else if right.isReal {
        return Matrix(imag: left * right.imag)
    }
    else if right.isImag {
        return Matrix(real: left * right.real)
    }
    else {
        return Matrix(real: left * right.real, imag: left * right.imag)
    }
}

public func * (left: Double, right: RMatrix) -> RMatrix {
    let splat = la_splat_from_double(left, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    let mul = la_elementwise_product( splat, right.la)
    return RMatrix(la: mul)
}



public func * (left: RMatrix, right: RMatrix) -> RMatrix {
    if left.isOneElement {
        return left.first * right
    }
    else if right.isOneElement {
        return left * right.first
    }
    else {
        assert(left.rows == right.rows && left.cols == right.cols)
        return RMatrix(la: la_elementwise_product(left.la, right.la))
    }
}

public func *= (inout left: RMatrix, right: Double) {
    return left = left * right
}

public func *= (inout left: RMatrix, right: RMatrix) {
    return left = left * right
}

public prefix func - (matrix: RMatrix) -> RMatrix {
    return -1 * matrix
}

public func / (left: Double, right: RMatrix) -> RMatrix {
    let splat = la_splat_from_double(left, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    let mul = la_elementwise_product(splat, right.invert().la)
    return RMatrix(la: mul)
}

public func / (left: RMatrix, right: Double) -> RMatrix {
    var value = 0.0
    if abs(right) > EPS {
        value = 1.0 / right
    }
    
    let splat = la_splat_from_double(value, la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    let mul = la_elementwise_product(left.la, splat)
    return RMatrix(la: mul)
}

public func % (left: RMatrix, right: RMatrix) -> RMatrix {
    assert(left.rows == right.rows && left.cols == right.cols)
    let size = left.rows * left.cols
    var buffer = [Double] (count: size, repeatedValue: 0.0)
    for var i = 0; i < size; i++ {
        buffer[i] = left.flat[i] / right.flat[i]
    }
    return RMatrix(array: buffer, rows: left.rows, cols: right.cols)
}

public func / (left: RMatrix, right: RMatrix) -> RMatrix {
    assert(left.rows == left.cols)
    return RMatrix(la: la_solve(left.la, right.la))
}

public func << (shift: Int) -> RMatrix {
    assert(shift >= 0 && shift < self.cols)
    var array = [Double](count: self.rows, repeatedValue: [Double](count: self.cols, repeatedValue: 0.0))
    for var row = 0; row < self.rows; row++ {
        for var col = shift; col < self.cols; col++ {
            array[row][col - shift] = self[row][col]
        }
    }
    return RMatrix(array: array)
}

public func >> (shift: Int) -> RMatrix {
    assert(shift >= 0 && shift < self.cols)
    var array = [Double](count: self.rows, repeatedValue: [Double](count: self.cols, repeatedValue: 0.0))
    for var row = 0; row < self.rows; row++ {
        for var col = 0; col < self.cols; col++ {
            array[row][col + shift] = self[row][col]
        }
    }
    return RMatrix(array: array)
}

public func > (left: RMatrix, right: Double) -> RMatrix {
    let flat = left.flat
    let array = flat.map{$0 > right ? 1.0 : -1.0}
    return RMatrix(array: array, rows: left.rows, cols: left.cols)
}

public func == (left: RMatrix, right: RMatrix) -> Bool {
    if left.rows != right.rows || left.cols != right.cols {
        return false
    }
    
    return (left.flat == right.flat) ? true : false
}

func != (left: RMatrix, right: RMatrix) -> Bool {
    return !(left == right)
}

// ------------

public func + (left: Double, right: Matrix) -> Matrix {
    if right.isReal && right.isImag {
        return Matrix(real: left + right.real, imag: right.imag)
    }
    else if right.isReal{
        return Matrix(real: left + right.real)
    }
    else if right.isImag {
        let real = RMatrix(value: left, rows: right.rows, cols: right.cols)
        return Matrix(real: real, imag: right.imag)
    }
    else {
        let real = RMatrix(value: left, rows: right.rows, cols: right.cols)
        return Matrix(real: real)
    }
}

public func + (left: Matrix, right: Double) -> Matrix {
    if left.isReal && left.isImag {
        return Matrix(real: right + left.real, imag: left.imag)
    }
    else if left.isReal{
        return Matrix(real: right + left.real)
    }
    else if left.isImag {
        let real = RMatrix(value: right, rows: left.rows, cols: left.cols)
        return Matrix(real: real, imag: left.imag)
    }
    else {
        let real = RMatrix(value: right, rows: left.rows, cols: left.cols)
        return Matrix(real: real)
    }
}

public func + (left: Complex, right: Matrix) -> Matrix {
    if right.isReal && right.isImag {
        return Matrix(real: left.real + right.real, imag: left.imag + right.imag)
    }
    else if right.isReal {
        let imag = RMatrix(value: left.imag, rows: right.rows, cols: right.cols)
        return Matrix(real: left.real + right.real, imag: imag)
    }
    else if right.isImag {
        let real = RMatrix(value: left.real, rows: right.rows, cols: right.cols)
        return Matrix(real: real, imag: left.imag + right.imag)
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
        assert(left.rows == right.rows && left.cols == right.cols)
        return Matrix(real: left.real + right.real, imag: left.imag + right.imag)
    }
}

public func += (inout left: Matrix, right: Matrix) {
    left = left + right
}

public func - (left: Double, right: Matrix) -> Matrix {
    if right.isReal && right.isImag {
        return Matrix(real: left - right.real, imag: right.imag)
    }
    else if right.isReal{
        return Matrix(real: left - right.real)
    }
    else if right.isImag {
        let real = RMatrix(value: left, rows: right.rows, cols: right.cols)
        return Matrix(real: real, imag: right.imag)
    }
    else {
        let real = RMatrix(value: left, rows: right.rows, cols: right.cols)
        return Matrix(real: real)
    }
}

public func - (left: Matrix, right: Double) -> Matrix {
    if left.isReal && left.isImag {
        return Matrix(real: right - left.real, imag: left.imag)
    }
    else if left.isReal{
        return Matrix(real: right - left.real)
    }
    else if left.isImag {
        let real = RMatrix(value: -right, rows: left.rows, cols: left.cols)
        return Matrix(real: real, imag: left.imag)
    }
    else {
        let real = RMatrix(value: right, rows: left.rows, cols: left.cols)
        return Matrix(real: real)
    }
}

public func - (left: Complex, right: Matrix) -> Matrix {
    if right.isReal && right.isImag {
        return Matrix(real: left.real - right.real, imag: left.imag - right.imag)
    }
    else if right.isReal {
        let imag = RMatrix(value: left.imag, rows: right.rows, cols: right.cols)
        return Matrix(real: left.real - right.real, imag: imag)
    }
    else if right.isImag {
        let real = RMatrix(value: left.real, rows: right.rows, cols: right.cols)
        return Matrix(real: real, imag: left.imag - right.imag)
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
        assert(left.rows == right.rows && left.cols == right.cols)
        return Matrix(real: left.real - right.real, imag: left.imag - right.imag)
    }
}

public func -= (inout left: Matrix, right: Matrix) {
    left = left - right
}

public func * (left: Double, right: Matrix) -> Matrix {
    if right.isReal && right.isImag {
        return Matrix(real: left * right.real, imag: left * right.imag)
    }
    else if right.isReal{
        return Matrix(real: left * right.real)
    }
    else if right.isImag {
        return Matrix(imag: left * right.imag)
    }
    else {
        return Matrix()
    }
}

public func * (left: Matrix, right: Double) -> Matrix {
    if left.isReal && left.isImag {
        return Matrix(real: right * left.real, imag: right * left.imag)
    }
    else if left.isReal{
        return Matrix(real: right * left.real)
    }
    else if left.isImag {
        return Matrix(imag: right * left.imag)
    }
    else {
        return Matrix()
    }
}

public func * (left: Complex, right: Matrix) -> Matrix {
    if right.isReal && right.isImag {
        let real = left.real * right.real - left.imag * right.imag
        let imag = left.imag * right.real + right.real * left.imag
        return Matrix(real: real, imag: imag)
    }
    else if right.isReal {
        let imag = RMatrix(value: left.imag, rows: right.rows, cols: right.cols)
        return Matrix(real: left.real - right.real, imag: imag)
    }
    else if right.isImag {
        return Matrix(real: left.real * right.real)
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
        assert(left.rows == right.rows && left.cols == right.cols)
        let real = left.real * right.real - left.imag * right.imag
        let imag = left.imag * right.real + right.real * left.imag
        return Matrix(real: real, imag: imag)
    }
}

public func *= (inout left: Matrix, right: Matrix) {
    left = left * right
}

public func / (left: Matrix, right: RMatrix) -> Matrix {
    assert(left.rows == right.rows && left.cols == right.cols)
    let real = left.real / right
    let imag = left.imag / right
    return Matrix(real: real, imag: imag)
}

public func == (left: Matrix, right: Matrix) -> Bool {
    if left.isReal != right.isReal || left.isImag != right.isImag {
        return false
    }

    if left.real == right.real {
        return (left.imag == right.imag) ? true : false
    }
    else {
        return false
    }
}

func != (left: Matrix, right: Matrix) -> Bool {
    return !(left == right)
}
