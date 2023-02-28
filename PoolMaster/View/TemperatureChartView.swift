//
//  TemperatureChartView.swift
//  PoolMaster
//
//  Created by Simon Goller on 27.02.23.
//

import SwiftUI
import Charts

struct TemperatureChartView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Pool Temperature")
                .font(.title3)
                .padding(.bottom, 16)
            
            if !viewModel.temperatureArray.isEmpty {
                Chart {
                    RuleMark(y: .value("Average", calculateAverage(temperatures: viewModel.temperatureArray)))
                        .foregroundStyle(Color.mint)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                    
                    ForEach(viewModel.temperatureArray) { temperature in
                        PointMark(x: .value("Second", temperature.date, unit: .second),
                                  y: .value("Temperature", temperature.temperature)
                        )
                        .foregroundStyle(Color.pink)
                        
                        LineMark(x: .value("Second", temperature.date, unit: .second),
                                 y: .value("Temperature", temperature.temperature)
                        )
                        .foregroundStyle(Color.pink.gradient)
                    }
                }
                .frame(height: 250)
                .chartYScale(domain: calculateMin(temperatures: viewModel.temperatureArray)...calculateMax(temperatures: viewModel.temperatureArray))
            }
            
            else {
                ZStack {
                    Chart {
                        
                    }
                    .frame(height: 250)
                    
                    HStack {
                        Spacer()
                        
                        Text("N/A")
                            .font(.headline)
                            .bold()
                        
                        Spacer()
                    }
                }
            }
            
            HStack {
                Image(systemName: "line.diagonal")
                    .rotationEffect(Angle(degrees: 45))
                    .foregroundColor(Color.mint)
                
                Text("Average Temperatue")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

func calculateAverage(temperatures: [Temperature]) -> Double {
    return (temperatures.map { $0.temperature }.reduce(0, +)) / Double(temperatures.count).rounded()
}

func calculateMin(temperatures: [Temperature]) -> Double {
    return temperatures.min()!.temperature.rounded()-2
}

func calculateMax(temperatures: [Temperature]) -> Double {
    return temperatures.max()!.temperature.rounded()+2
}

//struct TemperatureChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        TemperatureChartView()
//    }
//}
