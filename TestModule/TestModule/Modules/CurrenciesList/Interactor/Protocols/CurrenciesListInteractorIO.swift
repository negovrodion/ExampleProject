//
//  CurrenciesListInteractorIO.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - CurrenciesListInteractorInput
protocol CurrenciesListInteractorInput {
    func loadCurrencies(base: CurrencyAbbr)
}

// MARK: - CurrenciesListInteractorOutput
protocol CurrenciesListInteractorOutput: class {
    func didLoadCurrencies(with base: CurrencyAbbr, models: [CurrenciesListCurrencyPresenterModel])
    func didFailedLoadData(error: CurrenciesInteractorError)
}
