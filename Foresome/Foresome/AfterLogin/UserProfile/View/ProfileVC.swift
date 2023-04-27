//
//  ProfileVC.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
//

import UIKit
import Foundation
import AuthenticationServices
import CryptoKit
import GameKit
import Security
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profileTableView: StrachyHeaderTable!
    
    var setData: [SettingsRowDataModel] = Profile.array
    var presenter: UserProfilePresenterProtocol?
    var isSelected: Bool = false
    weak var headerView: ProfileHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        saveCreatUserData()
    }
    
    func setTableView() {
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        profileTableView.register(cellClass: ProfileTableCell.self)
        profileTableView.register(cellClass: ChangeProfilePictureTableCell.self)
        setTableHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveCreatUserData()
    }
    
    func saveCreatUserData() {
        let db = Firestore.firestore()
        let currentUserId = UserDefaults.standard.value(forKey: "user_uid") as? String ?? ""
        db.collection("users").document(currentUserId ?? "").getDocument { (snapData, error) in
            if let data = snapData?.data() {
                UserDefaults.standard.set(data, forKey: "myUserData")
            }
        }
    }
    
    //MARK: set table header-----
    func setTableHeader() {
        guard  headerView == nil else { return }
        let height: CGFloat = 136
        let view = UIView.initView(view: ProfileHeader.self)
        view.setHeaderData()
        self.profileTableView.setStrachyHeader(header: view, height: height)
    }
    
    //MARK: fucntion for pic image for profile-----
    func picImageForProfile(sourcetpye: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = sourcetpye
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //profileImage.image  = tempImage
        // print("base 64 string of picked image -----\(tempImage.convertImageToBase64String())")
        //pickedProfileImage = tempImage.convertImageToBase64String()
        self.dismiss(animated: true) {
            //self.presenter?.updateUserProfile(profilePicName: tempImage.convertImageToBase64String())
            // self.presenter?.updateProfilePic(profileImage: tempImage)
            let db = Firestore.firestore()
            let documentsId = ((UserDefaults.standard.value(forKey: "user_uid") ?? "") as? String) ?? ""
            db.collection("users").document(documentsId).setData(["user_profile_pic" : "\(tempImage.convertImageToBase64String())"], merge: true)
            ActivityIndicator.sharedInstance.showActivityIndicator()
            let currentLogedUserId  = Auth.auth().currentUser?.uid ?? ""
            db.collection("users").document(currentLogedUserId).getDocument { (snapData, error) in
                if let data = snapData?.data() {
                    UserDefaults.standard.set(data, forKey: "myUserData")
                }
                self.profileTableView.reload(row: 0)
                ActivityIndicator.sharedInstance.hideActivityIndicator()
                Singleton.shared.showMessage(message: "Profile image updated successfully.", isError: .success)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.setData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(cell: ChangeProfilePictureTableCell.self, for: indexPath)
            cell.changeProfileButton.setTitle(setData[indexPath.row].title, for: .normal)
            cell.setCellData()
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(cell: ProfileTableCell.self, for: indexPath)
            cell.title.text = setData[indexPath.row].title
            cell.titleIcon.image = setData[indexPath.row].icon
            switch self.setData[indexPath.row].type {
            case .editProfile :
                cell.toggleButton.isHidden = true
                cell.nextButton.isHidden = false
                cell.versionLabel.isHidden = true
            case .manageSkillLevel :
                cell.toggleButton.isHidden = true
                cell.nextButton.isHidden = false
                cell.versionLabel.isHidden = true
            case .notificationSettings:
                cell.toggleButton.isHidden = false
                cell.nextButton.isHidden = true
                cell.versionLabel.isHidden = true
            case .termsOfServices :
                cell.toggleButton.isHidden = true
                cell.nextButton.isHidden = false
                cell.versionLabel.isHidden = true
            case .privacyPolicy :
                cell.toggleButton.isHidden = true
                cell.nextButton.isHidden = false
                cell.versionLabel.isHidden = true
            case .aboutApp :
                cell.toggleButton.isHidden = true
                cell.nextButton.isHidden = true
                cell.versionLabel.isHidden = false
            case .logout :
                cell.title.textColor = UIColor.appColor(.redFont)
                cell.toggleButton.isHidden = true
                cell.nextButton.isHidden = true
                cell.versionLabel.isHidden = true
            default:
                break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.setData[indexPath.row].type {
        case .changeProfilePicture:
            let vc = VariationViewController(isFromProfileVc: true)
            vc.isEditProfile = true
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, true)
        case .editProfile:
            let vc = EditProfilePresenter.createEditProfileModule()
            vc.hidesBottomBarWhenPushed = true
            self.pushViewController(vc, true)
        case .manageSkillLevel:
            let skillVc = UserSkillPresenter.createUserSkillModule()
            skillVc.hidesBottomBarWhenPushed = true
            skillVc.isFromEditProfile = true
            self.pushViewController(skillVc, true)
            break
        case .notificationSettings:
            let cell = tableView.dequeue(cellClass: ProfileTableCell.self)
           if  cell?.toggleButton.isSelected == true {
                print("selected done")
            } else {
                print("unselected done")
            }
            break
        case .termsOfServices:
            guard let url = URL(string: "https://www.google.com") else { return }
            UIApplication.shared.open(url)
            break
        case .privacyPolicy:
            guard let url = URL(string: "https://www.google.com") else { return }
            UIApplication.shared.open(url)
            break
        case .aboutApp:
            guard let url = URL(string: "https://www.google.com") else { return }
            UIApplication.shared.open(url)
            break
        case .logout:
            let vc = LogoutViewController()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, true)
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension ProfileVC: UserProfileViewProtocol {
    
}

extension ProfileVC: VariationViewControllerDelegate {
    func playerCount(text: String) {
        if text == "Camera" {
            self.dismiss(animated: false) {
                self.picImageForProfile(sourcetpye: .camera)
            }
        } else {
            picImageForProfile(sourcetpye: .photoLibrary)
        }
    }
}

extension ProfileVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.profileTableView.setStrachyHeader()
    }
}

