//
//  NetworkService.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - Config
final class Config {
    
    // MARK: - Fileprivate Constants
    fileprivate enum Constants {
        static let Config = "Config"
        
    }
    
    fileprivate enum Configuration: String {
        case Development
        case UnitTests
    }
    
    fileprivate enum ConfigurationKey: String {
        case EndpointsServerURL
    }
    
    // MARK: - Singleton
    static let shared = Config(bundle: Bundle.main)
    
    // MARK: - Private properties
    fileprivate var configs: [ConfigurationKey : String]
    fileprivate var configuration: Configuration
    
    // MARK: - Initialization
    private init(bundle: Bundle) {
        configs = [ConfigurationKey : String]()
        
        guard let currentConfiguration = bundle.object(forInfoDictionaryKey: Constants.Config) as? String else {
            fatalError("Config - init(): No 'config' key in Config.plist.")
        }
        
        let splittedCurrentConfiguration = currentConfiguration.split(separator: " ")
      
        guard !splittedCurrentConfiguration.isEmpty,
            let configuration = Configuration(rawValue: String(splittedCurrentConfiguration[0])) else {
            fatalError("Config - init(): Unsupported configuration.")
        }
        
        self.configuration = configuration

        guard let pathToDict = bundle.path(forResource: Constants.Config, ofType: "plist"),
            let _dict = NSDictionary(contentsOfFile: pathToDict),
            let dict = _dict.object(forKey: configuration.rawValue) as? [String : String] else {
            fatalError("Config - init(): No '" + configuration.rawValue + "' key in Config.plist.")
        }
        
        guard let endpointsServerURL = dict[ConfigurationKey.EndpointsServerURL.rawValue] else {
            fatalError("Config - init(): No '" + ConfigurationKey.EndpointsServerURL.rawValue
                + "' key in Config.plist.")
        }

        configs[.EndpointsServerURL]  = endpointsServerURL
    }
    
    // MARK: - Fileprivate functions

}

extension Config {
    
    var endpointsServerURL: String {
        return configs[.EndpointsServerURL]!
    }
}
