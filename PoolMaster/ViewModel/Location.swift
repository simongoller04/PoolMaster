//
//  Location.swift
//  PoolMaster
//
//  Created by Simon Goller on 08.07.22.
//

import Foundation
import CoreLocation

class LocationViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {

    @Published var currentTemperature: Double = 0
    @Published var longitude: Double = 0
    @Published var latitude: Double = 0
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        }
        
        else {
            print("Location needs to be enabled!")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            
            case .restricted:
                print("Location permission is retricted")
            
            case .denied:
                print("Location permission is denied")
            
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                guard let longitude = locationManager.location?.coordinate.longitude else {
                    return
                }
                
                self.longitude = longitude
                
                guard let latitude = locationManager.location?.coordinate.latitude else {
                    return
                }
                
                self.latitude = latitude
            
                Task {
//                    await WeatherAPI.shared.requestWeatherForLocation(
//                            longitude: longitude,
//                            latitude: latitude)
                }
            
                locationManager.stopUpdatingLocation()
            
            @unknown default:
                break
        }
    }
    
    // is called when the authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print ("test")
        
        guard let longitude = locations.last?.coordinate.longitude else {
            return
        }
        
        self.longitude = longitude
        
        guard let latitude = locations.last?.coordinate.latitude else {
            return
        }
        
        self.latitude = latitude
        
        checkLocationAuthorization()
    }
}

