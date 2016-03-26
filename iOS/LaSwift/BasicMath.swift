//
//  BasicMath.swift
//  LaSwift
//
// Created by Ikuo Kudo on 20,March,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Darwin
import Accelerate

extension Complex {
    public func copy() -> Complex {
        if(self.isReal && self.isImag) {
            return Complex()
        }
        else if self.isReal {
            return Complex(imag: self.imag)
        }
        else if self.isImag {
            return Complex(real: self.real)
        }
        else {
            return Complex(real: self.real, imag: self.imag)
        }
    }
}

extension RMatrix {
    
    public func copy() -> RMatrix {
        let array = self.flat
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func sort() {
        let count = self.rows * self.cols
        var array = self.flat
        vDSP_vsortD(&array, UInt(count), 1)
        //la_release(self.la)
        self.la = la_matrix_from_double_buffer( array,
                                                la_count_t(self.rows),
                                                la_count_t(self.cols),
                                                la_count_t(self.cols),
                                                la_hint_t(LA_NO_HINT),
                                                la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    }
    
    public static func rand(rows: Int, cols: Int) -> RMatrix {
        let count = rows * cols
        var array = [Double](count: count, repeatedValue: 0.0)
        var i:__CLPK_integer = 1
        var seed:Array<__CLPK_integer> = [1, 2, 3, 5]
        var nn: __CLPK_integer  = __CLPK_integer(count)
        dlarnv_(&i, &seed, &nn, &array)
        
        return RMatrix(array: array, rows: rows, cols: cols)
    }
    
    public func sum() -> Double {
        return self.calcSum(self.flat)
    }
    
    public func sum(axis: Int) -> RMatrix {
        let clousure = { (array: [Double]) -> Double in
            return self.calcSum(array)
        }
        return calc(axis, closure: clousure)
    }
    
    public func max() -> Double {
        return self.calcMax(self.flat)
    }
    
    public func max(axis: Int) -> RMatrix {
        let closure = { (array: [Double]) -> Double in
            return self.calcMax(array)
        }
        return calc(axis, closure: closure)
    }

    public func min() -> Double {
        return self.calcMin(self.flat)
    }
    
    public func min(axis: Int) -> RMatrix {
        let closure = { (array: [Double]) -> Double in
            return self.calcMin(array)
        }
        return calc(axis, closure: closure)
    }
    
    public func mean() -> Double {
        return self.calcMean(self.flat)
    }
    
    public func mean(axis: Int) -> RMatrix {
        let closure = { (array: [Double]) -> Double in
            return self.calcMean(array)
        }
        return calc(axis, closure: closure)
    }
    
    public func variance() -> Double {
        assert(self.rows > 0 && self.cols > 0)
        let square = (self - self.mean()) * (self - self.mean())
        return square.sum() / Double(self.rows) / Double(self.cols)
    }
    
    public func std() -> Double {
        return Darwin.sqrt(variance())
    }
    
    public func absolute() -> RMatrix{
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvfabs(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func sqrt() -> RMatrix{
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvsqrt(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func pow(y: RMatrix) -> RMatrix {
        assert(self.rows == y.rows && self.cols == y.cols)
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvpow(&array, self.flat, y.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func exp() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvexp(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func ln() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvlog(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func log2() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvlog2(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func log10() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvlog10(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func ceil() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvceil(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func floor() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvfloor(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func round() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvnint(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func sin() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvsin(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func cos() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvcos(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func tan() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvtan(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func sinh() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvsinh(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func cosh() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvcosh(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func tanh() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvtanh(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func asinh() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvasinh(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func acosh() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvacosh(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
    
    public func atanh() -> RMatrix {
        let count = self.rows * self.cols
        var array = [Double](count: count, repeatedValue: 0.0)
        vvatanh(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }

    // ---
    
    private func calcSum(array: [Double]) -> Double {
        var value: Double = 0.0
        vDSP_sveD(array, 1, &value, vDSP_Length(array.count))
        return value
    }
    
    private func calcMax(array: [Double]) -> Double {
        var value: Double = 0.0
        vDSP_maxvD(array, 1, &value, vDSP_Length(array.count))
        return value
    }
    
    private func calcMin(array: [Double]) -> Double {
        var value: Double = 0.0
        vDSP_minvD(array, 1, &value, vDSP_Length(array.count))
        return value
    }
    
    private func calcMean(array: [Double]) -> Double {
        var value: Double = 0.0
        vDSP_meanvD(array, 1, &value, vDSP_Length(array.count))
        return value
    }
    
    
    private func calc(axis: Int, closure: ([Double]) -> Double) -> RMatrix {
        var result: [Double]
        if axis == 0 {
            result = [Double](count: self.cols, repeatedValue: 0.0)
            for var i = 0; i < self.cols; i++ {
                let vector = slice(self.la, rowRange: 0..<self.rows, colRange: i..<i+1)
                result[i] = closure(vector)
            }
            return RMatrix(array: result, rows: 1, cols: self.cols)
        }
        else if axis == 1 {
            result = [Double](count: self.rows, repeatedValue: 0.0)
            for var i = 0; i < self.rows; i++ {
                let vector = slice(self.la, rowRange: i..<i, colRange: 0..<self.cols)
                result[i] = closure(vector)
            }
            return RMatrix(array: result, rows: self.cols, cols: 1)
        }
        else {
            return RMatrix()
        }
    }
    
    private func slice(la: la_object_t, rowRange: Range<Int>, colRange: Range<Int>) -> [Double]{
        let rows = rowRange.endIndex - rowRange.startIndex
        let cols = colRange.endIndex - colRange.startIndex
        let la = la_matrix_slice(   self.la,
                                    la_index_t(rowRange.startIndex),
                                    la_index_t(colRange.startIndex),
                                    1,
                                    1,
                                    la_count_t(rows),
                                    la_count_t(cols) )
        
        var array = [Double](count: rows * cols, repeatedValue: 0.0)
        la_matrix_to_double_buffer(&array, la_count_t(rows * cols), la)

        return array
    }
}


extension Matrix {
    
    public func copy() -> Matrix {
        let real = self.real
        let imag = self.imag
        return Matrix(real: real, imag: imag)
    }
    
    public func sort() {
        let count = self.rows * self.cols
        var array = self.real.flat
        vDSP_vsortD(&array, UInt(count), 1)
        la_release(self.real.la)
        self.real.la = la_matrix_from_double_buffer(    array,
                                                        la_count_t(self.rows),
                                                        la_count_t(self.cols),
                                                        la_count_t(self.cols),
                                                        la_hint_t(LA_NO_HINT),
                                                        la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    }
    
    public static func rand(rows: Int, cols: Int) -> Matrix {
        let count = rows * cols
        var array = [Double](count: count, repeatedValue: 0.0)
        var i:__CLPK_integer = 1
        var seed:Array<__CLPK_integer> = [1, 2, 3, 5]
        var nn: __CLPK_integer  = __CLPK_integer(count)
        dlarnv_(&i, &seed, &nn, &array)
        
        return Matrix(real: array, rows: rows, cols: cols)
    }
    
    public func sum(axis: Int) -> Matrix {
        return Matrix(real: self.real.sum(axis), imag: self.imag.sum(axis))
    }
    
    public func max(axis: Int) -> Matrix {
        return Matrix(real: self.real.max(axis), imag: self.imag.max(axis))
    }

    public func min(axis: Int) -> Matrix {
          return Matrix(real: self.real.min(axis), imag: self.imag.min(axis))
    }
    
    public func mean(axis: Int) -> Matrix {
        return Matrix(real: self.real.mean(axis), imag: self.imag.mean(axis))
    }
    
    public func variance() -> Double {
        assert(self.rows > 0 && self.cols > 0)
        return self.real.variance()
    }
    
    public func std() -> Double {
        return self.real.std()
    }
    
    public func absolute() -> Matrix{
        return Matrix(real:self.real.absolute())
    }
    
    public func sqrt() -> Matrix{
        return Matrix(real:self.real.sqrt())
    }
    
    public func exp() -> Matrix {
        return Matrix(real:self.real.exp())
    }
    
    public func ln() -> Matrix {
        return Matrix(real:self.real.ln())
    }
    
    public func log2() -> Matrix {
        return Matrix(real:self.real.log2())
    }
    
    public func log10() -> Matrix {
        return Matrix(real:self.real.log10())
    }
    
    public func ceil() -> Matrix {
        return Matrix(real:self.real.ceil())
    }
    
    public func floor() -> Matrix {
        return Matrix(real:self.real.floor())
    }
    
    public func round() -> Matrix {
        return Matrix(real:self.real.round())
    }
    
    public func sin() -> Matrix {
        return Matrix(real:self.real.sin())
    }
    
    public func cos() -> Matrix {
        return Matrix(real:self.real.cos())
    }
    
    public func tan() -> Matrix {
        return Matrix(real:self.real.tan())
    }
    
    public func sinh() -> Matrix {
        return Matrix(real:self.real.sinh())
    }
    
    public func cosh() -> Matrix {
        return Matrix(real:self.real.cosh())
    }
    
    public func tanh() -> Matrix {
        return Matrix(real:self.real.tanh())
    }
    
    public func asinh() -> Matrix {
        return Matrix(real:self.real.asinh())
    }
    
    public func acosh() -> Matrix {
        return Matrix(real:self.real.acosh())
    }
    
    public func atanh() -> Matrix {
        return Matrix(real:self.real.atanh())
    }

}
