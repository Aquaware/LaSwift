//
//  Fft.swift
//  LaSwift
//
//  Created by Ikuo Kudo on 25,March,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Accelerate

public class Fft {

    init () {
        
    }
    
    public func fft(signal: Matrix) -> Matrix {
        
        let length = signal.cols
        let setup = vDSP_create_fftsetup(vDSP_Length(length), Int32(kFFTRadix2))

        var real = [Double](count: length, repeatedValue: 0.0)
        var imag = [Double](count: length, repeatedValue: 0.0)
        var complex = DSPDoubleSplitComplex(realp: &real, imagp: &imag)
        
        let input = UnsafePointer<DSPDoubleComplex>(signal.real.flat)
        vDSP_ctozD(input, 2, &complex, 1, vDSP_Length(length / 2))
        vDSP_fft_zripD (setup, &complex, 1, vDSP_Length(length), Int32(FFT_FORWARD))
        vDSP_destroy_fftsetup(setup)
        
        return Matrix(real: real, imag: imag, rows: 1, cols: length)
    }
    
    public func ifft(input: Matrix, fftSize: Int) -> Matrix {
        let length = input.cols
        let setup = vDSP_create_fftsetup(vDSP_Length(fftSize), Int32(kFFTRadix2))
        
        let real = UnsafeMutablePointer<Double>(input.real.flat)
        let imag = UnsafeMutablePointer<Double>(input.imag.flat)
        var complex = DSPDoubleSplitComplex(realp: real, imagp: imag)
        
        vDSP_fft_zripD(setup, &complex, 1, vDSP_Length(fftSize), Int32(FFT_INVERSE))

        let out = [Double](count: fftSize, repeatedValue: 0.0)
        let outp = UnsafeMutablePointer<Double>(out)
        let outc = UnsafeMutablePointer<DSPDoubleComplex>(outp)
        vDSP_ztocD(&complex, 1, outc, 2, vDSP_Length(fftSize / 2));
        
        return Matrix(real: out, rows: 1, cols: length)
    }
    
    public static func hanningWindow(length: Int) -> Matrix {
        var array = [Double](count: length, repeatedValue: 0.0)
        vDSP_hann_windowD(&array, vDSP_Length(length), Int32(0))
        return Matrix(real: array, rows: 1, cols: length)
    }
}