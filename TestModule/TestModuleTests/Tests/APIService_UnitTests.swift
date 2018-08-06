//
//  APIService_UnitTests.swift
//  TestModuleTests
//
//  Created by Rodion on 27.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

@testable import TestModule
import XCTest

class APIService_UnitTests: XCTestCase {

    func testLoadCurrenciesMocksSuccessCase() {
        let networkServiceMock = NetworkServiceMock(setting: .success(""))
        let parseServiceMock   = ParseServiceMock(setting: .success, data: [CurrencyParsedModel]())
        
        let apiService = APIService(networkService: networkServiceMock, parseService: parseServiceMock)
        
        let promise = expectation(description: "forLoadCurrencies")
        
        apiService.loadCurrencies(base: .EUR) { (results) in
            promise.fulfill()
            
            switch results {
            case .success(_):
                break
            case .fail(_):
                XCTFail("Was not able to load models.")
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadCurrenciesMocksFailCase() {
        let networkServiceMock = NetworkServiceMock(setting: .fail(""))
        let parseServiceMock   = ParseServiceMock(setting: .success, data: [CurrencyParsedModel]())
        
        let apiService = APIService(networkService: networkServiceMock, parseService: parseServiceMock)
        
        let promise = expectation(description: "forLoadCurrencies")
        
        apiService.loadCurrencies(base: .EUR) { (results) in
            promise.fulfill()
            
            switch results {
            case .success(_):
                XCTFail("Was able to load models, but should not.")
            case .fail(_):
                break
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadCurrenciesMocksSuccessAndNilCase() {
        let networkServiceMock = NetworkServiceMock(setting: .fail(""))
        let parseServiceMock   = ParseServiceMock(setting: .success, data: [CurrencyParsedModel]())
        
        let apiService = APIService(networkService: networkServiceMock, parseService: parseServiceMock)
        
        let promise = expectation(description: "forLoadCurrencies")
        
        apiService.loadCurrencies(base: .EUR) { (results) in
            promise.fulfill()
            
            switch results {
            case .success(_):
                XCTFail("Was able to load models, but should not.")
            case .fail(_):
                break
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadCurrenciesMocksFailParseCase() {
        let networkServiceMock = NetworkServiceMock(setting: .success(""))
        let parseServiceMock   = ParseServiceMock(setting: .fail, data: [CurrencyParsedModel]())
        
        let apiService = APIService(networkService: networkServiceMock, parseService: parseServiceMock)
        
        let promise = expectation(description: "forLoadCurrencies")
        
        apiService.loadCurrencies(base: .EUR) { (results) in
            promise.fulfill()
            
            switch results {
            case .success(_):
                XCTFail("Was able to load models, but should not.")
            case .fail(_):
                break
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadCurrenciesRealParseService() {
        let json = ResourceManager(classForCoder: self.classForCoder).getLatestCurrenciesFromResources()
        
        let networkServiceMock = NetworkServiceMock(setting: .success(json))
        let parseService       = ParseService()
        
        let apiService = APIService(networkService: networkServiceMock, parseService: parseService)
        
        let promise = expectation(description: "forLoadCurrencies")
        
        apiService.loadCurrencies(base: .EUR) { (results) in
            promise.fulfill()
            
            switch results {
            case .success(_):
                break
            case .fail(let error):
                switch error {
                case .couldNotParse:
                    XCTFail("Was no able to parse models.")
                case .serverError:
                    XCTFail("Was no able to load models.")
                }
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}
