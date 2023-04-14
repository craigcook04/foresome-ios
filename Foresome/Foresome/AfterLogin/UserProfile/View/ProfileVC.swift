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
    
    @IBOutlet weak var profileTableView: UITableView!
    
    var setData: [SettingsRowDataModel] = Profile.array
    var button: IndexPath?
    var presenter: UserProfilePresenterProtocol?
    var isSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellData()
        let headerView = ProfileHeader(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 136))
        headerView.imageView.image = UIImage(named: "img_1")
        self.profileTableView.tableHeaderView = headerView
    }
    
    func setCellData() {
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        profileTableView.register(cellClass: ProfileTableCell.self)
        profileTableView.register(cellClass: ChangeProfilePictureTableCell.self)
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
        print("base 64 string of picked image -----\(tempImage.convertImageToBase64String())")
        //pickedProfileImage = tempImage.convertImageToBase64String()
        self.dismiss(animated: true, completion: nil)
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
            self.button = indexPath
            switch indexPath.row {
            case 1 :
                cell.toggleButton.isHidden = true
                cell.nextButton.isHidden = false
                cell.versionLabel.isHidden = true
            case 2:
                cell.toggleButton.isHidden = true
                cell.nextButton.isHidden = false
                cell.versionLabel.isHidden = true
            case 3:
                cell.toggleButton.isHidden = false
                cell.nextButton.isHidden = true
                cell.versionLabel.isHidden = true
            case 4:
                cell.toggleButton.isHidden = true
                cell.nextButton.isHidden = false
                cell.versionLabel.isHidden = true
            case 5:
                cell.toggleButton.isHidden = true
                cell.nextButton.isHidden = false
                cell.versionLabel.isHidden = true
            case 6:
                cell.toggleButton.isHidden = true
                cell.nextButton.isHidden = true
                cell.versionLabel.isHidden = false
            case 7:
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
            self.pushViewController(vc, true)
        case .manageSkillLevel:
            let skillVc = UserSkillPresenter.createUserSkillModule()
            self.pushViewController(skillVc, true)
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
            let controller = UIAlertController(title: "Are you want to logout?", message: nil, preferredStyle: .alert)
            let devUrl = UIAlertAction(title: "Yes", style: .default) { action in
                do {
                    try Auth.auth().signOut()
                    UserDefaults.standard.removeObject(forKey: "user_uid")
                    if Auth.auth().currentUser?.uid == nil {
                        Singleton.shared.showMessage(message: "logout successfully.", isError: .success)
                        Singleton.shared.gotoLogin()
                    }
                    print("logout successfullyy")
                } catch {
                    print("Error while signing out!")
                    Singleton.shared.showMessage(message: "Unable to logout.", isError: .error)
                }
            }
            let liveUrl = UIAlertAction(title: "No", style: .default) { action in
                self.dismiss(animated: false)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(devUrl)
            controller.addAction(liveUrl)
            controller.addAction(cancel)
            self.present(controller, true)
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView.getFromNib(className: ProfileHeader.self)
        return sectionHeader
    }
}
extension ProfileVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.profileTableView.tableHeaderView as! ProfileHeader
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}

extension ProfileVC: UserProfileViewProtocol {}

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



