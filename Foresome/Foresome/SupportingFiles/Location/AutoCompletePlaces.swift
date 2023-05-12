//
//  AutoCompletePlaces.swift
//  meetwise
//
//  Created by hitesh on 09/09/20.
//  Copyright © 2020 hitesh. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker

protocol AutoCompletePlacesDelegate {
    func didPickPlace(place:PlaceData)
    func didCancel()
}

class PlaceData: Codable {
    var fullAddress:String?
    var cityAddress:String?
    var state: String?
    var lat:Double?
    var lng:Double?
    
    init() {
    }
    
    init(locationItem: LocationItem) {
        self.lat = locationItem.coordinate?.latitude
        self.lng = locationItem.coordinate?.longitude
        self.fullAddress = locationItem.formattedAddressString
        self.cityAddress = locationItem.cityAddressString
    }
    
    init(lat: Double?, lng: Double?, address: String?) {
        self.lat = lat
        self.lng = lng
        self.fullAddress = address
    }
    
//    init(place: GMSPlace) {
//        var keys = [String]()
//        place.addressComponents?.forEach{keys.append($0.type)}
//        place.addressComponents?.forEach({ (component) in
//            print("keys are \(component.type ?? "") ==  \(component.name)")
//            if (component.type) == "sublocality_level_1" {
//                self.city = component.name
//            }
//            if (component.type) == "locality" {
//                self.locality = component.name
//            }
//            if (component.type) == "country" {
//                self.country = component.name
//            }
//        })
//        self.lat = place.coordinate.latitude
//        self.lng = place.coordinate.longitude
//    }
}

class AutoCompletePlaces: LocationPicker {
    var autodelegate: AutoCompletePlacesDelegate?
    var didPickPlace:((PlaceData) ->())?
    
    func presentPlacePicker(controller: UIViewController?, _ delegate: AutoCompletePlacesDelegate? = nil) {
        self.autodelegate = delegate
        DispatchQueue.main.async {
            self.modalPresentationStyle = .overFullScreen
            controller?.present(self, animated: true, completion: nil)
        }
    }
    
    func presentPlacePicker(controller: UIViewController?, didPickPlace:((PlaceData) ->())?) {
        self.modalPresentationStyle = .overFullScreen
        controller?.present(self, animated: true, completion: nil)
        self.pickCompletion = { placeItem in
            
            let placeData = PlaceData(locationItem: placeItem)
            didPickPlace?(placeData)
        }
    }
    
    override func locationDidSelect(locationItem: LocationItem) {
        print("Select overrided method: " + locationItem.name)
    }
}
