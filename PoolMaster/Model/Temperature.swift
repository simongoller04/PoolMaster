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

// MARK: functions to callculate important values for the graph

func calculateAverage(temperatures: [Temperature]) -> Double {
    return (temperatures.map { $0.temperature }.reduce(0, +)) / Double(temperatures.count).rounded()
}

func calculateMin(temperatures: [Temperature]) -> Double {
    return temperatures.min()!.temperature.rounded()-2
}

func calculateMax(temperatures: [Temperature]) -> Double {
    return temperatures.max()!.temperature.rounded()+2
}
