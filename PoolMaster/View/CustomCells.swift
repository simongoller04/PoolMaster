//
//  CustomCells.swift
//  PoolMaster
//
//  Created by Simon Goller on 04.07.22.
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
        ModeSwitchCellSmall()
    case .pumpSwitchCellSmall:
        PumpSwitchCellSmall()
    case .saltmasterSwitchCellSmall:
        SaltmasterSwitchCellSmall()
    }
}

struct TemperaturePoolCellSmall: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        HStack (alignment: .center){
            Spacer()
            HStack {
                VStack {
                    Text("Temperature")
                    Text("Pool")
                }
                Spacer()
                
                if viewModel.isCelciusSelected {
                    Text(String(viewModel.currentPoolTemperature).appending(" °C"))
                        .font(.title)
                        .bold()
                } else {
                    var tempF = round((viewModel.currentPoolTemperature * (9/5) + 32) * 10) / 10.0
                    Text(String(tempF).appending(" °F"))
                        .font(.title)
                        .bold()
                }
            }
            .padding()
            
            Spacer()
        }
        .cornerRadius(10)
        .onAppear() {
            viewModel.startTimer()
        }
    }
}

struct TemperatureOutsideCellSmall: View {
    @EnvironmentObject var viewModel: ViewModel
    @StateObject var locationViewModel = LocationViewModel()

    var temp: Double = 0
    
    var body: some View {
        HStack(alignment: .center){
            Spacer()
            VStack {
                Text("Temperature")
                Text("Outside")
                Text(viewModel.isCelciusSelected ? "23 °C" : "73,4 °F")
                    .font(.title)
                    .bold()
                HStack {
                    Text("long: \(locationViewModel.longitude)")
                    Text("lat: \(locationViewModel.latitude)")
                }
            }
            .padding()
            Spacer()
        }
        .onAppear {
            locationViewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

struct PumpSwitchCellSmall: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Toggle("Pump", isOn: $viewModel.isPumpOn)
                .onChange(of: viewModel.isPumpOn) { currentState in
                    Task {
                        await viewModel.controlDevices(state: currentState, deviceName: "Pump")
                    }
                }
            Spacer()            
        }
        .padding()
    }
}

struct ModeSwitchCellSmall: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Toggle("Automatic", isOn: $viewModel.isAutomaticModeOn)
                .onChange(of: viewModel.isAutomaticModeOn) { currentState in
                    Task {
                        await viewModel.controlDevices(state: currentState, deviceName: "AutomaticMode")
                    }
//                    if on {
//                        viewModel.sendNotificaton()
//                    }
                }
            Spacer()
        }
        .padding()
    }
}

struct SaltmasterSwitchCellSmall: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Toggle("Saltmaster", isOn: $viewModel.isSaltmasterOn)
                .onChange(of: viewModel.isSaltmasterOn) { currentState in
                    Task {
                        await viewModel.controlDevices(state: currentState, deviceName: "Saltmaster_SaltChannel")
                    }
                }
            Spacer()
        }
        .padding()
    }
}


