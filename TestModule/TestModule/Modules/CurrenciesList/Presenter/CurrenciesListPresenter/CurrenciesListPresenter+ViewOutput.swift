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
    
    func numberOfRowsForTable() -> Int {
        return values.count
    }
    
    func didSelectCell(with indexPath: IndexPath) {
        guard let value = getValue(byIndexPath: indexPath) else { return }
        
        let oldRatio              = value.ratio
        let prevLastSelectedValue = lastSelected.value
        
        lastSelected       = value
        lastSelected.value = lastSelected.ratio * prevLastSelectedValue
        lastSelected.ratio = 1
        
        moveToTop(with: indexPath)
        recalculateRatios(oldRatio: oldRatio)
        updateValuesExeptFirst()
        view?.updateFirstValue(value: lastSelected.value.toMoneyString)
    }
    
    func didChange(value: String) {
        lastSelected.value = Decimal(string: value) ?? 0
        
        updateValuesExeptFirst()
    }
    
    func cellFor(indexPath: IndexPath) -> CurrenciesListViewCellModel? {
        guard let val = getValue(byIndexPath: indexPath) else { return nil }
        
        let curName = val.abbr.rawValue
        let curVal  = val.ratio * lastSelected.value
        
        let model = CurrenciesListViewCellModel(curName: curName, value: curVal.toMoneyString)
        
        return model
    }
}
