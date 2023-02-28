//
//  OutsideTemperatureCellView.swift
//  PoolMaster
//
//  Created by Simon Goller on 28.02.23.
//

import SwiftUI

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
