//
//  PumpCellView.swift
//  PoolMaster
//
//  Created by Simon Goller on 28.02.23.
//

import SwiftUI

struct PumpSwitchCellSmall: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationLink(destination: DetailedPumpView()){
            HStack {
                Spacer()
                Toggle("Pump", isOn: $viewModel.isPumpOn)
                    .onChange(of: viewModel.isPumpOn) { currentState in
                        Task {
                            await viewModel.controlDevices(state: currentState, deviceName: Device.pump.rawValue)
                        }
                    }
                    // the toggle is disabled when the automaticmode is on
                    .disabled(viewModel.isAutomaticModeOn)
                Spacer()
            }
            .padding()
        }
        .buttonStyle(.plain)
    }
}
