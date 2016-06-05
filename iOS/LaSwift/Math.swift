//
//  Math.swift
//  LaSwift
//
//  Created by Ikuo Kuod on 25,March,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Darwin
import Accelerate


public func toComplex(real: [Double], imag: [Double]) -> [__CLPK_doublecomplex] {
    assert(real.count == imag.count)
    var array = [__CLPK_doublecomplex]( count: real.count,
        repeatedValue: __CLPK_doublecomplex(r: 0.0, i: 0.0))
    
    for i in 0 ..< array.count {
        array[i].r = real[i]
        array[i].i = imag[i]
    }
    
    return array
}

public func toComplex(real: [Double]) -> [__CLPK_doublecomplex] {
    var array = [__CLPK_doublecomplex]( count: real.count,
        repeatedValue: __CLPK_doublecomplex(r: 0.0, i: 0.0))
    
    for i in 0 ..< array.count {
        array[i].r = real[i]
    }
    
    return array
}

public func toComplex2(imag: [Double]) -> [__CLPK_doublecomplex] {
    var array = [__CLPK_doublecomplex]( count: imag.count,
        repeatedValue: __CLPK_doublecomplex(r: 0.0, i: 0.0))
    
    for i in 0 ..< array.count {
        array[i].i = imag[i]
    }
    
    return array
}


public func splitFromComplex(complex: [__CLPK_doublecomplex]) -> ([Double], [Double]) {
    var real = [Double]( count: complex.count, repeatedValue: 0.0)
    var imag = [Double]( count: complex.count, repeatedValue: 0.0)
    for i in 0 ..< complex.count / 2 {
        let c = complex[i]
        real[i] = Double(c.r)
        imag[i] = Double(c.i)
    }
    return (real, imag)
}

extension RMatrix {
    
    public func inv() -> RMatrix {
        
        var m = __CLPK_integer(self.rows)
        var n = __CLPK_integer(self.cols)
        let flat = self.flat
        let a = UnsafeMutablePointer<__CLPK_doublereal>(flat)
        var lda = n
        var ipiv = [__CLPK_integer](count: self.rows * self.cols, repeatedValue: 0)
        var info = __CLPK_integer(0)
        dgetrf_(&m, &n, a, &lda, &ipiv, &info)
        
        assert(info == 0)
        return RMatrix(array: flat, rows: self.rows, cols: self.cols)
    }
    
    /* Solution of Linear Equations */
    public func gesv() -> RMatrix {
        
        // A * x = b
        //
        // A: matrix(n x n)
        // B: vector(1 x n) ... solution
        //
        // (in)     int     n:   equation number
        // (in)     int     nrhs:  right hand side row size
        // (in/out) double  a    lda x n matrix
        // (in)     int     lda: matrix A column size (== N)
        // (out)    int     ipiv: n vector
        // (in/out) doulbe  b:
        // (in)     int     ldb: matrix B column size (== N)
        // (out)    int     info:
        
        assert(self.rows == self.cols && self.rows > 0)
        
        var n = __CLPK_integer(self.rows)
        var nrhs = n
        let buffer = self.flat
        let a = UnsafeMutablePointer<__CLPK_doublereal>(buffer)
        var lda = n
        var ipiv = [__CLPK_integer](count: self.rows, repeatedValue: 0)
        let array = [Double](count: self.rows, repeatedValue: 0.0)
        let b = UnsafeMutablePointer<__CLPK_doublereal>(array)
        var ldb = n
        var info = __CLPK_integer(0)
        dgesv_(&n, &nrhs, a, &lda, &ipiv, b, &ldb, &info)
        
        assert(info == 0)
        return RMatrix(array: array, rows: 1, cols: self.cols)
    }
    
    public func eigenValue() -> Matrix {
        var jobvl = Int8(78) // 'N' or 'V'
        var jobvr = Int8(78) // "V"
        var n = __CLPK_integer(self.rows)
        let aArray = self.flat
        let a = UnsafeMutablePointer<__CLPK_doublereal>(aArray)
        var lda = n
        let bArray = [Double](count: self.rows, repeatedValue: 0.0)
        let b = UnsafeMutablePointer<__CLPK_doublereal>(bArray)
        var ldb = n
        let alpharArray = [Double](count: self.rows, repeatedValue: 0.0)
        let alphar = UnsafeMutablePointer<__CLPK_doublereal>(alpharArray)
        let alphaiArray = [Double](count: self.rows, repeatedValue: 0.0)
        let alphai = UnsafeMutablePointer<__CLPK_doublereal>(alphaiArray)
        let betaArray = [Double](count: self.rows, repeatedValue: 0.0)
        let beta = UnsafeMutablePointer<__CLPK_doublereal>(betaArray)
        let vlArray = [Double](count: self.rows, repeatedValue: 0.0)
        let vl = UnsafeMutablePointer<__CLPK_doublereal>(vlArray)
        var ldvl = n
        let vrArray = [Double](count: self.rows, repeatedValue: 0.0)
        let vr = UnsafeMutablePointer<__CLPK_doublereal>(vrArray)
        var ldvr = n
        let workArray = [Double](count: self.rows, repeatedValue: 0.0)
        let work = UnsafeMutablePointer<__CLPK_doublereal>(workArray)
        var lwork = n
        var info = __CLPK_integer(0)

        dggev_(&jobvl, &jobvr, &n, a, &lda, b, &ldb, alphar, alphai, beta, vl, &ldvl, vr, &ldvr, work, &lwork, &info)
        assert(info == 0)
        
        let eigenValue = Matrix(real: alpharArray, imag: alphaiArray, rows: self.rows, cols: 1)
        let bMat = RMatrix(array: betaArray, rows: self.rows, cols: 1)
        
        return eigenValue / bMat
    }
}

extension Matrix {
        
        public func gesv() -> Matrix {
        
            // A * x = b
            //
            // A: matrix(n x n)
            // B: vector(1 x n) ... solution
            //
            // (in)     int     n:   equation number
            // (in)     int     nrhs:  right hand side row size
            // (in/out) double complex  a    lda x n matrix
            // (in)     int     lda: matrix A column size (== N)
            // (out)    int     ipiv: n vector
            // (in/out) doulbe complex b:
            // (in)     int     ldb: matrix B column size (== N)
            // (out)    int     info:
            
            assert(self.rows == self.cols && self.rows > 0)
            
            var n = __CLPK_integer(self.rows)
            var nrhs = n
            var buffer: [__CLPK_doublecomplex]!
            
            if !self.isReal && !self.isImag {
                return Matrix()
            }
            else if !self.isReal {
                buffer = toComplex2(self.imag.flat)
            }
            else if !self.isImag {
                buffer = toComplex(self.real.flat)
            }
            else {
                buffer = toComplex(self.real.flat, imag: self.imag.flat)
            }
            
            let a = UnsafeMutablePointer<__CLPK_doublecomplex>(buffer)
            var lda = n
            var ipiv = [__CLPK_integer](count: 0, repeatedValue: 0)
            let array = [__CLPK_doublecomplex](count: self.rows, repeatedValue: __CLPK_doublecomplex(r: 0.0, i: 0.0))
            let b = UnsafeMutablePointer<__CLPK_doublecomplex>(array)
            var ldb = n
            var info = __CLPK_integer(0)
            zgesv_(&n, &nrhs, a, &lda, &ipiv, b, &ldb, &info)
            
            assert(info == 0)
            let (real, imag) = splitFromComplex(array)
            
            return Matrix(real: real, imag: imag, rows: 1, cols: real.count)
        }
}
