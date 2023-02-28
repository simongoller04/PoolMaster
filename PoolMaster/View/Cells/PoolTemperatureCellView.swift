//
//  PoolTemperatureCellView.swift
//  PoolMaster
//
//  Created by Simon Goller on 28.02.23.
//

import SwiftUI

struct TemperaturePoolCellSmall: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationLink(destination: TemperatureChartView()) {
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
                        let tempF = round((viewModel.currentPoolTemperature * (9/5) + 32) * 10) / 10.0
                        Text(String(tempF).appending(" °F"))
                            .font(.title)
                            .bold()
                    }
                }
                .padding()
                
                Spacer()
            }
            .cornerRadius(10)
        }
    }
}
