//
//  Complex.swift
//  LaSwift
//
//  Created by Ikuo Kudo on March,17,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Accelerate


public func + (left: Complex, right: Complex) -> Complex {
    if left.isImagPerfectZero && left.isRealPerfectZero && right.isImagPerfectZero && right.isRealPerfectZero {
        return Complex()
    }
    else if left.isRealPerfectZero && right.isRealPerfectZero {
        if left.isImagPerfectZero {
            return Complex(real: right.real)
        }
        else if right.isImagPerfectZero {
            return Complex(real: left.real)
        }
        else {
            return Complex(real: left.real + right.real)
        }
    }
    else if left.isImagPerfectZero && right.isImagPerfectZero {
        if left.isRealPerfectZero {
            return Complex(imag: right.imag)
        }
        else if right.isRealPerfectZero {
            return Complex(imag: left.imag)
        }
        else {
            return Complex(imag: left.imag + right.imag)
        }
    }
    else {
        return Complex(real: left.real + right.real, imag: left.imag + right.imag)
    }
}

public func - (left: Complex, right: Complex) -> Complex {
    if left.isImagPerfectZero && left.isRealPerfectZero && right.isImagPerfectZero && right.isRealPerfectZero {
        return Complex()
    }
    else if left.isRealPerfectZero && right.isRealPerfectZero {
        if left.isImagPerfectZero {
            return Complex(real: -right.real)
        }
        else if right.isImagPerfectZero {
            return Complex(real: left.real)
        }
        else {
            return Complex(real: left.real - right.real)
        }
    }
    else if left.isImagPerfectZero && right.isImagPerfectZero {
        if left.isRealPerfectZero {
            return Complex(imag: -right.imag)
        }
        else if right.isRealPerfectZero {
            return Complex(imag: left.imag)
        }
        else {
            return Complex(imag: left.imag - right.imag)
        }
    }
    else {
        return Complex(real: left.real - right.real, imag: left.imag - right.imag)
    }
}

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
