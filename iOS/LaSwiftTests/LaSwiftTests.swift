//
//  LaSwiftTests.swift
//  LaSwiftTests
//
//  Created by Ikuo Kudo on March,16,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import XCTest
@testable import LaSwift

class LaSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testComplex() {
        let a = Complex(real: 1, imag: -1)
        let b = Complex(real: 2.1, imag: 3)
        let c = a + b
        let cAns = Complex(real: 3.1, imag: 2)
        XCTAssertTrue(c == cAns)
        
        let d = a * b
        let dAns = Complex(real: 2.1 + 3, imag: 3 - 2.1)
        XCTAssertTrue(d == dAns)
        
        let e = a - b
        let eAns = Complex(real: -1.1, imag: -4.0)
        XCTAssertTrue(e == eAns)
        
        let f = -2.0 * b * -3.0
        XCTAssertTrue(f == Complex(real: -4.2 * -3.0, imag: 18))
        
        let g = a * 2.0
        XCTAssertTrue(g == Complex(real: 2, imag: -2))
        
        var h = b.copy()
        h *= 2.0
        XCTAssertTrue(h == Complex(real: 4.2, imag: 6))
        
        h += 3.0
        XCTAssertTrue(h == Complex(real: 7.2, imag: 6))
        
        h -= 1.1
        XCTAssertTrue(h == Complex(real: 6.1, imag: 6))
    }
    
    func testRMatrix() {
        let a:[[Double]] = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 20, 30]]
        let b:[[Double]] = [[-1, -2, -1], [-1, -1, -1], [2, 2, 2], [-10, -10, -10]]
        
        let A = RMatrix(array: a)
        let B = RMatrix(array: b)
        
        let C = A + B
        print(C.description)
        
        let D = A * B
        print(D.description)
        
        let E = A.copy()
        print(E.description)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
