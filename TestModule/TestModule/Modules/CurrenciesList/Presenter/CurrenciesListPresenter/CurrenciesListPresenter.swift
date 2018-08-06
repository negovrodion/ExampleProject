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
    var indexPathAndAbbrMatching = [CurrencyAbbr]()
    var values                   = Set<CurrenciesListCurrencyPresenterModel>()
    
    var showedError = false
    
    var lastSelected = CurrenciesListCurrencyPresenterModel(abbr: Constants.startAbbr, ratio: 1,
                                                            value: Constants.startValue)
    
    var timer: Timer?
    
    // MARK: - Functions
    func moveToTop(with: IndexPath) {
        guard indexPathAndAbbrMatching.count > with.row, with.row > 0 else { return }
        let topModel = indexPathAndAbbrMatching[with.row]
        

        for i in (1...with.row).reversed() {
            indexPathAndAbbrMatching[i] = indexPathAndAbbrMatching[i - 1]
        }
        
        indexPathAndAbbrMatching[0] = topModel
    }
    
    func getValue(byIndexPath: IndexPath) -> CurrenciesListCurrencyPresenterModel? {
        guard indexPathAndAbbrMatching.count > byIndexPath.row else { return nil }
        
        let abbr   = indexPathAndAbbrMatching[byIndexPath.row]
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
    
    func updateValuesExeptFirst() {
        let updatedValues = indexPathAndAbbrMatching.compactMap { (currencyAbbr) -> String? in
            guard currencyAbbr != lastSelected.abbr else {
                return lastSelected.value.toMoneyString
            }
            
            guard let ratio = values.filter({ $0.abbr == currencyAbbr }).first?.ratio else {
                return ""
            }
            
            let curVal = ratio * lastSelected.value
            
            return curVal.toMoneyString
        }
        
        view?.updateValuesExeptFirst(values: updatedValues)
    }
    
    func recalculateRatios(oldRatio: Decimal) {
        for item in values where item.abbr != lastSelected.abbr {
            item.ratio = item.ratio / oldRatio
        }
    }
}



