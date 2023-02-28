//
//  AutomaticModeCellView.swift
//  PoolMaster
//
//  Created by Simon Goller on 28.02.23.
//

import SwiftUI

struct AutomaticModeCellView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Toggle("Automatic", isOn: $viewModel.isAutomaticModeOn)
                .onChange(of: viewModel.isAutomaticModeOn) { currentState in
                    Task {
                        await viewModel.controlDevices(state: currentState, deviceName: Device.automatic.rawValue)
                    }
                }
                .padding(.trailing, 20)
            Spacer()
        }
        .padding()
    }
}
