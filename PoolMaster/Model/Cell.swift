//
//  Cell.swift
//  PoolMaster
//
//  Created by Simon Goller on 10.12.22.
//

import Foundation

let cells: [Cell] = [
    Cell(cellType: .temperaturePoolCellSmall, name: "Temperature Pool", category: .information),
    Cell(cellType: .temperatureOutsideCellSmall, name: "Temperature Outside", category: .information),
    Cell(cellType: .pumpSwitchCellSmall, name: "Switch Pump", category: .controll),
    Cell(cellType: .modeSwitchCellSmall, name: "Switch Automatic Mode", category: .controll),
    Cell(cellType: .saltmasterSwitchCellSmall, name: "Switch Saltmaster", category: .controll)
]

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
