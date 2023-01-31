//
//  PumpTimesView.swift
//  PoolMaster
//
//  Created by Simon Goller on 10.12.22.
//

import SwiftUI

struct PumpTimesView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var amountString = "5"
    var amount = 5
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                if viewModel.timeSlotAmount > 1 {
                    viewModel.timeSlotAmount -= 1
                }
            } label: {
                Image (systemName: "minus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            Text(String(viewModel.timeSlotAmount))
                .padding([.leading, .trailing], 8)
            
            Button {
                if viewModel.timeSlotAmount < 10 {
                    viewModel.timeSlotAmount += 1
                }
            } label: {
                Image (systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            Spacer()
        }
        
        List {
            ForEach (1...viewModel.timeSlotAmount, id:\.self) { i in
                TimeCell()
            }
        }
        .navigationTitle("Automatic Pump Times")
    }
}

struct TimeCell: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var timeStart = Date.now
    @State private var timeEnd = Date.now

    var body: some View {
        VStack {
            DatePicker("Start", selection: $timeStart, displayedComponents: .hourAndMinute)
            DatePicker("End", selection: $timeEnd, displayedComponents: .hourAndMinute)
            Button {
                Task {
                    await viewModel.addRule()
                }
            } label: {
                Text("Add")
            }

        }

    }
}
