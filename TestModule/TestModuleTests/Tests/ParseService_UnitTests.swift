//
//  ParseService_UnitTests.swift
//  TestModuleTests
//
//  Created by Rodion on 27.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

@testable import TestModule
import XCTest

class ParseService_UnitTests: XCTestCase {
    
    func testParseLatestCurrencies() {
        let expectedModelsCount = 32
        let expectedAUDModel    = CurrencyParsedModel(shortName: .AUD, ratio: Decimal(string: "1.581")!)
        
        let parseService = ParseService()
        let json         = ResourceManager(classForCoder: self.classForCoder).getLatestCurrenciesFromResources()
        
        guard let models = parseService.parseLatestCurrencies(withBase: .EUR, data: json),
            models.count == expectedModelsCount, models[0] == expectedAUDModel else {
            XCTFail("Was not able to parse json.")
            return
        }
  
    }
    
}
