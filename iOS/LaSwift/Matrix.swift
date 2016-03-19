//
//  Matrix.swift
//  LaSwift
//
//  Created by Ikuo Kudo on March,18,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Accelerate

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

public class Matrix {
    private var real: RMatrix! = nil
    private var isReal: Bool = false
    private var imag: RMatrix! = nil
    private var isImag: Bool = false
    private var rows: Int = 0
    private var cols: Int = 0
    
    init() {
    }
    
    init(real: [Double], rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        self.real = RMatrix(array: real, rows: rows, cols: cols)
        self.isReal = true
    }
    
    init(real: [[Double]]) {
        self.rows = real.count
        self.cols = real.first!.count
        self.real = RMatrix(array: real)
        self.isReal = true
    }
    
    init(imag: [Double], rows: Int, cols: Int) {
        self.imag = RMatrix(array: imag, rows: rows, cols: cols)
        self.isImag = true
    }
    
    init(imag: [[Double]]) {
        self.rows = imag.count
        self.cols = imag.first!.count
        self.imag = RMatrix(array: imag)
        self.isImag = true
    }
    
    init(real: [Double], imag: [Double], rows: Int, cols: Int) {
        assert(real.count == imag.count)
        self.rows = rows
        self.cols = cols
        self.real = RMatrix(array: real, rows: rows, cols: cols)
        self.isReal = true
        self.imag = RMatrix(array: imag, rows: rows, cols: cols)
        self.isImag = true
    }
    
    init(real: [[Double]], imag: [[Double]]) {
        assert(real.count == imag.count && real.first!.count == imag.first!.count)
        self.rows = real.count
        self.cols = real.first!.count
        self.real = RMatrix(array: real)
        self.isReal = true
        self.imag = RMatrix(array: imag)
        self.isImag = true
    }
    
    init(real: RMatrix) {
        self.rows = real.rowSize
        self.cols = real.colSize
        self.real = real
        self.isReal = true
    }
    
    init(imag: RMatrix) {
        self.rows = imag.rowSize
        self.cols = imag.colSize
        self.imag = imag
        self.isImag = true
    }

    init(real: RMatrix, imag: RMatrix) {
        assert(real.rowSize == imag.rowSize && real.colSize == imag.colSize)
        self.rows = real.rowSize
        self.cols = real.colSize
        self.real = real
        self.isReal = true
        self.imag = imag
        self.isImag = true
    }

    public var shape: (Int, Int) {
        return (self.rows, self.cols)
    }
    
    public var rowSize: Int {
        return self.rows
    }
    
    public var colSize: Int {
        return self.cols
    }

    public var isOneElement: Bool {
        return (self.rows == 1 && self.cols == 1)
    }
    
    public var isNone: Bool {
        return (self.rows == 0 || self.cols == 0 || (!self.isReal && !self.isImag))
    }
    
    public var isRowVector: Bool {
        return (self.rows == 1 && self.cols > 1)
    }
    
    public var isColVector: Bool {
        return (self.cols == 1 && self.rows > 1)
    }
    
    public final var T: Matrix {
        if self.isReal && self.isImag {
            return Matrix(real: self.real.T, imag: self.imag.T)
        }
        else if self.isReal {
            return Matrix(real: self.real.T)
        }
        else if self.isImag {
            return Matrix(imag: self.imag.T)
        }
        else {
            return Matrix()
        }
    }
    
    public final var first: Complex {
        return self[0, 0]
    }
    
    subscript (row: Int, col: Int) -> Complex {
        get{
            let theRow = checkRow(row)
            let theCol = checkCol(col)
            if self.isReal && self.isImag {
                return Complex(real: self.real[theRow, theCol], imag: self.imag[theRow, theCol])
            }
            else if self.isReal {
                return Complex(real: self.real[theRow, theCol])
            }
            else if self.isImag {
                return Complex(imag: self.imag[theRow, theCol])
            }
            else {
                return Complex()
            }
        }
        
        set(value) {
            let theRow = checkRow(row)
            let theCol = checkCol(col)
            if !value.isImagPerfectZero {
                if self.isReal {
                    self.real[theRow, theCol] = value.real
                }
                else {
                    self.real = RMatrix.zeros(self.rows, cols: self.cols)
                    self.isReal = true
                    self.real[theRow, theCol] = value.real
                }
            }
            else if !value.isRealPerfectZero {
                if self.isReal {
                    self.real[theRow, theCol] = value.real
                }
                else {
                    self.real = RMatrix.zeros(self.rows, cols: self.cols)
                    self.isReal = true
                    self.real[theRow, theCol] = value.real
                }
            }
        }
    }
    
    subscript (row: Int) -> Matrix {
        get{
            let theRow = checkRow(row)
            if self.isReal && self.isImag {
                return Matrix(real: self.real[theRow], imag: self.imag[theRow])
            }
            else if self.isReal {
                return Matrix(real: self.real[theRow])
            }
            else if self.isImag {
                return Matrix(imag: self.imag[theRow])
            }
            else {
                return Matrix()
            }
        }
    }
    
    private func checkRow(row: Int) -> Int {
        assert(row >= 0 && row < self.rows)
        return row >= 0 ? row : self.rows + row
    }
    
    private func checkCol(col: Int) -> Int {
        assert(col >= 0 && col < self.cols)
        return col >= 0 ? col : self.cols + col
    }
    
}
