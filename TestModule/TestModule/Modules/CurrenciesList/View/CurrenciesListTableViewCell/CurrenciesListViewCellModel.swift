//
//  CurrenciesListViewCellModel.swift
//  TestModule
//
//  Created by Rodion on 21.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - CurrenciesListViewCellModel
struct CurrenciesListViewCellModel {
    var abbr: CurrencyAbbr
    var value: String
    
    var curName: String {
        return abbr.rawValue
    }
}
