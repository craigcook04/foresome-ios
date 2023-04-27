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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.saveCreatUserData()
        // fetchPostData()
        setTableData()
        setTableFooter()
    }
    
    func setTableData() {
        self.newsFeedTableView.delegate = self
        self.newsFeedTableView.dataSource = self
        newsFeedTableView.register(cellClass: NewsFeedTableCell.self)
        newsFeedTableView.register(cellClass: TalkAboutTableCell.self)
        newsFeedTableView.register(cellClass: PollResultTableCell.self)
        newsFeedTableView.contentInset = UIEdgeInsets(top: -28, left: 0, bottom: 0, right: 0)
        setTableHeader()
    }
    
    //MARK: code for fetch data of posts------
    func fetchPostData() {
        ActivityIndicator.sharedInstance.showActivityIndicator()
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (querySnapshot, err) in
            ActivityIndicator.sharedInstance.hideActivityIndicator()
            querySnapshot?.documents.enumerated().forEach({ (index,document) in
                let tournament =  document.data()
                print("post id is ---\(document.documentID)")
                print("post data is ----\(tournament)")
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
        //        self.scrollViewDidScroll(self.newsFeedTableView)
    }
    
    func setTableFooter() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: newsFeedTableView.frame.width, height: 24))
        customView.backgroundColor = UIColor.appColor(.white_Light)
        newsFeedTableView.tableFooterView = customView
    }
    //MARK: code for upload data for create post------
    func uploadDataForPost(data:CreatePostModel) {
        print("image data count is --=\(data.postImages?.count)")
        print("post description is --=\(data.postDescription)")
        
        for i in 0..<(data.postImages?.count ?? 0) {
            uploadimages(image: data.postImages?[i] ?? UIImage())
        }
    }
    
    //MARK: code for upload image one by one ---
    func uploadimages(image: UIImage) {
        let storageRef = Storage.storage().reference()
        var data = Data()
        data = image.pngData() ?? Data()
        let date = Date()
        let riversRef = storageRef.child("images/IMG_\(date.miliseconds().toInt).png")
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            let size = metadata.size
            riversRef.downloadURL { (url,error) in
                guard let downloadUrl = url else {
                    return
                }
                self.uploadedImageUrls?.append(downloadUrl.absoluteString)
                self.newsFeedTableView.beginUpdates()
                self.totalUploadedImage = self.uploadedImageUrls?.count ?? 0
                self.progressCount = Float(Double(self.totalUploadedImage) / Double(self.data?.postImages?.count ?? 0))
                self.newsFeedTableView.reloads(rows: [0])
                self.newsFeedTableView.endUpdates()
                let indexpath = IndexPath(row: 0, section: 0)
                let cell = self.newsFeedTableView.cellForRow(at: indexpath) as? TalkAboutTableCell
                cell?.setCellDataAndProgress(data: self.data ?? CreatePostModel(), progress: self.progressCount, uploadedCount: self.totalUploadedImage)
                if self.totalUploadedImage == (self.data?.postImages?.count ?? 0) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.newsFeedTableView.beginUpdates()
                        cell?.postingImageView.isHidden = true
                        self.newsFeedTableView.endUpdates()
                    })
                } else {
                    cell?.postingImageView.isHidden = false
                }
                //self.newsFeedTableView.reloads(rows: [0])
            }
        }
        
        uploadTask.observe(.progress) { data in
            if Float(data.progress?.fractionCompleted.roundTo(places: 2) ?? 0.0) == 1.0 {
                //                self.confirmProgress = self.confirmProgress + 1
                //                self.totalUploadedImage = self.confirmProgress
                //                self.progressCount = Float(self.confirmProgress / (self.data?.postImages?.count ?? 0))
                
                //                self.tableView?.beginUpdates()
                //                self.postingImageView.isHidden = true
                //                self.tableView?.endUpdates()
            } else {
                //                self.postingImageView.isHidden = false
            }
        }
        
        uploadTask.observe(.success) { data in
            print("success called.")
        }
        
        uploadTask.observe(.failure) { data in
            print("failure called.")
        }
    }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TalkAboutTableCell", for: indexPath) as? TalkAboutTableCell else {return UITableViewCell()}
            if let data = self.data {
                //cell.setCellProgressData(data: data)
                cell.setCellDataAndProgress(data: data, progress: progressCount, uploadedCount: totalUploadedImage)
            }
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PollResultTableCell", for: indexPath) as? PollResultTableCell else{return UITableViewCell()}
            cell.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableCell", for: indexPath) as? NewsFeedTableCell else {return UITableViewCell()}
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension NewsFeedViewController: TalkAboutTableCellDelegate, UIImagePickerControllerDelegate {
    func cancelAction() {
        print("cancel action callled")
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
                    //self?.presenter?.createPost(json: JSON())
                    //self?.presenter?.createPost()
                    self?.presenter?.creatNewPost(selectedimage: image.convertImageToBase64String())
                    self?.presenter?.uploadimage(image: image)
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
                    self?.presenter?.creatNewPost(selectedimage: image.convertImageToBase64String())
                    self?.presenter?.uploadimage(image: image)
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
        let alert = UIAlertController(title: "More", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report post", style: .default , handler:{ (UIAlertAction)in
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: {
        })
    }
}
extension NewsFeedViewController: PollResultTableCellDelegate {
    func PollMoreButton() {
        let alert = UIAlertController(title: "More", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report post", style: .default , handler:{ (UIAlertAction)in
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
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
        print("data after pop a view controller...")
        print("post data image count--\(data.postImages?.count)")
        print("post data description is -==\(data.postDescription)")
        self.data = data
        self.uploadDataForPost(data: data)
        self.newsFeedTableView.reload(row: 0)
    }
}


