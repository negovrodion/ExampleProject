//
//  Decimal.swift
//  TestModule
//
//  Created by Rodion on 22.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

extension Decimal {
    var toMoneyString: String {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .decimal
        formatter.maximumFractionDigits = 2
        
        let str    = formatter.string(from: self as NSDecimalNumber) ?? ""
        var result = str == "0" ? "" : str
        result     = result.replacingOccurrences(of: ".", with: ",")
        
        return result
    }
}
