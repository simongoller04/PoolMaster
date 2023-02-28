//
//  PoolMasterApp.swift
//  PoolMaster
//
//  Created by Simon Goller on 04.07.22.
//

import SwiftUI

@main
struct PoolMasterApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    HomeView()
                }
                .tabItem {
                    Label("Pool", systemImage: "rectangle.3.group.fill")
                }
               
                NavigationView {
                    PreferencesView()
                }
                .tabItem {
                    Label("Preferences", systemImage: "gear.circle.fill")
                }
            }
            .environmentObject(ViewModel())
        }
    }
}
