//
//  CurrenciesListInteractor.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - CurrenciesListInteractor

final class CurrenciesListInteractor {
    // MARK: - Injections
    weak var output: CurrenciesListInteractorOutput?
    var apiService: CurrenciesListAPIServiceProtocol!
    
    init(apiService: CurrenciesListAPIServiceProtocol) {
        self.apiService = apiService
    }
}

// MARK: - CurrenciesInteractorInput
extension CurrenciesListInteractor: CurrenciesListInteractorInput {
    func loadCurrencies(base: CurrencyAbbr) {
        apiService.loadCurrencies(base: base) { [output] result in
            switch result {
            case .success(let models):
                let currenciesListCurrencyPresenterModels = models.map({
                    CurrenciesListCurrencyPresenterModel(abbr: $0.shortName, ratio: $0.ratio)
                })
                
                output?.didLoadCurrencies(with: base, models: currenciesListCurrencyPresenterModels)
            case .fail(let error):
                switch error {
                case .couldNotParse, .serverError:
                    output?.didFailedLoadData(error: .serverError)
                }
            }
        }
    }
}
