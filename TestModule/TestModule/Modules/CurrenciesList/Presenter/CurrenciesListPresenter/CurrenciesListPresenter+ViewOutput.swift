//
//  CurrenciesListPresenter+ViewOutput.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - CurrenciesListViewOutput
extension CurrenciesListPresenter: CurrenciesListViewOutput {
    
    func viewDidLoad() {
        view?.setupView()
        
        interactor.loadCurrencies(base: lastSelected.abbr)
        startUpdatingTimer()
    }
    
    func didSelectCell(with abbr: CurrencyAbbr) {
        guard let value = getValue(with: abbr) else { return }
        
        let oldRatio              = value.ratio
        let prevLastSelectedValue = lastSelected.value
        
        lastSelected       = value
        lastSelected.value = lastSelected.ratio * prevLastSelectedValue
        lastSelected.ratio = 1
        
        recalculateRatios(oldRatio: oldRatio)
        
        updateTable()
    }
    
    func didChange(value: String) {
        lastSelected.value = Decimal(string: value) ?? 0
        
        updateTable()
    }
    
    // MARK: - Private functions
    private func updateTable() {
        let cellModels = values.map { (model) -> CurrenciesListViewCellModel in
            let curVal    = model.ratio * lastSelected.value
            let cellModel = CurrenciesListViewCellModel(abbr: model.abbr, value: curVal.toMoneyString)
            
            return cellModel
        }
        
        view?.updateTable(with: cellModels)
    }
}
