//
//  CellViewbuilder.swift
//  PoolMaster
//
//  Created by Simon Goller on 28.02.23.
//

import SwiftUI

@ViewBuilder
func handleCell (cell: CellType) -> some View {
    switch cell {
    case .temperaturePoolCellSmall:
        TemperaturePoolCellSmall()
    case .temperatureOutsideCellSmall:
         TemperatureOutsideCellSmall()
    case .modeSwitchCellSmall:
        AutomaticModeCellView()
    case .pumpSwitchCellSmall:
        PumpSwitchCellSmall()
    case .saltmasterSwitchCellSmall:
        SaltmasterCellView()
    }
}
