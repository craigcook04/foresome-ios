//
//  LocationViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 22/03/23.
//

import UIKit
import MapKit

class LocationViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var whereAreYouLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.whereAreYouLabel.text = AppStrings.titleLabel
        locationField.delegate = self
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.popVC()
    }
    @IBAction func nextAction(_ sender: Any) {
        let vc = ProfilePictureViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func skipForNowAction(_ sender: Any) {
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
                self.locationField.text = placeData.fullAddress
            }
        }
        return false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.locationGet()
    }
}
