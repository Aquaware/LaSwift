//
//  Matrix.swift
//  LaSwift
//
//  Created by Ikuo Kudo on 18,March,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Accelerate

public class Matrix {
    private var real_: RMatrix! = nil
    private var isReal_: Bool = false
    private var imag_: RMatrix! = nil
    private var isImag_: Bool = false
    private var rows_: Int = 0
    private var cols_: Int = 0
    
    init() {
    }
    
    init(real: [Double], rows: Int, cols: Int) {
        self.rows_ = rows
        self.cols_ = cols
        self.real_ = RMatrix(array: real, rows: rows, cols: cols)
        self.isReal_ = true
    }
    
    init(real: [[Double]]) {
        self.rows_ = real.count
        self.cols_ = real.first!.count
        self.real_ = RMatrix(array: real)
        self.isReal_ = true
    }
    
    init(imag: [Double], rows: Int, cols: Int) {
        self.imag_ = RMatrix(array: imag, rows: rows, cols: cols)
        self.isImag_ = true
    }
    
    init(imag: [[Double]]) {
        self.rows_ = imag.count
        self.cols_ = imag.first!.count
        self.imag_ = RMatrix(array: imag)
        self.isImag_ = true
    }
    
    init(real: [Double], imag: [Double], rows: Int, cols: Int) {
        assert(real.count == imag.count)
        self.rows_ = rows
        self.cols_ = cols
        self.real_ = RMatrix(array: real, rows: rows, cols: cols)
        self.isReal_ = true
        self.imag_ = RMatrix(array: imag, rows: rows, cols: cols)
        self.isImag_ = true
    }
    
    init(real: [[Double]], imag: [[Double]]) {
        assert(real.count == imag.count && real.first!.count == imag.first!.count)
        self.rows_ = real.count
        self.cols_ = real.first!.count
        self.real_ = RMatrix(array: real)
        self.isReal_ = true
        self.imag_ = RMatrix(array: imag)
        self.isImag_ = true
    }
    
    init(real: RMatrix) {
        self.rows_ = real.rows
        self.cols_ = real.cols
        self.real_ = real
        self.isReal_ = true
    }
    
    init(imag: RMatrix) {
        self.rows_ = imag.rows
        self.cols_ = imag.cols
        self.imag_ = imag
        self.isImag_ = true
    }

    init(real: RMatrix, imag: RMatrix) {
        assert(real.rows == imag.rows && real.cols == imag.cols)
        self.rows_ = real.rows
        self.cols_ = real.cols
        self.real_ = real
        self.isReal_ = true
        self.imag_ = imag
        self.isImag_ = true
    }

    public var shape: (Int, Int) {
        return (self.rows, self.cols)
    }
    
    public var rows: Int {
        return self.rows_
    }
    
    public var cols: Int {
        return self.cols_
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
            return Matrix(real: self.real_.T, imag: self.imag_.T)
        }
        else if self.isReal {
            return Matrix(real: self.real_.T)
        }
        else if self.isImag {
            return Matrix(imag: self.imag_.T)
        }
        else {
            return Matrix()
        }
    }
    
    public final var first: Complex {
        return self[0, 0]
    }
    
    public final var real: RMatrix {
        return self.real_
    }
    
    public final var imag: RMatrix {
        return self.imag_
    }


    public final var isReal: Bool {
        return self.isReal_
    }
    
    public final var isImag: Bool {
        return self.isImag_
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
            if !value.isImag {
                if self.isReal {
                    self.real[theRow, theCol] = value.real
                }
                else {
                    self.real_ = RMatrix.zeros(self.rows, cols: self.cols)
                    self.isReal_ = true
                    self.real[theRow, theCol] = value.real
                }
            }
            else if !value.isReal {
                if self.isReal {
                    self.real[theRow, theCol] = value.real
                }
                else {
                    self.real_ = RMatrix.zeros(self.rows, cols: self.cols)
                    self.isReal_ = true
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
    
    public var description: String {
        var str = "** real **\n"
        str += self.real.description + "\n"
        str += "** imag **\n"
        str += self.imag.description + "\n"
        return str
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
