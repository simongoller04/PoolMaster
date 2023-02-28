//
//  ViewModel.swift
//  PoolMaster
//
//  Created by Simon Goller on 04.07.22.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI
import UserNotifications

@MainActor
class ViewModel: ObservableObject {
    @Published var firstTimeStartedApp: Bool = true
    @Published var isCelciusSelected: Bool = true
    @Published var isPumpOn: Bool = false
    @Published var isAutomaticModeOn: Bool = false
    @Published var isSaltmasterOn: Bool = false
    
    @Published var currentPoolTemperature: Double = 23.5
    @Published var temperatureArray: [Temperature] = []
    
    @Published var informationsArray: [Cell] = []
    @Published var controllsArray: [Cell] = []
    
    @Published var timeSlotAmount = 5
    
    @Published private var timer: AnyCancellable?
    
    @Published var ipAddress = ""
    @Published var username = ""
    @Published var password = ""

    func changeIsCelciusSelected (bool: Bool) {
        self.isCelciusSelected = bool
    }
    
}

extension ViewModel {
    // making a call to the openHAB API to control the devices
    func controlDevices(state: Bool, deviceName: String) async {
        
        let value = state ? "ON" : "OFF"
        
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
    
        guard let data = value.data(using: .utf8) else {
            return
        }

        guard let url = URL(string: "https://myopenhab.org:443/rest/items/\(deviceName)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: data)
            print(data.description)
        } catch {
            print("Checkout failed.")
        }
    }
    
    // function to get the current pool temperature from the openhab system
    func getTemperature() async {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "https://myopenhab.org:443/rest/items/PoolTemperatureSensor/state") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                guard let temp = Double(String(data: data, encoding: .utf8)!) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.currentPoolTemperature = temp
                    
                    if self.temperatureArray.count > 10 {
                        self.temperatureArray.append(Temperature(temperature: temp, date: Date.now))
                        self.temperatureArray.removeFirst()
                    }
                    else {
                        self.temperatureArray.append(Temperature(temperature: temp, date: Date.now))
                    }
                }
            }

            if let error = error {
                print("HTTP Request Failed \(error)")
            }

            if let response = response {
                print(response)
            }
        }
        task.resume()
    }
    
    func getCurrentDeviceState(deviceName: String) async {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "https://myopenhab.org:443/rest/items/\(deviceName)/state") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                guard let state = String(data: data, encoding: .utf8) else {
                    return
                }
                
                DispatchQueue.main.async {
                    switch deviceName {
                    case "Pump":
                        if state == "ON" {
                            self.isPumpOn = true
                        } else {
                            self.isPumpOn = false
                        }
                        
                    case "Saltmaster_SaltChannel":
                        if state == "ON" {
                            self.isSaltmasterOn = true
                        } else {
                            self.isSaltmasterOn = false
                        }
                        
                    case "AutomaticMode":
                        if state == "ON" {
                            self.isAutomaticModeOn = true
                        } else {
                            self.isAutomaticModeOn = false
                        }
                        
                    default:
                        break
                    }
                }
            }

            if let error = error {
                print("HTTP Request Failed \(error)")
            }

            if let response = response {
                print(response)
            }
        }
        task.resume()
    }
    
    func addRule() {
        let rule = """
            rule "Turn on device 50 minutes after 11:00"
            when
            Time cron "0 11,51 * * * ?"
            then
            sendCommand(Pump, ON)
            end
            """
        
        let url = URL(string: "http://localhost:8080/rest/rules/\(rule)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = rule.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding rule: \(error)")
            }
        }
        task.resume()
    }
    
    // gets the temperature of the pool from openhab every 5 seconds
    func startTimer() {
        task()
        // start timer (tick every 5 seconds)
        timer = Timer.publish(every: 5, on: .main, in: .common)
           .autoconnect()
           .sink { _ in
                task()

           }
        
        func task() {
            Task {
                await self.getTemperature()
                await self.getCurrentDeviceState(deviceName: "Saltmaster_SaltChannel")
                await self.getCurrentDeviceState(deviceName: "Pump")
                await self.getCurrentDeviceState(deviceName: "AutomaticMode")
            }
        }
    }
    
    // this funtion checks if the given ip address is valid
    func validateIPv4Address(ipToValidate: String) -> Bool {
        var sin = sockaddr_in()
        
        if ipToValidate.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
            return true
        }
        
        return false
    }
}

// UserDefaults
extension ViewModel {
    func saveUserDefaults() {
        do {
            let encoder = JSONEncoder()
            let infoArray = try encoder.encode(informationsArray)
            let contArray = try encoder.encode(controllsArray)

            // Write/Set Data
            UserDefaults.standard.set(infoArray, forKey: "informationsArray")
            UserDefaults.standard.set(contArray, forKey: "controllsArray")
            UserDefaults.standard.set(isCelciusSelected, forKey: "isCelciusSelected")
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    func loadUserDefaults() {
        // Read/Get Data
        if let infoArray = UserDefaults.standard.data(forKey: "informationsArray") {
            do {
                let decoder = JSONDecoder()
                let array = try decoder.decode([Cell].self, from: infoArray)
                informationsArray = array
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        
        if let contArray = UserDefaults.standard.data(forKey: "controllsArray") {
            do {
                let decoder = JSONDecoder()
                let array = try decoder.decode([Cell].self, from: contArray)
                controllsArray = array
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }

        isCelciusSelected = UserDefaults.standard.bool(forKey: "isCelciusSelected")
        print(isCelciusSelected)
    }
}

// Notifications for the user
extension ViewModel {
    
    // ask the user if this app is alowed to send notifications
    func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
                
                DispatchQueue.main.async {
                    self.firstTimeStartedApp = false
                }
                
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // send a notifiacton
    func sendNotificaton() {
        let content = UNMutableNotificationContent()
        content.title = "Pump is on!"
        content.subtitle = "The pump was turned on"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
