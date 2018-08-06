//
//  CurrenciesListCurrencyModel.swift
//  TestModule
//
//  Created by Rodion on 21.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - CurrenciesListCurrencyPresenterModel
final class CurrenciesListCurrencyPresenterModel: Hashable {
    var abbr: CurrencyAbbr
    var ratio: Decimal
    var value: Decimal = 1
    
    init(abbr: CurrencyAbbr, ratio: Decimal) {
        self.abbr  = abbr
        self.ratio = ratio
    }
    
    init(abbr: CurrencyAbbr, ratio: Decimal, value: Decimal) {
        self.abbr  = abbr
        self.ratio = ratio
        self.value = value
    }
    
    // MARK: - Hashable
    var hashValue: Int {
        return abbr.hashValue
    }
    
    // MARK: - Equatable
    static func == (lhs: CurrenciesListCurrencyPresenterModel, rhs: CurrenciesListCurrencyPresenterModel) -> Bool {
        return lhs.abbr == rhs.abbr
    }
}

