//
//  CurrenciesInteractor_UnitTests.swift
//  TestModuleTests
//
//  Created by Rodion on 27.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

@testable import TestModule
import XCTest

class CurrenciesInteractor_UnitTests: XCTestCase {
    
    func testLoadCurrencies() {
        let parsedModels = [
            CurrencyParsedModel(shortName: .AUD, ratio: 1.1),
            CurrencyParsedModel(shortName: .BGN, ratio: 1.2)
        ]
        
        let expectedModels = [
            CurrenciesListCurrencyPresenterModel(abbr: .AUD, ratio: 1.1),
            CurrenciesListCurrencyPresenterModel(abbr: .BGN, ratio: 1.2)
        ]
        
        let promise = expectation(description: "forDelegateCall")
    
        let currenciesListAPIService = APIServiceMock(data: parsedModels)
        let interactor               = CurrenciesListInteractor(apiService: currenciesListAPIService)
        let presenterMock            = CurrenciesPresenterMock(promise: promise)
        interactor.output            = presenterMock
        
        presenterMock.models = expectedModels
        
        interactor.loadCurrencies(base: .BRL)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}

// MARK: - CurrenciesPresenterMock
fileprivate class CurrenciesPresenterMock: CurrenciesListInteractorOutput {
    
    // MARK: - Properties
    var models: [CurrenciesListCurrencyPresenterModel]?
    
    private let promise: XCTestExpectation
    
    // MARK: - Initialization
    init(promise: XCTestExpectation) {
        self.promise = promise
    }
    
    // MARK: - CurrenciesListInteractorOutput
    func didLoadCurrencies(with base: CurrencyAbbr, models: [CurrenciesListCurrencyPresenterModel]) {
        promise.fulfill()
        
        guard let oModels = self.models, models.count == oModels.count else {
            XCTFail("Was not able to load models.")
            return
        }
        
        for (item, value) in models.enumerated() {
            guard value.abbr == oModels[item].abbr || value.ratio == oModels[item].ratio ||
                value.value == oModels[item].value else {
                    
                XCTFail("Got unexpected data.")
                return
            }
        }
    }
    
    func didFailedLoadData(error: CurrenciesInteractorError) {
        XCTFail("Was not able to load models.")
    }
    
}
