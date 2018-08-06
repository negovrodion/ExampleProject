//
//  CurrenciesListPresenter+InteractorOutput.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - CurrenciesListInteractorOutput
extension CurrenciesListPresenter: CurrenciesListInteractorOutput {
    func didFailedLoadData(error: CurrenciesInteractorError) {
        switch error {
        case .serverError:
            if !showedError {
                view?.showError(type: .canNotUpdate)
                showedError = true
            }
        }
    }
    
    func didLoadCurrencies(with base: CurrencyAbbr, models: [CurrenciesListCurrencyPresenterModel]) {
        guard base == lastSelected.abbr else { return }
        
        var supplementedModels = [lastSelected]
        supplementedModels.append(contentsOf: models)
        
        values = Set(supplementedModels)

        if indexPathAndAbbrMatching.count != values.count {
            indexPathAndAbbrMatching = supplementedModels.map({ $0.abbr })
            
            view?.updateTable()
        } else {
            updateValuesExeptFirst()
        }
    }
    
}
