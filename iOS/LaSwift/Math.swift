//
//  Math.swift
//  LaSwift
//
//  Created by Ikuo Kuod on 25,March,2016
//  Copyright © 2016 Aquaware. All rights reserved.
//

import Darwin
import Accelerate


extension RMatrix {
    
    public func inv() -> RMatrix {
        let array = self.flat
        return RMatrix(array: array, rows: self.rows, cols: self.cols)
    }
}
