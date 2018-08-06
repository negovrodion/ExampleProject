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
        
        presenter.didFailedLoadData(error: .serverError)
        
        XCTAssertTrue(viewMock.state == .showError)
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
        
        guard let model = presenter.getValue(with: .AUD), model.abbr == .AUD else {
            XCTFail("Has no model, but should be.")
            return
        }
    }
    
    func testDidSelectCell() {
        let models = [
            CurrenciesListCurrencyPresenterModel(abbr: .AUD, ratio: 2),
            CurrenciesListCurrencyPresenterModel(abbr: .BGN, ratio: 4),
            CurrenciesListCurrencyPresenterModel(abbr: .BRL, ratio: 8)
        ]
        
        let expectedModels = [
            CurrenciesListCurrencyPresenterModel(abbr: .BRL, ratio: 1),
            CurrenciesListCurrencyPresenterModel(abbr: CurrenciesListPresenter.Constants.startAbbr, ratio: 0.125),
            CurrenciesListCurrencyPresenterModel(abbr: .AUD, ratio: 0.25),
            CurrenciesListCurrencyPresenterModel(abbr: .BGN, ratio: 0.5)
        ]
        
        let presenter = CurrenciesListPresenter()
        presenter.didLoadCurrencies(with: .EUR, models: models)
        
        presenter.didSelectCell(with: .BRL)
        
        XCTAssertTrue(presenter.lastSelected.abbr == .BRL)
        for item in expectedModels {
            XCTAssertTrue(item.ratio == presenter.values.filter({$0.abbr == item.abbr}).first?.ratio)
        }
    }
    
    func testDidChange() {
        let expectedValue   = "1.1"
        let expectedDecimal = Decimal(string: expectedValue)!
        
        let presenter = CurrenciesListPresenter()
        presenter.didChange(value: expectedValue)
        
        XCTAssertTrue(presenter.lastSelected.value == expectedDecimal)
    
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
    
    func updateTable(with models: [CurrenciesListViewCellModel]) {
        state = .updateTable
    }
    
}
