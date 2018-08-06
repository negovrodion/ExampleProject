//
//  CurrenciesListAPIServiceProtocol.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - CurrenciesListAPIServiceProtocol
protocol CurrenciesListAPIServiceProtocol {
    func loadCurrencies(base: CurrencyAbbr,
                        complition: @escaping ((APIService.RequestResult<[CurrencyParsedModel]>)) -> ())
}
