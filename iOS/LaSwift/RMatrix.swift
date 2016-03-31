//
//  RMatrix.swift
//  LaSwift
//
//  Created by Ikuo Kudo on March,16,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Accelerate

public let EPS: Double = 1e-50

public class RMatrix {
    public var la: la_object_t! = nil
    private var rows_: Int = 0
    private var cols_: Int = 0

    init() {        
    }
    
    init(array: [[Double]]) {
        self.rows_ = array.count
        self.cols_ = array.first!.count
        assert(self.rows > 0 && self.cols > 0)
        var buffer = [Double](count: self.rows * self.cols, repeatedValue: 0.0)
        for var i = 0; i < self.rows; i++ {
            let begin = i * self.cols
            let end = begin + self.cols
            let item = array[i]
            buffer[begin..<end] = item[0..<self.cols]
        }
        self.la = toLaObject(buffer, rows: self.rows, cols: self.cols)
    }
    
    init(array: [Double], rows: Int, cols: Int) {
        self.rows_ = rows
        self.cols_ = cols
        self.la = toLaObject(array, rows: self.rows, cols: self.cols)
    }
    
    init(value: Double, rows: Int, cols: Int) {
        self.rows_ = rows
        self.cols_ = cols
        let array = [Double](count: rows * cols, repeatedValue: value)
        self.la = toLaObject(array, rows: self.rows, cols: self.cols)
    }
    
    init(la: la_object_t) {
        self.rows_ = Int(la_matrix_rows(la))
        self.cols_ = Int(la_matrix_cols(la))
        self.la = la
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
    
    public var flat: [Double] {
        var array = [Double](count: self.rows * self.cols, repeatedValue: 0.0)
        la_matrix_to_double_buffer(&array, la_count_t(self.cols), self.la)
        return array
    }
    
    public var array: [[Double]] {
        let flat = self.flat
        var array = [[Double]]()
        for var i = 0; i < self.rows; i++ {
            let begin = i * self.cols
            let end = begin + self.cols - 1
            let item = Array(flat[begin...end])
            array.append(item)
        }
        return array
    }
    
    public var isOneElement: Bool {
        return (self.rows == 1 && self.cols == 1)
    }
    
    public var isNone: Bool {
        return (self.rows == 0 || self.cols == 0 || self.la == nil)
    }
    
    public var isRowVector: Bool {
        return (self.rows == 1 && self.cols > 1)
    }
    
    public var isColVector: Bool {
        return (self.cols == 1 && self.rows > 1)
    }
    
    public final var T: RMatrix {
        return RMatrix(la: la_transpose(self.la))
    }
    
    public final var first: Double {
        return self[0, 0]
    }
    
    public final func reshape(rows: Int, cols: Int) -> RMatrix {
        assert(rows * cols == self.rows * self.cols)
        let flat = self.flat
        self.rows_ = rows
        self.cols_ = cols
        self.la = toLaObject( flat, rows: self.rows, cols: self.cols)
        return RMatrix(la: la)
    }
    
    public func len() -> Int {
        if isNone {
            return 0
        }
        else if isOneElement {
            return 1
        }
        else if isRowVector {
            return self.cols
        }
        else if isColVector {
            return self.rows
        }
        else {
            return self.rows
        }
    }
    
    public func slice(rowRange: Range<Int>, colRange: Range<Int>) -> RMatrix {
        assert(rowRange.startIndex >= 0 && rowRange.endIndex <= self.rows && rowRange.endIndex >= rowRange.startIndex)
        assert(colRange.startIndex >= 0 && colRange.endIndex <= self.cols && colRange.endIndex >= colRange.startIndex)
        let la = la_matrix_slice(   self.la,
                                    la_index_t(rowRange.startIndex),
                                    la_index_t(colRange.startIndex),
                                    1,
                                    1,
                                    la_count_t(rowRange.endIndex - rowRange.startIndex),
                                    la_count_t(colRange.endIndex - colRange.startIndex) )
        return RMatrix(la: la)
    }
    
    public func insert(array: [[Double]], axis: Int = 0) {
        let rows = array.count
        let cols = array.first!.count
        if axis == 0 {
            assert(self.cols == cols)
            self.rows_ += rows
            var flat = self.flat
            flat += array.flatten()
            self.la = toLaObject(flat, rows: self.rows, cols: self.cols)            
        }
        else {
            assert(self.rows == rows)
            self.cols_ += cols
            var buffer = [Double](count: self.cols * self.rows, repeatedValue: 0.0)
            var index: Int = 0
            for var row = 0; row < self.rows; row++ {
                for var col = 0; col < self.cols; col++ {
                    buffer[index] = self[row, col]
                    index++
                }
                for var col = 0; col < cols; col++ {
                    buffer[index] = array[row][col]
                    index++
                }
            }
            self.la = toLaObject(flat, rows: self.rows, cols: self.cols)  
        }
    }
    
    public func invert() -> RMatrix {
        var flat = self.flat
        for var i = 0; i < self.rows * self.cols; i++ {
            let value:Double = flat[i]
            if abs(value) > EPS {
                flat[i] = 1.0 / value
            }
            else {
                flat[i] = 0.0
            }
        }
        return RMatrix(array: flat, rows: self.rows, cols: self.cols)
    }
    
    public static func identity(dimension: Int = 1) -> RMatrix {
        let la = la_identity_matrix(    la_count_t(dimension),
                                        la_scalar_type_t(LA_SCALAR_TYPE_DOUBLE),
                                        la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        return RMatrix(la: la)
    }
    
    public static func ones(rows: Int, cols: Int) -> RMatrix {
        return arange(rows, cols: cols, value: 1.0)
    }
    
    public static func zeros(rows: Int, cols: Int) -> RMatrix {
        return arange(rows, cols: cols, value: 0.0)
    }
    
    public static func arange(rows: Int = 1, cols: Int = 1, value: Double) ->RMatrix {
        let array = Array(count: rows * cols, repeatedValue: value)
        return RMatrix(array: array, rows: rows, cols: cols)
    }
    
    public static func linspace(start: Double, end: Double, num: Int, endpoint: Bool = true) -> RMatrix {
        var step = 0.0
        if endpoint {
            assert(num > 1)
            step = (end - start) / Double(num - 1)
        }
        else {
            assert(num > 0)
            step = (end - start) / Double(num)
        }
        
        var array = [Double](count: num, repeatedValue: 0)
        var value = start
        for var i = 0; i < num; i++ {
            array[i] = value
            value += step
        }
        
        return RMatrix(array: array, rows: 1, cols: num)
    }
    
    subscript (row: Int, col: Int) -> Double {
        get {
            let theRow = checkRow(row)
            let theCol = checkCol(col)
            var array = [0.0]
            let slice = la_matrix_slice(   self.la,
                                            la_index_t(theRow),
                                            la_index_t(theCol),
                                            1,
                                            1,
                                            1,
                                            1)
            la_matrix_to_double_buffer(&array, 1, slice)
            return array.first!
        }
        
        set(value) {
            var buffer = self.flat
            let index = col + row * self.cols
            assert(index >= 0 && index < self.cols * self.rows)
            buffer[index] = value
            self.la = toLaObject(buffer, rows: self.rows, cols: self.cols)
        }
    }
    
    subscript (rowOrColumn: Int) -> RMatrix {
        get {
            if self.isRowVector {
                let col = checkCol(rowOrColumn)
                let array: [Double] = [0.0]
                array[0] = self[0, col]
                return RMatrix(array: array, rows: 1, cols: 1)
            }
            else if self.isColVector {
                let row = checkRow(rowOrColumn)
                let array: [Double] = [0.0]
                array[0] = self[row, 0]
                return RMatrix(array: array, rows: 1, cols: 1)
            }
            else {
                let row = checkRow(rowOrColumn)
                let slice = la_matrix_slice(   self.la,
                                            la_index_t(row),
                                            0,
                                            1,
                                            1,
                                            1,
                                            la_count_t(self.cols))
                return RMatrix(la: slice)
            }        
        }
    }
    
    public var description: String {
        let array = self.array
        return array.reduce("") {
            (acc, rowVals) in acc + rowVals.reduce("") {
                (ac, colVals) in ac + "\(colVals) "
            } + "\n"
        }
    }
    
    public func toLaObject(array: [Double], rows: Int, cols: Int) -> la_object_t {
        let laObject = la_matrix_from_double_buffer( array,
                                                la_count_t(rows),
                                                la_count_t(cols),
                                                la_count_t(cols),
                                                la_hint_t(LA_NO_HINT),
                                                la_attribute_t(LA_DEFAULT_ATTRIBUTES))
       return laObject
    }                            
                                                
    private func checkRow(row: Int) -> Int {
        assert(row >= 0 && row < self.rows)
        return (row >= 0) ?  row : self.rows + row
    }
    
    private func checkCol(col: Int) -> Int {
        assert(col >= 0 && col < self.cols)
        return (col >= 0) ?  col : self.cols + col
    }

}