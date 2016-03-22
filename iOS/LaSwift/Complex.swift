//
//  Complex.swift
//  LaSwift
//
//  Created by Ikuo Kudo on 17,March,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Accelerate

public class Complex {
    var real: Double = 0.0
    var imag: Double = 0.0
    var isRealZero = true
    var isImagZero = true
    
    init() {
    }
    
    init(real: Double) {
        self.real = real
        self.isRealZero = false
    }
    
    init(imag: Double) {
        self.imag = imag
        self.isImagZero = false
    }
    
    init(real: Double, imag: Double) {
        self.real = real
        self.imag = imag
        self.isRealZero = false
        self.isImagZero = false
    }
    
    public static var unitImag: Complex {
        return Complex(imag: 1.0)
    }
    
    public var description: String {
        var str = "\(self.real) "
        if !isImagZero {
            if self.imag >= 0 {
                str += "+ \(self.imag)j \n"
            }
            else {
                str += "- \(self.imag)j \n"
            }
        }
        return str
    }
    
}
