//
//  LocationViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 22/03/23.
//

import UIKit
import MapKit

class LocationViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var whereAreYouLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.whereAreYouLabel.text = AppStrings.titleLabel
        locationField.delegate = self
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextAction(_ sender: Any) {
        let vc = ProfilePictureViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let controller = AutoCompletePlaces()
        controller.presentPlacePicker(controller: self) { placeData in
            print("address is ****** \(placeData)")
            DispatchQueue.main.async {
                textField.text = placeData.fullAddress
            }
        }
        return true
    }
}
