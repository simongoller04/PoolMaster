//
//  PopOverView.swift
//  PoolMaster
//
//  Created by Simon Goller on 06.07.22.
//

import SwiftUI

struct PopOverView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var showPopOver: Bool
    @State private var selection = Set<Cell>()

    
    var body: some View {
        NavigationView {
            VStack {
                List(cells, id: \.self, selection: $selection) { cell in
                    Text(cell.name)
                }
                Spacer()
                Button ("add \(selection.count) items"){
                    for cell in selection {
                        if cell.category == .information {
                            viewModel.informationsArray.append(cell)
                        }
                        
                        if cell.category == .controll {
                            viewModel.controllsArray.append(cell)
                        }
                        
                        self.showPopOver = false
                    }
                }
                .foregroundColor(.white)
                .padding()
                .frame(minWidth: 0, maxWidth: 300, minHeight: 0, maxHeight: 50, alignment: .center)
                .background(.blue)
                .cornerRadius(10)
            }
            .toolbar {
                EditButton()
            }
            .navigationTitle("\(selection.count) selected")
        }
    }
}
