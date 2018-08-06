//
//  ResourceManager.swift
//  TestModuleTests
//
//  Created by Rodion on 27.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import XCTest

// MARK: - ResourceManager
final class ResourceManager {
    enum Constants {
        static let LatestCurrencies = "LatestCurrencies"
    }
    
    // MARK: - Properties
    let classForCoder: AnyClass!
    
    // MARK: - Initialization
    init(classForCoder: AnyClass) {
        self.classForCoder = classForCoder
    }
    
    // MARK: - Functions
    func getLatestCurrenciesFromResources() -> Any {
        guard let path = Bundle(for: classForCoder).path(forResource: Constants.LatestCurrencies, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else {
                XCTFail()
                fatalError()
        }
        
        return jsonResult
    }
}
