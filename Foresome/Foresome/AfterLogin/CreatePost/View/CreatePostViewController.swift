//
//  CreatePostViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 05/04/23.
//

import UIKit

class CreatePostViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var imageSelectButton: UIButton!
    @IBOutlet weak var selectImageCollection: UICollectionView!
    @IBOutlet weak var publishBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pollBtn: UIButton!
    
    @IBOutlet weak var cameraBtn: UIButton!
    var presenter: CreatePostPresenterProtocol?
    var imageSelect: [UIImage?] = []
    var imagePicker = GetImageFromPicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboard()
        self.setCellData()
    }
    func setCellData() {
        self.selectImageCollection.delegate = self
        self.selectImageCollection.dataSource = self
        self.selectImageCollection.register(cellClass: SelectImageCollectionCell.self)
    }
    
    func setKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification , object:nil)
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
    }
    
    @IBAction func pollAction(_ sender: UIButton) {
        let vc = CreatePollViewController()
        self.pushViewController(vc, true)
    }
}
extension CreatePostViewController: CreatePostViewProtocol, UIImagePickerControllerDelegate {
    func receiveResult() {
        self.imagePicker.setImagePicker(imagePickerType: .both, controller: self)
        self.imagePicker.imageCallBack = {
            
            [weak self] (result) in
            DispatchQueue.main.async {
                switch result{
                case .success(let imageData):
                    let imageIndex = self?.imageSelect.firstIndex(where: {$0 == nil})
                    let image = imageData?.image ?? UIImage()
                    self?.imageSelect.append(image)
                    self?.selectImageCollection.reloadData()
                    
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
                switch result{
                case .success(let imageData):
                    let imageIndex = self?.imageSelect.firstIndex(where: {$0 == nil})
                    let image = imageData?.image ?? UIImage()
                case .error(let message):
                    print(message)
                }
            }
        }
    }
}

extension CreatePostViewController{
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
    }
}
