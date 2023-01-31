//
//  HomeView.swift
//  PoolMaster
//
//  Created by Simon Goller on 04.07.22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showPopOver = false
    
    var cell =  Cell(cellType: .temperaturePoolCellSmall, name: "Temperature Pool", category: .information)
    

    var body: some View {
        List {
            Section (header: Text("Informations")) {
                ForEach(viewModel.informationsArray, id: \.self) { cell in
                    handleCell(cell: cell.cellType)
                }
                .onDelete(perform: deleteInformation)
            }

            Section (header: Text("Controlls")) {
                ForEach(viewModel.controllsArray, id: \.self) { cell in
                    NavigationLink(destination: DetailedPumpView()){
                        handleCell(cell: cell.cellType)
                    }
                }
                .onDelete(perform: deleteControlls)
            }
        }
        .navigationTitle("Pool")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button() {
                    showPopOver = true
                } label: {
                    Image (systemName: "plus")
                }
            }
        }
        .popover(isPresented: $showPopOver) {
            PopOverView(showPopOver: $showPopOver)
        }
        .onAppear() {
            if viewModel.firstTimeStartedApp {
                viewModel.requestNotifications()
            }
//            viewModel.loadUserDefaults()
        }
    }
    
    func deleteInformation(at offsets: IndexSet) {
        viewModel.informationsArray.remove(atOffsets: offsets)
    }
    
    func deleteControlls(at offsets: IndexSet) {
        viewModel.controllsArray.remove(atOffsets: offsets)
    }
}

