//
//  CurrenciesPresenter_UnitTests.swift
//  TestModuleTests
//
//  Created by Rodion on 27.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

@testable import TestModule
import XCTest

class CurrenciesPresenter_UnitTests: XCTestCase {
    
    func testDidLoadCurrencies() {
        var expectedModels = [
            CurrenciesListCurrencyPresenterModel(abbr: .AUD, ratio: 1.1),
            CurrenciesListCurrencyPresenterModel(abbr: .BGN, ratio: 1.2),
            CurrenciesListCurrencyPresenterModel(abbr: .BRL, ratio: 1.3)
        ]
        
        let presenter  = CurrenciesListPresenter()
        let viewMock   = CurrenciesViewMock()
        presenter.view = viewMock
        
        presenter.didLoadCurrencies(with: .EUR, models: expectedModels)
        
        XCTAssertTrue(viewMock.state == .updateTable)
        XCTAssertTrue(presenter.values.count == expectedModels.count + 1)
        
        viewMock.state = .none
        expectedModels.remove(at: 2)
        
        presenter.didLoadCurrencies(with: .EUR, models: expectedModels)
        
        XCTAssertTrue(viewMock.state == .updateTable)
        XCTAssertTrue(presenter.values.count == expectedModels.count + 1)
        
        viewMock.state = .none
        
        presenter.didLoadCurrencies(with: .EUR, models: expectedModels)
        
        XCTAssertTrue(viewMock.state == .updateValuesExeptFirst)
        XCTAssertTrue(presenter.values.count == expectedModels.count + 1)
        
        viewMock.state = .none
        
        presenter.didLoadCurrencies(with: .EUR, models: [CurrenciesListCurrencyPresenterModel]())
        
        XCTAssertTrue(viewMock.state == .showError)
        
        viewMock.state = .none
        
        presenter.didLoadCurrencies(with: .EUR, models: [CurrenciesListCurrencyPresenterModel]())
        
        XCTAssertTrue(viewMock.state == .none)
    }
    
    func testMoveToTop() {
        let models = [
            CurrenciesListCurrencyPresenterModel(abbr: .AUD, ratio: 1.1),
            CurrenciesListCurrencyPresenterModel(abbr: .BGN, ratio: 1.2),
            CurrenciesListCurrencyPresenterModel(abbr: .BRL, ratio: 1.3)
        ]
        
        var expectedModels = [CurrenciesListCurrencyPresenterModel(abbr: CurrenciesListPresenter.Constants.startAbbr,
                                                                   ratio: 1,
                                                                   value: CurrenciesListPresenter.Constants.startValue)]
        expectedModels.append(contentsOf: models)
        
        let presenter = CurrenciesListPresenter()
        presenter.didLoadCurrencies(with: .EUR, models: models)
        
        presenter.moveToTop(with: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(isEqualModelArrays(expected: expectedModels, test: presenter.indexPathAndAbbrMatching))

        expectedModels = [expectedModels[3], expectedModels[0], expectedModels[1], expectedModels[2]]
        
        presenter.moveToTop(with: IndexPath(row: 3, section: 0))
        
        XCTAssertTrue(isEqualModelArrays(expected: expectedModels, test: presenter.indexPathAndAbbrMatching))
        
        presenter.moveToTop(with: IndexPath(row: 4, section: 0))
        
        XCTAssertTrue(isEqualModelArrays(expected: expectedModels, test: presenter.indexPathAndAbbrMatching))
        
    }
    
    func testGetValue() {
        let models = [
            CurrenciesListCurrencyPresenterModel(abbr: .AUD, ratio: 1.1),
            CurrenciesListCurrencyPresenterModel(abbr: .BGN, ratio: 1.2),
            CurrenciesListCurrencyPresenterModel(abbr: .BRL, ratio: 1.3)
        ]
        
        var expectedModels = [CurrenciesListCurrencyPresenterModel(abbr: CurrenciesListPresenter.Constants.startAbbr,
                                                                   ratio: 1,
                                                                   value: CurrenciesListPresenter.Constants.startValue)]
        expectedModels.append(contentsOf: models)
        
        let presenter = CurrenciesListPresenter()
        presenter.didLoadCurrencies(with: .EUR, models: models)
        
        guard let model = presenter.getValue(byIndexPath: IndexPath(row: 1, section: 0)), model.abbr == .AUD else {
            XCTFail("Has no model, but should.")
            return
        }
    }
    
    func testUpdateValuesExeptFirst() {
        let models = [
            CurrenciesListCurrencyPresenterModel(abbr: .AUD, ratio: 1.1),
            CurrenciesListCurrencyPresenterModel(abbr: .BGN, ratio: 1.2),
            CurrenciesListCurrencyPresenterModel(abbr: .BRL, ratio: 1.3)
        ]
        
        let expectedValues = [
            "1",
            "1,1",
            "1,2",
            "1,3"
        ]
        
        let presenter  = CurrenciesListPresenter()
        let viewMock   = CurrenciesViewMock()
        presenter.view = viewMock
        presenter.didLoadCurrencies(with: .EUR, models: models)
        
        presenter.updateValuesExeptFirst()
        
        XCTAssertTrue((viewMock.values ?? []) == expectedValues)
    }
    
    // MARK: - Private functions
    private func isEqualModelArrays(expected: [CurrenciesListCurrencyPresenterModel], test: [CurrencyAbbr]) -> Bool {
        let tExpected = expected.map({ $0.abbr })
        
        return tExpected == test
    }
    
}

// MARK: - CurrenciesPresenterMock
fileprivate class CurrenciesViewMock: CurrenciesListViewInput {
    
    // MARK: - State
    enum State {
        case none
        case updateTable
        case updateValuesExeptFirst
        case showError
    }
    
    // MARK: - Properties
    var state = State.none
    var values: [String]?

    // MARK: - CurrenciesListViewInput
    func setupView() {
        
    }
    
    func showError(type: CurrenciesListViewError) {
        state = .showError
    }
    
    func updateTable() {
        state = .updateTable
    }
    
    func updateValuesExeptFirst(values: [String]) {
        state = .updateValuesExeptFirst
        
        self.values = values
    }
    
    func updateFirstValue(value: String) {
        
    }
    
}
