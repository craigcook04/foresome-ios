//
//  LocationViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 22/03/23.
//

import UIKit
import MapKit

class LocationViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var whereAreYouLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.whereAreYouLabel.text = AppStrings.titleLabel
        locationTextView.delegate = self

        if LocationManager.shared.isAuthorized(){
            LocationManager.geocode(location: LocationManager.shared.currentLocation ?? CLLocation(), completion: { places, error in
                self.locationTextView.text = places?.address
            
            })
        }else{
            LocationManager.shared.alertForChangeLocationSetting(controller: self)
        }
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let vc = ProfilePictureViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
            print("address is ****** \(placeData)")
            DispatchQueue.main.async {
            
                self.locationTextView.text = placeData.fullAddress
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
