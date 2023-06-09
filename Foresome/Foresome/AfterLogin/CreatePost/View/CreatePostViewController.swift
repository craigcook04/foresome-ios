//
//  CreatePostViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 05/04/23.
//

import UIKit

protocol CreatePostUploadDelegate {
    func uploadProgress(data:CreatePostModel)
}

class CreatePostViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var writePost: GrowingTextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var imageSelectButton: UIButton!
    @IBOutlet weak var selectImageCollection: UICollectionView!
    @IBOutlet weak var publishBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pollBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    
    @IBOutlet weak var textViewBottomConstraints: NSLayoutConstraint!
    
    var presenter: CreatePostPresenterProtocol?
    var imageSelect: [UIImage?] = []
    var imagePicker = GetImageFromPicker()
    let creatPostData = CreatePostModel()
    var delegate: CreatePostUploadDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.publishButton.isUserInteractionEnabled = false
        writePost.autocorrectionType = .no
        setKeyboard()
        self.setCellData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setProfileData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.managePublicButton()
    }
    
    func setProfileData() {
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        if let data = strings {
            if let image = (data["user_profile_pic"] as? String ?? "").base64ToImage() {
                profileImage.image = image
            }
            self.userNameLbl.text = data["name"] as? String
        }
    }
    
    func setCellData() {
        self.writePost.delegate = self
        self.selectImageCollection.delegate = self
        self.selectImageCollection.dataSource = self
        self.selectImageCollection.register(cellClass: SelectImageCollectionCell.self)
    }
    
    func setKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    func publishBtnActive() {
        if (creatPostData.postDescription?.count ?? 0) > 0 {
            return
        } else {
            if self.imageSelect.count > 0 {
                self.publishButton.isUserInteractionEnabled = true
                self.publishButton.setTitleColor(UIColor.appColor(.green_main), for: .normal)
            } else {
                self.publishButton.isUserInteractionEnabled = false
                self.publishButton.setTitleColor(UIColor.appColor(.grey_Light), for: .normal)
            }
        }
    }
    
    func managePublicButton() {
        if self.imageSelect.count > 0 {
            self.publishButton.isUserInteractionEnabled = true
            self.publishButton.setTitleColor(UIColor.appColor(.green_main), for: .normal)
        } else {
            self.publishButton.isUserInteractionEnabled = false
            self.publishButton.setTitleColor(UIColor.appColor(.grey_Light), for: .normal)
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func cameraAction(_ sender: UIButton) {
        self.presenter?.cameraButtonAction()
    }
    
    @IBAction func imageAction(_ sender: UIButton) {
        self.presenter?.photoButtonAction()
    }
    
    @IBAction func publishAction(_ sender: UIButton) {
         ActivityIndicator.sharedInstance.showActivityIndicator()
        creatPostData.postImages = self.imageSelect
        self.navigationController?.popViewController(animated: false, completion: {
            self.delegate?.uploadProgress(data: self.creatPostData)
        })
    }
    
    @IBAction func pollAction(_ sender: UIButton) {
        let pollVC = CreatePollPresenter.createPollModule()
        self.pushViewController(pollVC, true)
    }
}

extension CreatePostViewController: CreatePostViewProtocol, UIImagePickerControllerDelegate {
    func receiveResult() {
        self.imagePicker.setImagePicker(imagePickerType: .gallery, controller: self)
        self.imagePicker.imageCallBack = {
            [weak self] (result) in
            DispatchQueue.main.async {
                switch result{
                case .success(let imageData):
                    let imageIndex = self?.imageSelect.firstIndex(where: {$0 == nil})
                    let image = imageData?.image ?? UIImage()
                    self?.imageSelect.append(image)
                    self?.selectImageCollection.reloadData()
                    self?.publishBtnActive()
                    self?.selectImageCollection.scrollToItem(at: IndexPath(row: ((self?.imageSelect.count ?? 0) - 1), section: 0), at: .left, animated: false)
                case .error(let message):
                    print(message)
                }
            }
        }
    }
    
    func cameraReceiveResult() {
        self.imagePicker.setImagePicker(imagePickerType: .camera, controller: self)
        self.imagePicker.imageCallBack = {
            [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageData):
                    let imageIndex = self?.imageSelect.firstIndex(where: {$0 == nil})
                    let image = imageData?.image ?? UIImage()
                    self?.imageSelect.append(image)
                    self?.selectImageCollection.reloadData()
                    self?.publishBtnActive()
                    self?.selectImageCollection.scrollToItem(at: IndexPath(row: ((self?.imageSelect.count ?? 0) - 1), section: 0), at: .left, animated: false)
                case .error(let message):
                    print(message)
                }
            }
        }
    }
}

extension CreatePostViewController {
    //MARK: Keyboard Functions
    @objc func keyboardWillShow(_ notification : Foundation.Notification){
        let value: NSValue = (notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        var duration = 0.3
        var animation = UIView.AnimationOptions.curveLinear
        if let value  = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            duration = value
        }
        if let value = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            animation = UIView.AnimationOptions(rawValue: value)
        }
        let keyboardSize = value.cgRectValue.size
        self.publishBottomConstraint.constant = keyboardSize.height
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0.0, options: animation, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: {finished in
        })
    }
    
    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        var duration = 0.3
        var animation = UIView.AnimationOptions.curveLinear
        if let value  = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            duration = value
        }
        if let value = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            animation = UIView.AnimationOptions(rawValue: value)
        }
        self.publishBottomConstraint.constant = 0
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0.0, options: animation, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: { finished in
            DispatchQueue.main.async {
            }
        })
    }
}
extension CreatePostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageSelect.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellClass: SelectImageCollectionCell.self, forIndexPath: indexPath)
        cell.selectedRow = indexPath.row
        cell.selectImage.image = self.imageSelect[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height)
    }
}
extension CreatePostViewController: SelectImageCollectionCellDelegate {
    func removeImage(index: Int) {
        self.imageSelect.remove(at: index)
        self.selectImageCollection.reloadData()
        self.publishBtnActive()
    }
}

extension CreatePostViewController : GrowingTextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
        print("updated post text strings----=\(updatedString ?? "")")
        creatPostData.postDescription = updatedString
        if updatedString == " "{
            return false
        } else {
            if self.imageSelect.count > 0 {
                return true
            } else {
                if updatedString?.count ?? 0 > 0 {
                    self.publishButton.isUserInteractionEnabled = true
                    self.publishButton.setTitleColor(UIColor.appColor(.green_main), for: .normal)
                } else {
                    self.publishButton.isUserInteractionEnabled = false
                    self.publishButton.setTitleColor(UIColor.appColor(.grey_Light), for: .normal)
                }
            }
            return true
        }
    }
}
