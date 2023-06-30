//
//  FilterTableViewCell.swift
//  Foresome
//
//  Created by Deepanshu on 19/05/23.
//

import UIKit
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

protocol FilterTableViewCellDelegate {
    func getUpdatedText(filterBy: String, index: Int)
}

class FilterTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var filterIcon: UIButton!
    @IBOutlet weak var sortByLabel: UILabel!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var sortSelectedButton: UIButton!
    
    var delegate: FilterTableViewCellDelegate?
    var pickerView = UIPickerView()
    var listTournamentsData =  [TournamentModel]()
    var tournamentsIndex: Int?
    var tournamentsId : String?
    var arrayOfTournamentsId: [String]?
    
    override func awakeFromNib() {
        self.searchField.autocorrectionType  = .no
        super.awakeFromNib()
        self.searchField.delegate = self
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.getTournmentsData()
    }
    
    func setFilterData(index: Int) {
        if index == 0 {
            if ((UserDefaults.standard.value(forKey: AppStrings.friendsName) as? String)?.count ?? 0)  > 0 {
                self.searchField.text = UserDefaults.standard.value(forKey: AppStrings.friendsName) as? String ?? ""
            }
        } else {
            if ((UserDefaults.standard.value(forKey: AppStrings.tournamentsName) as? String)?.count ?? 0)  > 0 {
                self.searchField.text = UserDefaults.standard.value(forKey: AppStrings.tournamentsName) as? String ?? ""
            }
        }
    }
    
    func setCellData(isSelected: Bool, index: Int) {
        if index == (UserDefaults.standard.value(forKey: AppStrings.sortOptionIndex) as? Int ?? 0) {
            self.sortSelectedButton.isSelected = true
        } else {
            self.sortSelectedButton.isSelected = false
        }
    }
    
    func addPickerView() {
        if tournamentsIndex == 1 {
            self.searchField.inputView = pickerView
        }
    }
    
    //MARK: code for get tournamnets data from firebase----------
    func getTournmentsData() {
        self.arrayOfTournamentsId = []
        let db = Firestore.firestore()
        db.collection("tournaments").getDocuments { (querySnapshot, err) in
            querySnapshot?.documents.forEach({ tournamentsData in
                self.arrayOfTournamentsId?.append(tournamentsData.documentID)
            })
            querySnapshot?.documents.enumerated().forEach({ (index, document) in
                let tournament =  document.data()
                let tournamentsModel = TournamentModel(json: tournament)
                self.listTournamentsData.append(tournamentsModel)
            })
        }
    }
    
    func resetFilterAndSorting() {
        self.searchField.text = ""
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listTournamentsData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.listTournamentsData[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchField.text = self.listTournamentsData[row].title
        UserDefaults.standard.set(self.listTournamentsData[row].title ?? "", forKey: AppStrings.tournamentsName)
        UserDefaults.standard.set(self.listTournamentsData[row].id ?? "" , forKey: AppStrings.tournamentsId)
        if let delegate = self.delegate {
            print("tournaments docs id is ---==\(self.arrayOfTournamentsId?[row] ?? "")")
            delegate.getUpdatedText(filterBy: self.arrayOfTournamentsId?[row] ?? "", index: indexPath?.row ?? 0)
        }
        self.listTournamentsData.forEach({ tournamentsDetails in
            print("tournamentsDetails title is ---\(tournamentsDetails.title ?? "")")
            print("tournamentsDetails id is ---\(tournamentsDetails.id ?? "")")
        })
        searchField.resignFirstResponder()
    }
    
    @IBAction func filterByAction(_ sender: UIButton) {
        if tournamentsIndex == 1 {
            self.searchField.inputView = pickerView
        }
    }
}

extension FilterTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text as NSString? else {
            return false
        }
        let updatedString = text.replacingCharacters(in: range, with: string)
        print("new text is ---\(updatedString)")
        if updatedString == " " {
            return false
        } else {
            if updatedString.count > 0 {
                print("updated string is ----\(updatedString)")
                let searchText = updatedString
                if tournamentsIndex == 0 {
                    if let delegate = self.delegate {
                        delegate.getUpdatedText(filterBy: searchText, index: indexPath?.row ?? 0)
                    }
                } else {
                    if let delegate = self.delegate {
                        // delegate.getUpdatedText(filterBy: self.tournamentsId ?? "", index: indexPath?.row ?? 0)
                    }
                }
            } else {
                print("selected search else case.")
            }
            return true
        }
    }
}




