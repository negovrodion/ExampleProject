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
        
        var cellModels = [CurrenciesListViewCellModel]()
        
        for model in supplementedModels {
            guard let val = getValue(with: model.abbr) else {
                view?.showError(type: .dataInconsistency)
                
                return
            }

            let curVal    = val.ratio * lastSelected.value
            let cellModel = CurrenciesListViewCellModel(abbr: val.abbr, value: curVal.toMoneyString)
            
            cellModels.append(cellModel)
        }
        
        view?.updateTable(with: cellModels)

    }
    
}
