//
//  LocationManager.swift
//  Maps
//
//  Created by hitesh on 31/12/20.
//

import Foundation
import CoreLocation
import UIKit


class LocationManager : CLLocationManager {
    static let shared = LocationManager()
    var currentLocation: CLLocation?
    var isdenied:Bool = false
    
    var defaultLoc = CLLocation(latitude: 39.949861136189895, longitude: -75.15058250936818)
    
    
    func getAuthorization(){
        self.delegate = self
        self.desiredAccuracy = kCLLocationAccuracyBest
        if Self.authorizationStatus() != .authorizedAlways
        {
            self.requestAlwaysAuthorization()
        } else {
            self.startUpdatingLocation()
        }
    }
    
    func isAuthorized()-> Bool{
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined,.restricted  :
                return false
            case .denied:
                self.isdenied = true
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                self.delegate = self
                self.desiredAccuracy = kCLLocationAccuracyBest
                self.startUpdatingLocation()
                return true
            @unknown default:
                return false
            }
        }else{
            self.isdenied = true
            return false
        }
        
    }
    
    
    func alertForChangeLocationSetting(controller: UIViewController){
        let alertController = UIAlertController(title: "", message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)

           let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
               guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                   return
               }
               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                }
           }
           let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

           alertController.addAction(cancelAction)
           alertController.addAction(settingsAction)
        controller.present(alertController, animated: false, completion: nil)
    }
    
    class func geocode(location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(location) { completion($0?.first, $1) }
    }
    
    
    class func geocode(lat: Double, lng:Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        let location = CLLocation(latitude: lat, longitude: lng)
        CLGeocoder().reverseGeocodeLocation(location) { completion($0?.first, $1)
        }
    }
    
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch(CLLocationManager.authorizationStatus()) {
            case .authorizedAlways, .authorizedWhenInUse:
                manager.startUpdatingLocation()
            case .denied, .notDetermined, .restricted:
                manager.stopUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = location
        self.stopUpdatingLocation()
    }
}


extension CLPlacemark {
    
    func printValues() {
        print("name:", self.name ?? "")
        print("address1:", self.thoroughfare ?? "")
        print("address2:", self.subThoroughfare ?? "")
        print("city:",     self.locality ?? "")
        print("state:",    self.administrativeArea ?? "")
        print("zip code:", self.postalCode ?? "")
        print("country:",  self.country ?? "")
    }
    
    var city:String? {
        return self.locality
    }
    
    var state: String? {
        return self.administrativeArea
    }
    
    var address1:String? {
        return self.thoroughfare
    }
    
    var address2:String? {
        return self.subThoroughfare
    }
    
    var pin:String?{
        return self.postalCode
    }
    
    
    var address: String {
        var addressString : String = ""
        let pm:CLPlacemark = self
//        if pm.name != nil{
//            addressString += pm.name! + ", "
//        }
        if pm.subLocality != nil {
            addressString += pm.subLocality! + ", "
        }
        if pm.thoroughfare != nil {
            addressString += pm.thoroughfare! + ", "
        }
        if pm.locality != nil {
            addressString += pm.locality! + ", "
        }
        if pm.administrativeArea != nil {
            addressString += pm.administrativeArea! + ", "
        }
        if pm.country != nil {
            addressString += pm.country! + ", "
        }
        if pm.postalCode != nil {
            addressString += pm.postalCode! + " "
        }
        
        return addressString
    }
    
    
}
