//
//  CurrencyAbbr.swift
//  TestModule
//
//  Created by Rodion on 20.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - CurrencyAbbr
enum CurrencyAbbr: String, EnumCollection {
    case EUR
    case AUD
    case BGN
    case BRL
    case CAD
    case CHF
    case CNY
    case CZK
    case DKK
    case GBP
    case HKD
    case HRK
    case HUF
    case IDR
    case ILS
    case INR
    case ISK
    case JPY
    case KRW
    case MXN
    case MYR
    case NOK
    case NZD
    case PHP
    case PLN
    case RON
    case RUB
    case SEK
    case SGD
    case THB
    case TRY
    case USD
    case ZAR
    
    static var allCasesRaw: [String] {
        return allCases.map({ $0.rawValue })
    }
    
    static func allCases(except: CurrencyAbbr) -> [String] {
        let exceptOne         = except.rawValue
        let allCasesExceptOne = allCasesRaw.filter { $0 != exceptOne }
        
        return allCasesExceptOne
    }
}

