//
//  CurrenciesListPresenter.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - CurrenciesListPresenter
final class CurrenciesListPresenter {
    
    // MARK: - Constants
    enum Constants {
        static let startValue     = Decimal(1)
        static let timerIntereval = TimeInterval(1)
        static let startAbbr      = CurrencyAbbr.EUR
    }
    
    // MARK: - Injections
    weak var view: CurrenciesListViewInput?
    var interactor: CurrenciesListInteractorInput!
    
    // MARK: - Properties
    var values = Set<CurrenciesListCurrencyPresenterModel>()
    
    var showedError = false
    
    var lastSelected = CurrenciesListCurrencyPresenterModel(abbr: Constants.startAbbr, ratio: 1,
                                                            value: Constants.startValue)
    
    var timer: Timer?
    
    // MARK: - Functions
    
    func getValue(with abbr: CurrencyAbbr) -> CurrenciesListCurrencyPresenterModel? {
        let result = values.filter({ $0.abbr == abbr }).first
        
        return result
    }
    
    func startUpdatingTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: Constants.timerIntereval, repeats: true,
                                     block: { [weak self] (timer) in
            guard let this = self else { return }
                                        
            this.interactor.loadCurrencies(base: this.lastSelected.abbr)
        })
    }
    
    func recalculateRatios(oldRatio: Decimal) {
        for item in values where item.abbr != lastSelected.abbr {
            item.ratio = item.ratio / oldRatio
        }
    }
}



