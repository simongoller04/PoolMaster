//
//  PreferencesView.swift
//  PoolMaster
//
//  Created by Simon Goller on 04.07.22.
//

import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        List {
            Section("Personal Information") {
                PersonalInformationView()
            }
            
            Section("Settings") {
                NavigationLink(destination: TemperatureUnitDetailView(), label: {
                    HStack {
                        Text("Temperature Unit")
                        
                        Spacer()
                       
                        Text(viewModel.isCelciusSelected ? "Celcius (°C)" : "Fahrenheit (°F)")
                            .opacity(0.5)
                            .font(.footnote)
                    }
                })
            }
        }
        .navigationTitle("Preferences")
    }
}

//
struct PersonalInformationView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var ipAddress = ""
    @State var validIP: Bool = true
    @State var username = ""
    @State var password = ""
    @State var showPassword = false
    
    var body: some View {
        ZStack {
            TextField("IP-Address", text: $ipAddress)
                .onSubmit {
                    if viewModel.validateIPv4Address(ipToValidate: ipAddress) {
                        viewModel.ipAddress = ipAddress
                        validIP = true
                        print("valid: ", ipAddress)
                    }
                    else {
                        validIP = false
                        print("invalid: ", ipAddress)
                    }
                }
            
            HStack {
                Spacer()
                if !validIP {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
        
        TextField("Username", text: $username)
        
        ZStack {
            if showPassword {
                TextField("Password", text: $password)
            } else {
                SecureField("Password", text: $password)
            }
            
            HStack {
                Spacer()
                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                }
            }
        }
        HStack {
            Spacer()
            
            Button {
                viewModel.username = username
                viewModel.password = password
            } label: {
                Text("Login")
            }
            .buttonStyle(.automatic)
            
            Spacer()
        }
    }
}

// detailed View to selected the prefered temperature unit
struct TemperatureUnitDetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        List {
            HStack {
                Text("Celcius (°C)")
                Spacer()
                if viewModel.isCelciusSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .onTapGesture {
                viewModel.changeIsCelciusSelected(bool: true)
            }
            
            HStack {
                Text("Fahrenheit (°F)")
                Spacer()
                if !viewModel.isCelciusSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .onTapGesture {
                viewModel.changeIsCelciusSelected(bool: false)
            }
        }
        .navigationTitle("Temperature Unit")
        .navigationBarTitleDisplayMode(.inline)
    }
}
