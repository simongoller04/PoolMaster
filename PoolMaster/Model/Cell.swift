//
//  Cell.swift
//  PoolMaster
//
//  Created by Simon Goller on 10.12.22.
//

import Foundation

struct Cell: Hashable, Codable, Identifiable {
    var id = UUID()
    let cellType: CellType
    let name: String
    let category: Category
}

enum Category: Codable {
    case controll
    case information
}

enum CellType: Codable {
    case temperaturePoolCellSmall
    case temperatureOutsideCellSmall
    case modeSwitchCellSmall
    case pumpSwitchCellSmall
    case saltmasterSwitchCellSmall
}
