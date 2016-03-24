//
//  Complex.swift
//  LaSwift
//
//  Created by Ikuo Kudo on 17,March,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Accelerate

public class Complex {
    var real_: Double = 0.0
    var imag_: Double = 0.0
    var isReal_ = true
    var isImag_ = true
    
    init() {
    }
    
    init(real: Double) {
        self.real_ = real
        self.isReal_ = false
    }
    
    init(imag: Double) {
        self.imag_ = imag
        self.isImag_ = false
    }
    
    init(real: Double, imag: Double) {
        self.real_ = real
        self.imag_ = imag
        self.isReal_ = false
        self.isImag_ = false
    }
    
    public static var unitImag: Complex {
        return Complex(imag: 1.0)
    }
    
    public var real: Double {
        return self.real_
    }
    
    public var imag: Double {
        return self.imag_
    }
    
    public var isReal: Bool {
        return self.isReal_
    }
    
    public var isImag: Bool {
        return self.isImag_
    }
    
    public var description: String {
        var str = "\(self.real_) "
        if !isImag_ {
            if self.imag_ >= 0 {
                str += "+ \(self.imag_)j \n"
            }
            else {
                str += "- \(self.imag_)j \n"
            }
        }
        return str
    }
    
}
