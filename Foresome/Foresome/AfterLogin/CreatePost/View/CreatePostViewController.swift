//
//  CreatePostViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 05/04/23.
//

import UIKit

class CreatePostViewController: UIViewController, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var publishBottomConstraint: NSLayoutConstraint!
    
    var presenter: CreatePostPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboard()
       
    }
    func setKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            publishBottomConstraint.constant = keyboardHeight+23
            view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        publishBottomConstraint.constant = 40
        view.layoutIfNeeded()
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    
    @IBAction func cameraAction(_ sender: UIButton) {
        
    }
    
    
    @IBAction func imageAction(_ sender: UIButton) {
        
        self.presenter?.photoButtonAction()
    }
    
    
    
    @IBAction func pollAction(_ sender: UIButton) {
    }
    
    
    
}
extension CreatePostViewController: CreatePostViewProtocol, UIImagePickerControllerDelegate {
    func receiveResult() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
