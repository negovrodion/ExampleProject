//
//  EnumCollection.swift
//  TestModule
//
//  Created by Rodion on 22.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - EnumCollection
protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allCases: [Self] { get }
}

extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) {
                    $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee }
                }
                
                guard current.hashValue == raw else {
                    return nil
                }
                
                raw += 1
                
                return current
            }
        }
    }
    
    static var allCases: [Self] {
        return Array(self.cases())
    }
}
