//
//  Temperature.swift
//  PoolMaster
//
//  Created by Simon Goller on 27.02.23.
//

import Foundation

struct Temperature: Identifiable, Comparable {
    static func < (lhs: Temperature, rhs: Temperature) -> Bool {
        lhs.temperature < rhs.temperature
    }
    
    let id = UUID()
    let temperature: Double
    let date: Date
}
