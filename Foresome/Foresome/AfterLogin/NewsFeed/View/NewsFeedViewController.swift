//
//  NewsFeedViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
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
import FirebaseStorage

class NewsFeedViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var newsFeedTableView: StrachyHeaderTable!
    
    var presenter: NewsFeedPresenterProtocol?
    var selectedOption: Int?
    var imagePicker = GetImageFromPicker()
    var imageSelect: [UIImage?] = []
    weak var headerView: NewsHeader?
    var data: CreatePostModel?
    var uploadedImageUrls: [String]? = []
    var progressCount: Float = 0.0
    var totalUploadedImage: Int = 0
    var confirmProgress: Int = 0
    var uploadCount = 0
    
    var imageUplaodTask : StorageUploadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.saveCreatUserData()
       // fetchPostData()
        setTableData()
        setTableFooter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // super.viewWillAppear(animated)
        setTableData()
        ActivityIndicator.sharedInstance.hideActivityIndicator()
    }
    
    func setTableData() {
        self.newsFeedTableView.delegate = self
        self.newsFeedTableView.dataSource = self
        newsFeedTableView.register(cellClass: NewsFeedTableCell.self)
        newsFeedTableView.register(cellClass: TalkAboutTableCell.self)
        newsFeedTableView.register(cellClass: PollResultTableCell.self)
        newsFeedTableView.contentInset = UIEdgeInsets(top: -28, left: 0, bottom: 0, right: 0)
        setTableHeader()
        updatetable()
    }
    
    //MARK: code for fetch data of posts------
    
    func updatetable() {
        self.newsFeedTableView.reloadData()
    }
    
    func fetchPostData() {
        ActivityIndicator.sharedInstance.showActivityIndicator()
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (querySnapshot, err) in
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            querySnapshot?.documents.enumerated().forEach({ (index, posts) in
                let postsData =  posts.data()
                print("posts is --===\(postsData)")
                print("post data is-===\(posts) ")
                print("post id is ---\(posts.documentID)")
            })
        }
    }
    
    //MARK: set table header-----
    func setTableHeader() {
        guard headerView == nil else { return }
        let height: CGFloat = 176
        let view = UIView.initView(view: NewsHeader.self)
        view.setHeaderData()
        self.newsFeedTableView.setStrachyHeader(header: view, height: height)
    }
    
    func setTableFooter() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: newsFeedTableView.frame.width, height: 24))
        customView.backgroundColor = UIColor.appColor(.white_Light)
        newsFeedTableView.tableFooterView = customView
    }
    
    //MARK: code for upload data for create post------
    func uploadDataForPost(data:CreatePostModel) {
        if (data.postImages?.count ?? 0) > 0 {
            for i in 0..<(data.postImages?.count ?? 0) {
                uploadimages(image: data.postImages?[i] ?? UIImage())
            }
        } else {
            self.uploadPostData(data: self.data ?? CreatePostModel())
        }
    }
    
    //MARK: code for upload image one by one ---
    func uploadimages(image: UIImage) {
        let storageRef = Storage.storage().reference()
        var data = Data()
        data = image.pngData() ?? Data()
        let date = Date()
        let riversRef = storageRef.child("images/IMG_\(date.miliseconds().toInt).png")
        imageUplaodTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            print(metadata)
            riversRef.downloadURL { (url,error) in
                guard let downloadUrl = url else {
                    return
                }
                self.uploadCount += 1
                let indexpath = IndexPath(row: 0, section: 0)
                let cell = self.newsFeedTableView.cellForRow(at: indexpath) as? TalkAboutTableCell
                self.uploadedImageUrls?.append(downloadUrl.absoluteString)
                if self.uploadCount == self.data?.postImages?.count ?? 0 {
                    print("all images uploaded successfully")
                    self.uploadPostData(data: self.data ?? CreatePostModel())
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.newsFeedTableView.beginUpdates()
                        cell?.postingImageView.isHidden = true
                        self.newsFeedTableView.endUpdates()
                        self.crealOldUploadedData()
                    })
                    ActivityIndicator.sharedInstance.hideActivityIndicator()
                } else {
                    cell?.postingImageView.isHidden = false
                }
                self.totalUploadedImage = self.uploadedImageUrls?.count ?? 0
                self.progressCount = Float(Double(self.totalUploadedImage) / Double(self.data?.postImages?.count ?? 0))
                cell?.setCellDataAndProgress(data: self.data ?? CreatePostModel(), progress: self.progressCount, uploadedCount: self.totalUploadedImage)
            }
        }
        
        imageUplaodTask?.observe(.progress) { data in
            if Float(data.progress?.fractionCompleted.roundTo(places: 2) ?? 0.0) == 1.0 {
            } else {
            }
        }
        
        imageUplaodTask?.observe(.success) { data in
        
        }
        
        imageUplaodTask?.observe(.failure) { data in
            
        }
    }
    
    func uploadPostData(data:CreatePostModel) {
        //MARK: code for create poll using firebase ---
        ActivityIndicator.sharedInstance.showActivityIndicator()
        let db = Firestore.firestore()
        let documentsId =  UUID().uuidString
        //MARK: code for upload multiple image upload-----
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        let createdDate = Date().miliseconds()
        db.collection("posts").document(documentsId).setData(["author":"\(strings?["name"] ?? "")", "createdAt":"\(Date().miliseconds())", "description":"", "id": "\(documentsId)", "image": uploadedImageUrls ?? [], "photoURL":"", "profile":"\(strings?["user_profile_pic"] ?? "")", "uid":"\(strings?["uid"] ?? "")", "updatedAt":"", "comments":[""], "post_type":"feed"], merge: true) { error in
            if error == nil {
                Singleton.shared.showMessage(message: Messages.postCreated, isError: .success)
            } else {
                Singleton.shared.showMessage(message: error?.localizedDescription ?? "", isError: .error)
            }
        }
        ActivityIndicator.sharedInstance.hideActivityIndicator()
    }
    
    func crealOldUploadedData() {
        self.data = nil
        self.uploadCount = 0
        self.data?.postImages?.removeAll()
        self.uploadedImageUrls = []
        self.progressCount = 0.0
        self.totalUploadedImage = 0
        self.confirmProgress = 0
    }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.createPostTableCell, for: indexPath) as? TalkAboutTableCell else {return UITableViewCell()}
            cell.setProfileData()
            if let data = self.data {
                cell.setCellDataAndProgress(data: data, progress: progressCount, uploadedCount: totalUploadedImage)
            }
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.pollResultTableCell, for: indexPath) as? PollResultTableCell else{return UITableViewCell()}
            cell.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.newsFeedTableCell, for: indexPath) as? NewsFeedTableCell else {return UITableViewCell()}
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension NewsFeedViewController: TalkAboutTableCellDelegate, UIImagePickerControllerDelegate {
    //MARK: code for cancel image uploaded task----
    func cancelAction() {
        print("cancel action callled")
        imageUplaodTask?.cancel()
        self.uploadPostData(data: self.data ?? CreatePostModel())
        self.data = nil
        self.uploadedImageUrls = []
        self.progressCount = 0.0
        self.totalUploadedImage = 0
        self.confirmProgress = 0
    }
    //MARK: code for create new post----
    func createPost() {
        let createPostVc = CreatePostPresenter.createPostModule(delegate: self, selectedImage: [])
        createPostVc.hidesBottomBarWhenPushed = true
        self.pushViewController(createPostVc, true)
    }
    //MARK: code for create post with not description----
    func cameraBtnAction() {
        self.imagePicker.setImagePicker(imagePickerType: .camera, controller: self)
        self.imagePicker.imageCallBack = {
            [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageData):
                    let imageIndex = self?.imageSelect.firstIndex(where: {$0 == nil})
                    let image = imageData?.image ?? UIImage()
                    self?.dismiss(animated: false) {
                        let vc = CreatePostPresenter.createPostModule(delegate: self, selectedImage: [image])
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                case .error(let message):
                    print(message)
                    Singleton.shared.showMessage(message: message, isError: .error)
                }
            }
        }
    }
    //MARK: create post only using image from gallery---
    func photoBtnAction() {
        self.imagePicker.setImagePicker(imagePickerType: .gallery, controller: self)
        self.imagePicker.imageCallBack = {
            [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageData):
                    let imageIndex = self?.imageSelect.firstIndex(where: {$0 == nil})
                    let image = imageData?.image ?? UIImage()
                    self?.dismiss(animated: false) {
                        let vc = CreatePostPresenter.createPostModule(delegate: self, selectedImage: [image])
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                case .error(let message):
                    print(message)
                    Singleton.shared.showMessage(message: message, isError: .error)
                }
            }
        }
    }
    
    //MARK: code for create new poll----
    func pollBtnAction() {
        let pollVc = CreatePollPresenter.createPollModule()
        pollVc.hidesBottomBarWhenPushed = true
        self.pushViewController(pollVc, true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension NewsFeedViewController: NewsFeedTableCellDelegate {
    func moreButton() {
        let alert = UIAlertController(title: AppStrings.more, message: AppStrings.selectOption, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: AppStrings.reportPost, style: .default , handler:{ (UIAlertAction)in
        }))
        alert.addAction(UIAlertAction(title: AppStrings.delete, style: .destructive , handler:{ (UIAlertAction)in
        }))
        alert.addAction(UIAlertAction(title: AppStrings.dismiss, style: .cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
        })
    }
}

extension NewsFeedViewController: PollResultTableCellDelegate {
    func PollMoreButton() {
        let alert = UIAlertController(title: AppStrings.more, message: AppStrings.selectOption, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: AppStrings.reportPost, style: .default , handler:{ (UIAlertAction)in
        }))
        alert.addAction(UIAlertAction(title: AppStrings.delete, style: .destructive , handler:{ (UIAlertAction)in
        }))
        alert.addAction(UIAlertAction(title: AppStrings.dismiss, style: .cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
        })
    }
}

extension NewsFeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.newsFeedTableView.setStrachyHeader()
    }
}

extension NewsFeedViewController: NewsFeedViewProtocol {
    
}

extension NewsFeedViewController: CreatePostUploadDelegate {
    func uploadProgress(data: CreatePostModel) {
        self.data = data
        self.uploadDataForPost(data: data)
        self.newsFeedTableView.reload(row: 0)
    }
}

