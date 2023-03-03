//
//  LocationHandler.swift
//  MusicByLocation
//
//  Created by Alexander Bater on 01/03/2023.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate, ObservableObject {
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    @Published var lastKnownSubLocation: String = ""
    @Published var lastKnownLocation: String = ""
    @Published var lastKnownCountry: String = ""
    
    override init(){
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorisation() {
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
    }
    
    func requestLocation(){
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let firstLocation = locations.first{
            geocoder.reverseGeocodeLocation(firstLocation, completionHandler: {(placemarks, error) in
                if error != nil{
                    self.lastKnownSubLocation = "Could not perform lookup of sublocation from coordinate info"
                    self.lastKnownLocation = "Could not perform lookup of location from coordinate info"
                    self.lastKnownCountry = "Could not perform lookup of country from coordinate info"
                    
                } else{
                    if let firstPlacemark = placemarks?[0]{
                        self.lastKnownSubLocation = firstPlacemark.subLocality ?? "Couldnt find sublocality"
                        self.lastKnownLocation = firstPlacemark.locality ?? "Couldnt find locality"
                        self.lastKnownCountry = firstPlacemark.country ?? "Couldnt find country"
                    }
                }
            })
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        lastKnownSubLocation = "Error finding location"
        lastKnownLocation = "Error finding location"
        lastKnownCountry = "Error finding country"
    }
}
