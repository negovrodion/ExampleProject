//
//  ParseService.swift
//  TestModule
//
//  Created by Rodion on 20.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation


// MARK: - ParceService
final class ParseService {
    fileprivate enum Constants {
        static let rates = "rates"
    }
}

// MARK: - ParseServiceProtocol
extension ParseService: ParseServiceProtocol {
    func parseLatestCurrencies(withBase: CurrencyAbbr, data: Any) -> [CurrencyParsedModel]? {
        let allCasesExceptOne = CurrencyAbbr.allCases(except: withBase)
        
        guard let json = data as? [String : Any], let rates = json[Constants.rates] as? [String : NSNumber],
            rates.count == allCasesExceptOne.count else {
                return nil
        }
        
        var currencyParsedModels = [CurrencyParsedModel]()
        for item in allCasesExceptOne {
            guard let iRatio = rates[item] else {
                return nil
            }

            let shortName           = CurrencyAbbr(rawValue: item)!
            let currencyParsedModel = CurrencyParsedModel(shortName: shortName, ratio: iRatio.decimalValue)

            currencyParsedModels.append(currencyParsedModel)
        }
        
        return currencyParsedModels
    }
}
