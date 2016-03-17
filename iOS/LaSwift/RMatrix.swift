//
//  RMatrix.swift
//  LaSwift
//
//  Created by Ikuo Kudo on 2016/03/16.
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Foundation
import Accelerate

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
        assert(left.rows == right.rows && left.cols == right.cols)
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
    assert(left.rows == left.cols)
    return RMatrix(la: la_solve(left.la, right.la))
}

public func > (left: RMatrix, right: Double) -> RMatrix {
    let flat = left.flat
    let array = flat.map{$0 > right ? 1.0 : -1.0}
    return RMatrix(array: array, rows: left.rows, cols: left.cols)
}

public class RMatrix {
    public var la: la_object_t! = nil
    private var rows: Int = 0
    private var cols: Int = 0
    
    init(array: [[Double]]) {
        self.rows = array.count
        self.cols = array.first!.count
        assert(self.rows > 0 && self.cols > 0)
        var buffer = [Double](count: self.rows * self.cols, repeatedValue: 0.0)
        for var i = 0; i < self.rows; i++ {
            let begin = i * self.cols
            let end = begin + self.cols - 1
            let item = array[i]
            buffer[begin...end] = item[0...(self.rows - 1)]
        }
        self.la = la_matrix_from_double_buffer( buffer,
                                                la_count_t(self.rows),
                                                la_count_t(self.cols),
                                                la_count_t(self.cols),
                                                la_hint_t(LA_NO_HINT),
                                                la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    }
    
    init(array: [Double], rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        self.la = la_matrix_from_double_buffer( array,
                                                la_count_t(self.rows),
                                                la_count_t(self.cols),
                                                la_count_t(self.cols),
                                                la_hint_t(LA_NO_HINT),
                                                la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    }
    
    init(la: la_object_t) {
        self.rows = Int(la_matrix_rows(la))
        self.cols = Int(la_matrix_cols(la))
        self.la = la
    }
    
    public var shape: (Int, Int) {
        return (self.rows, self.cols)
    }
    
    public var flat: [Double] {
        var array = [Double](count: self.rows * self.cols, repeatedValue: 0.0)
        la_matrix_to_double_buffer(&array, la_count_t(self.cols), self.la)
        return array
    }
    
    public var array: [[Double]] {
        let list = self.flat
        var array = [[Double]]()
        for var i = 0; i < self.rows; i++ {
            let begin = i * self.cols
            let end = begin + self.cols - 1
            let item = Array(list[begin...end])
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
        self.rows = rows
        self.cols = cols
        la_release(self.la)
        self.la = la_matrix_from_double_buffer( flat,
                                                la_count_t(self.rows),
                                                la_count_t(self.cols),
                                                la_count_t(self.cols),
                                                la_hint_t(LA_NO_HINT),
                                                la_attribute_t(LA_DEFAULT_ATTRIBUTES))
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
    
    public func inv() -> RMatrix {
        var flat = self.flat
        for var i = 0; i < self.rows * self.cols; i++ {
            let value = flat[i]
            if abs(value) > 1e-50 {
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
    
    //public static func linspace() -> RMatrix {
        
    //}
    
    //public func appendRow(matrix: RMatrix) -> RMatrix {
    
    //}
    
    subscript (row: Int, col: Int) -> Double {
        get {
            let theRow = checkRow(row)
            let theCol = checkRow(col)
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
            let index = col + row * self.rows
            assert(index >= 0 && index < self.cols * self.rows)
            buffer[index] = value
            la_release(self.la)
            self.la = la_matrix_from_double_buffer( buffer,
                                                    la_count_t(self.rows),
                                                    la_count_t(self.cols),
                                                    1,
                                                    la_hint_t(LA_NO_HINT),
                                                    la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        }
    }
    
    subscript (row: Int) -> RMatrix {
        get {
            let theRow = checkRow(row)
            let slice = la_matrix_slice(   self.la,
                                            la_index_t(theRow),
                                            0,
                                            1,
                                            1,
                                            1,
                                            la_count_t(self.cols))
            return RMatrix(la: slice)
        }
    }
    
    public var description: String {
        let array = self.array
        return array.reduce("") {
            (acc, rowVals) in acc + rowVals.reduce("") {
                (ac, colVals) in ac + "\(colVals)"
            } + "\n"
        }
    }
    
    private func checkRow(row: Int) -> Int {
        assert(row >= 0 && row < self.rows)
        if row >= 0 {
            return row
        }
        else {
            return self.rows + row
        }
    }
    
    private func checkCol(col: Int) -> Int {
        assert(col >= 0 && col < self.cols)
        if col >= 0 {
            return col
        }
        else {
            return self.cols + col
        }
    }

}