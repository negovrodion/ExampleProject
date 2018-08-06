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
    var lastSelectedValue: Decimal {
        return lastSelected.value
    }
    
    var lastSelectedAbbr: CurrencyAbbr {
        return lastSelected.abbr
    }
    
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
    }
    
    func didChange(value: String) {
        lastSelected.value = Decimal(string: value) ?? 0
    }
}
