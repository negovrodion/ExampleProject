//
//  CurrenciesListWireframe.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import UIKit

// MARK: - CurrenciesListWireframe
final class CurrenciesListWireframe {
    
    private enum Constants {
        static let storyboardName = "CurrenciesList"
        static let vcName         = "CurrenciesListVC"
    }
    
    var view: UIViewController
    
    
    init() {
        let tempView   = UIStoryboard.getVC(fromStoryboard: Constants.storyboardName,
                                             withIdentifire: Constants.vcName) as! CurrenciesListVC
        let presenter  = CurrenciesListPresenter()
        let interactor = CurrenciesListInteractor(apiService: APIService(networkService: NetworkService(),
                                                                          parseService: ParseService()))
        
        tempView.output      = presenter
        presenter.view       = tempView
        presenter.interactor = interactor
        interactor.output    = presenter
        
        view = tempView
    
    }
}
