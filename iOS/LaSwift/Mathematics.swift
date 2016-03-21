//
//  Mathematics.swift
//  LaSwift
//
// Created by Ikuo Kudo on 20,March,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Darwin
import Accelerate

extension RMatrix {
    
    public func copy() -> RMatrix {
        let array = self.flat
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func sort() {
        let count = self.rowSize * self.colSize
        var array = self.flat
        vDSP_vsortD(&array, UInt(count), 1)
        la_release(self.la)
        self.la = la_matrix_from_double_buffer( array,
                                                la_count_t(self.rowSize),
                                                la_count_t(self.colSize),
                                                la_count_t(self.colSize),
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
        return calc(axis, clousure: clousure)
    }
    
    public func max() -> Double {
        return self.calcMax(self.flat)
    }
    
    public func max(axis: Int) -> RMatrix {
        let clousure = { (array: [Double]) -> Double in
            return self.calcMax(array)
        }
        return calc(axis, clousure: clousure)
    }

    public func min() -> Double {
        return self.calcMin(self.flat)
    }
    
    public func min(axis: Int) -> RMatrix {
        let clousure = { (array: [Double]) -> Double in
            return self.calcMin(array)
        }
        return calc(axis, clousure: clousure)
    }
    
    public func mean() -> Double {
        return self.calcMean(self.flat)
    }
    
    public func mean(axis: Int) -> RMatrix {
        let clousure = { (array: [Double]) -> Double in
            return self.calcMean(array)
        }
        return calc(axis, clousure: clousure)
    }
    
    public func variance() -> Double {
        assert(self.rowSize > 0 && self.colSize > 0)
        let square = (self - self.mean()) * (self - self.mean())
        return square.sum() / Double(self.rowSize) / Double(self.colSize)
    }
    
    public func std() -> Double {
        return Darwin.sqrt(variance())
    }
    
    public func absolute() -> RMatrix{
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvfabs(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func sqrt() -> RMatrix{
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvsqrt(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func pow(y: RMatrix) -> RMatrix {
        assert(self.rowSize == y.rowSize && self.colSize == y.colSize)
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvpow(&array, self.flat, y.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func exp() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvexp(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func ln() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvlog(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func log2() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvlog2(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func log10() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvlog10(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func ceil() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvceil(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func floor() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvfloor(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func round() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvnint(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func sin() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvsin(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func cos() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvcos(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func tan() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvtan(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func sinh() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvsinh(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func cosh() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvcosh(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func tanh() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvtanh(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func asinh() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvasinh(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func acosh() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvacosh(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
    }
    
    public func atanh() -> RMatrix {
        let count = self.rowSize * self.colSize
        var array = [Double](count: count, repeatedValue: 0.0)
        vvatanh(&array, self.flat, [Int32(count)])
        
        return RMatrix(array: array, rows: self.rowSize, cols: self.colSize)
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
    
    
    private func calc(axis: Int, clousure: ([Double]) -> Double) -> RMatrix {
        var result: [Double]
        if axis == 0 {
            result = [Double](count: self.colSize, repeatedValue: 0.0)
            for var i = 0; i < self.colSize; i++ {
                let vector = slice(self.la, rowRange: 0..<self.rowSize, colRange: i..<i+1)
                result[i] = clousure(vector)
            }
            return RMatrix(array: result, rows: 1, cols: self.colSize)
        }
        else if axis == 1 {
            result = [Double](count: self.rowSize, repeatedValue: 0.0)
            for var i = 0; i < self.rowSize; i++ {
                let vector = slice(self.la, rowRange: i..<i, colRange: 0..<self.colSize)
                result[i] = clousure(vector)
            }
            return RMatrix(array: result, rows: self.colSize, cols: 1)
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
