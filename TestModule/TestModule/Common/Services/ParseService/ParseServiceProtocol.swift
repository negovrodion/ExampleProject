//
//  ParseServiceProtocol.swift
//  TestModule
//
//  Created by Rodion on 20.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation


// MARK: - ParceServiceProtocol
protocol ParseServiceProtocol {
    func parseLatestCurrencies(withBase: CurrencyAbbr, data: Any) -> [CurrencyParsedModel]?
}
