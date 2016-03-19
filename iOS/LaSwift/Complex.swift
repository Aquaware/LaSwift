//
//  Complex.swift
//  LaSwift
//
//  Created by Ikuo Kudo on March,17,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Accelerate

public class Complex {
    var real: Double = 0.0
    var imag: Double = 0.0
    var isRealPerfectZero = true
    var isImagPerfectZero = true
    
    init() {
    }
    
    init(real: Double) {
        self.real = real
        self.isRealPerfectZero = false
    }
    
    init(imag: Double) {
        self.imag = imag
        self.isImagPerfectZero = false
    }
    
    init(real: Double, imag: Double) {
        self.real = real
        self.imag = imag
        self.isRealPerfectZero = false
        self.isImagPerfectZero = false
    }
    
    public static var unitImag: Complex {
        return Complex(imag: 1.0)
    }
    
}
