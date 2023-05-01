//
//  LocationViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 22/03/23.
//

import UIKit
import MapKit

class LocationViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate, LocationViewProtocol {
    
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var whereAreYouLabel: UILabel!
    
    var presenter: LocationPresenterProtocol?
    var pickedLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.whereAreYouLabel.text = AppStrings.titleLabel
        locationTextView.delegate = self
        if LocationManager.shared.isAuthorized(){
            LocationManager.geocode(location: LocationManager.shared.currentLocation ?? CLLocation(), completion: { places, error in
                self.locationTextView.text = places?.address
                self.pickedLocation = places?.city ?? ""
            })
        } else {
            LocationManager.shared.alertForChangeLocationSetting(controller: self)
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        self.presenter?.updateUserLocation(countryName: "\(self.pickedLocation ?? "")")
    }
    
    @IBAction func skipForNowAction(_ sender: UIButton) {
        let vc = ProfilePictureViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func locationAction(_ sender: Any) {
        self.locationGet()
    }
    
    func locationGet() -> Bool {
        let controller = AutoCompletePlaces()
        controller.presentPlacePicker(controller: self) { placeData in
            DispatchQueue.main.async {
                self.locationTextView.text = placeData.fullAddress
                self.pickedLocation = "\(placeData.cityAddress ?? "")"
            }
        }
        return false
    }
}

extension LocationViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.locationGet()
    }
}
