//
//  LocationPresenter.swift
//  Foresome
//
//  Created by Deepanshu on 04/04/23.
//

import Foundation
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

class LocationPresenter : LocationPresenterProtocol {
    var view: LocationViewProtocol?
    
    static func createLocationModule() -> LocationViewController {
        let view = LocationViewController()
        var presenter: LocationPresenterProtocol = LocationPresenter()
        presenter.view = view
        view.presenter = presenter
        return view
    }
    
    func updateUserLocation(countryName: String) {
        let db = Firestore.firestore()
        do {
            let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
            db.collection("users").document(documentsId).setData(["user_location" : "\(countryName)"], merge: true)
            if let signupVc = self.view as? LocationViewController {
                let locationVc = ProfilePresenter.createProfileModule()
                signupVc.pushViewController(locationVc, true)
            }
        } catch let error {
            Singleton.shared.showMessage(message: "\(error.localizedDescription)", isError: .error)
        }
    }
}
