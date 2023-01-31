//
//  DetailedPumpView.swift
//  PoolMaster
//
//  Created by Simon Goller on 13.12.22.
//

import SwiftUI

struct DetailedPumpView: View {
    @EnvironmentObject var viewModel: DetailedPumpViewModel
    
    var body: some View {
        List {
            HStack {
                VStack {
                    Text("Operating Hours")
                        .font(.footnote)
                    Text("Pump")
                        .font(.title2)
                }
                Spacer()
                
                Text("20".appending("h"))
                    .font(.title)
                
                Spacer()
            }
        }
        .navigationTitle("Pump Informartions")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: PumpTimesView()) {
                    Image (systemName: "clock.arrow.2.circlepath")
                }
            }
        }
    }
}

struct DetailedPumpView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedPumpView()
    }
}
