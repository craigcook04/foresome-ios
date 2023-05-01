//
//  ProfilePictureViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 22/03/23.
//

import UIKit

class ProfilePictureViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var uploadProfilePicButton: UIButton!
    
    var presenter: ProfilePicturePresenter?
    var pickedProfileImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = AppStrings.addPictureLbl
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
        profileImage.image  = tempImage
        pickedProfileImage = tempImage.convertImageToBase64String()
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func uploadProfilePictureAction(_ sender: UIButton) {
        let vc = VariationViewController(isFromProfileVc: true)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, true)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        if pickedProfileImage == nil || (pickedProfileImage?.count ?? 0) == 0 {
            Singleton.shared.showMessage(message: AppStrings.uploadOrskipImage, isError: .error)
            return
        }
        self.presenter?.updateUserProfileData(porfilePicName: pickedProfileImage ?? "")
    }
    
    @IBAction func skipForNowAction(_ sender: UIButton) {
        let skillVc = UserSkillPresenter.createUserSkillModule()
        self.pushViewController(skillVc, true)
    }
}

extension ProfilePictureViewController: ProfilePictureViewProtocol {
    
}

extension ProfilePictureViewController: VariationViewControllerDelegate {
    func playerCount(text: String) {
        if text == AppStrings.camera{
            self.dismiss(animated: false) {
                self.picImageForProfile(sourcetpye: .camera)
            }
        } else {
            picImageForProfile(sourcetpye: .photoLibrary)
        }
    }
}
