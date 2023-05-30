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
import Kingfisher

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
    var listPostData =  [PostListDataModel]()
    
    var newlistPostData = [PostListDataModel]()
    var isEditProfile: Bool?
    var selectedPostIndex: Int?
    var reportOrReported: String = AppStrings.reportPost
    
    private let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            UITableView.appearance().isPrefetchingEnabled = false
        }
        self.newsFeedTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        self.presenter?.saveCreatUserData()
        self.fetchPostData(isFromRefreh: false)
        setTableData()
        setTableHeader()
        setTableFooter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pollCreatedSuccess(_:)), name: NSNotification.Name(rawValue: "UpdatePollData"), object: nil)
        setTableData()
        //self.fetchPostData(isFromRefreh: false)
        ActivityIndicator.sharedInstance.hideActivityIndicator()
        
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        self.refreshControl.beginRefreshing()
       fetchPostData(isFromRefreh: true)
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
    
    
    @objc func pollCreatedSuccess(_ sender: Notification) {
        self.updateCreatedPollData()
    }
    
    func fetchPostData(isFromRefreh: Bool) {
        self.refreshControl.tintColor = .green
        self.listPostData.removeAll()
        self.listPostData = []
        self.newsFeedTableView.reloadData()
        if isFromRefreh == true {
            ActivityIndicator.sharedInstance.hideActivityIndicator()
        } else {
            ActivityIndicator.sharedInstance.showActivityIndicator()
        }
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (querySnapshot, err) in
             ActivityIndicator.sharedInstance.hideActivityIndicator()
            if err == nil {
                querySnapshot?.documents.enumerated().forEach({ (index, posts) in
                    let postsData =  posts.data()
                    print("post id is ---\(posts.documentID)")
                    print("total post is --===\(postsData.count)")
                    let allPostData = PostListDataModel(json: postsData)
                    self.listPostData.append(allPostData)
                    print("self.listpostdata---\(self.listPostData.count)")
                })
                self.listPostData.sort(by: {($0.createdAt?.millisecToDate() ?? Date()).compare($1.createdAt?.millisecToDate() ?? Date()) == .orderedDescending })
                self.newsFeedTableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.refreshControl.endRefreshing()
                })
                ActivityIndicator.sharedInstance.hideActivityIndicator()
            } else {
                if let error = err?.localizedDescription {
                    Singleton.shared.showMessage(message: error, isError: .error)
                }
            }
        }
         self.newsFeedTableView.reloadData()
    }
    
    
    func updateCreatedPollData() {
        DispatchQueue.main.async {
            self.listPostData.removeAll()
            self.listPostData = []
            self.newsFeedTableView.reloadData()
        }
        ActivityIndicator.sharedInstance.showActivityIndicator()
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (querySnapshot, err) in
             ActivityIndicator.sharedInstance.hideActivityIndicator()
            if err == nil {
                querySnapshot?.documents.enumerated().forEach({ (index, posts) in
                    let postsData =  posts.data()
                    print("post id is ---\(posts.documentID)")
                    print("total post is --===\(postsData.count)")
                    let allPostData = PostListDataModel(json: postsData)
                    self.listPostData.append(allPostData)
                    print("self.listpostdata---\(self.listPostData.count)")
                })
                self.listPostData.sort(by: {($0.createdAt?.millisecToDate() ?? Date()).compare($1.createdAt?.millisecToDate() ?? Date()) == .orderedDescending })
                self.newsFeedTableView.reloadData()
                self.refreshControl.endRefreshing()
                ActivityIndicator.sharedInstance.hideActivityIndicator()
            } else {
                if let error = err?.localizedDescription {
                    Singleton.shared.showMessage(message: error, isError: .error)
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            let indexpath = IndexPath(row: 1, section: 0)
            let cell = self.newsFeedTableView.cellForRow(at: indexpath) as? PollResultTableCell
            self.newsFeedTableView.reloadRows(at: [indexpath], with: .none)
            cell?.pollTableView?.reloadData()
        })
        
        DispatchQueue.main.async {
            self.newsFeedTableView.reloadData()
           // self.fetchPostData(isFromRefreh: true)
        }
         
    }
    
    func datafetchfortest() {
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (querySnapshot, err) in
            if err == nil {
                querySnapshot?.documents.enumerated().forEach({ (index, posts) in
                    let postsData =  posts.data()
                    let allPostData = PostListDataModel(json: postsData)
                    self.newlistPostData.append(allPostData)
                })
                self.newlistPostData.sort(by: {($0.createdAt?.millisecToDate() ?? Date()).compare($1.createdAt?.millisecToDate() ?? Date()) == .orderedDescending })
            } else {
                if let error = err?.localizedDescription {
                    Singleton.shared.showMessage(message: error, isError: .error)
                }
            }
            self.listPostData = self.newlistPostData
            self.newsFeedTableView.reloadData()
        }
    }
    
    
    
    //MARK: fetch data for particular updation----
    func fetchPostUpdateData(isFromRefreh: Bool) {
        self.listPostData.removeAll()
        if isFromRefreh == true {
         } else {
        }
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (querySnapshot, err) in
            if err == nil {
                querySnapshot?.documents.enumerated().forEach({ (index, posts) in
                    let postsData =  posts.data()
                    print("post id is ---\(posts.documentID)")
                    print("total post is --===\(postsData.count)")
                    let allPostData = PostListDataModel(json: postsData)
                    self.listPostData.append(allPostData)
                    print("self.listpostdata---\(self.listPostData.count)")
                })
                self.listPostData.sort(by: {($0.createdAt?.millisecToDate() ?? Date()).compare($1.createdAt?.millisecToDate() ?? Date()) == .orderedDescending })
                self.newsFeedTableView.reloadData()
                ActivityIndicator.sharedInstance.hideActivityIndicator()
            } else {
                if let error = err?.localizedDescription {
                    Singleton.shared.showMessage(message: error, isError: .error)
                }
            }
        }
         self.newsFeedTableView.reloadData()
        let indexpath = IndexPath(row: self.selectedPostIndex ?? 0, section: 0)
        self.newsFeedTableView.reloadRows(at: [indexpath], with: .none)
        self.newsFeedTableView.reloadData()
        print("total post count is----\(self.listPostData.count)")
    }
    
    //MARK: set table header-----
    func setTableHeader() {
        guard headerView == nil else { return }
        let height: CGFloat = 176
        let view = UIView.initView(view: NewsHeader.self)
        view.delegate = self
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
    
    //MARK: code for share poll----
    func sharePost(items: [Any]) {
        DispatchQueue.main.async {
            let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
            self.present(vc, animated: true)
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
    
    func uploadPostData(data: CreatePostModel) {
        //MARK: code for create poll using firebase ---
        ActivityIndicator.sharedInstance.showActivityIndicator()
        let db = Firestore.firestore()
        let documentsId =  UUID().uuidString
        //MARK: code for upload multiple image upload-----
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        print("create post doc id is--=\(documentsId)")
        print("post image description is -====\(data.postDescription ?? "")")
        //MARK: code for update post -----
        if isEditProfile == true {
            let userPostDocuments =  db.collection("posts").document(data.postId ?? "")
            userPostDocuments.updateData(["author":"\(strings?["name"] ?? "")", "createdAt":"\(data.createdDate ?? "")", "description":"\(data.postDescription ?? "")", "id": "\(data.postId ?? "")", "image": uploadedImageUrls ?? [], "photoURL":"", "profile":"\(strings?["user_profile_pic"] ?? "")", "uid":"\(strings?["uid"] ?? "")", "updatedAt":"\(Date().miliseconds())", "comments":[""], "post_type":"feed", "likedUserList": [String]()]) { error in
                if error == nil {
                    Singleton.shared.showMessage(message: Messages.postEdit, isError: .success)
                    self.fetchPostData(isFromRefreh: false)
                } else {
                    Singleton.shared.showMessage(message: error?.localizedDescription ?? "", isError: .error)
                }
            }
        } else {
            //MARK: code for create post--------
            db.collection("posts").document(documentsId).setData(["author":"\(strings?["name"] ?? "")", "createdAt":"\(Date().miliseconds())", "description":"\(data.postDescription ?? "")", "id": "\(documentsId)", "image": uploadedImageUrls ?? [], "photoURL":"", "profile":"\(strings?["user_profile_pic"] ?? "")", "uid":"\(strings?["uid"] ?? "")", "updatedAt":"", "comments":[], "post_type":"feed", "likedUserList": [String](), "reportedUserList":[String]()], merge: true) { error in
                if error == nil {
                    Singleton.shared.showMessage(message: Messages.postCreated, isError: .success)
                    self.fetchPostData(isFromRefreh: false)
                } else {
                    Singleton.shared.showMessage(message: error?.localizedDescription ?? "", isError: .error)
                }
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
        return (self.listPostData.count + 1)
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
        } else if listPostData[indexPath.row - 1].post_type == "poll" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.pollResultTableCell, for: indexPath) as? PollResultTableCell else{return UITableViewCell()}
            let pollData = self.listPostData.filter{( $0.post_type == "poll")}
            cell.setPollCellData(data: listPostData[indexPath.row - 1], index: indexPath.row)
            
            cell.delegate = self
            cell.currentIndex = indexPath.row - 1
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.newsFeedTableCell, for: indexPath) as? NewsFeedTableCell else {return UITableViewCell()}
            cell.delegate = self
            let feedData = self.listPostData.filter({$0.post_type == "feed"})
            cell.setCellPostData(data: listPostData[indexPath.row - 1])
            cell.awakeFromNib()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPostIndex = indexPath.row
        print("selected index ----\(self.selectedPostIndex)")
    }
    
    func reportPost(data: PostListDataModel, index: Int) {
        let alert = UIAlertController(title: "Report post", message: "Are you want to report this post?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
            let db = Firestore.firestore()
            var reportedUserList = data.reportedUserList
            reportedUserList?.append(UserDefaultsCustom.currentUserId)
            let userPostCollection = db.collection("posts").document(data.id ?? "")
            userPostCollection.updateData(["reportedUserList": reportedUserList ?? []]) { error in
                if error == nil {
                    let newReportPostdata = PostListDataModel()
                    newReportPostdata.reportedUserList = reportedUserList
                    self.listPostData[index] = newReportPostdata
                    self.newsFeedTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    Singleton.shared.showMessage(message: "Reported successfully.", isError: .success)
                } else {
                    if let error = error {
                        Singleton.shared.showMessage(message: error.localizedDescription, isError: .error)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            print("no action called")
        }))
        self.present(alert, animated: true, completion: nil)
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
        let createPostVc = CreatePostPresenter.createPostModule(delegate: self, selectedImage: [], data: nil, isEditPost: false)
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
                        let vc = CreatePostPresenter.createPostModule(delegate: self, selectedImage: [image], data: nil, isEditPost: false)
                        vc.hidesBottomBarWhenPushed = true
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
                        let vc = CreatePostPresenter.createPostModule(delegate: self, selectedImage: [image], data: nil, isEditPost: false)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                case .error(let message):
                    print("error message\(message)")
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
    func likePostData(data: PostListDataModel, isLiked: Bool, index: Int) {
        let db = Firestore.firestore()
        var userPostLikedData = data.likedUserList
        if isLiked == true {
            userPostLikedData?.append(UserDefaultsCustom.currentUserId)
            var newDataForLikeUpdate = PostListDataModel()
            newDataForLikeUpdate.likedUserList = userPostLikedData
            let userPostCollection = db.collection("posts").document(data.id ?? "")
            userPostCollection.updateData(["likedUserList": userPostLikedData ?? []]) { error in
                if error == nil {
                    print("like updated")
                    //self.fetchPostData(isFromRefreh: true)
                    self.newsFeedTableView.beginUpdates()
                    let reloadIndex = IndexPath(row: self.selectedPostIndex ?? 0, section: 0)
                    self.listPostData[index] = newDataForLikeUpdate
                    self.newsFeedTableView.reloadRows(at: [reloadIndex], with: .none)
                    self.newsFeedTableView.endUpdates()
                    //Singleton.shared.showMessage(message: "Liked successf", isError: .success)
                } else {
                    if let error  =  error {
                        print("error in case of like post---\(error)")
                        Singleton.shared.showErrorMessage(error: error.localizedDescription, isError: .error)
                    }
                    print("like not updated")
                }
            }
        } else {
            userPostLikedData?.remove(element: UserDefaultsCustom.currentUserId)
            var newDataForLikeUpdate = PostListDataModel()
            newDataForLikeUpdate.likedUserList = userPostLikedData
            let userPostCollection = db.collection("posts").document(data.id ?? "")
            userPostCollection.updateData(["likedUserList": userPostLikedData ?? []]) { (error) in
                if error == nil {
                    print("like removed updated")
                    //                    self.fetchPostData(isFromRefreh: true)
                    self.newsFeedTableView.beginUpdates()
                    let reloadIndex = IndexPath(row: self.selectedPostIndex ?? 0, section: 0)
                    self.listPostData[index] = newDataForLikeUpdate
                    self.newsFeedTableView.reloadRows(at: [reloadIndex], with: .none)
                    self.newsFeedTableView.endUpdates()
                } else {
                    print("like removed not updated")
                }
            }
        }//likeBtn.setTitle("1", for: .selected)
    }
    
    func commmnetsPost(data: PostListDataModel, isCommented: Bool, index: Int) {
        let vc = CommentsViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.listPostData = self.listPostData[index - 1]
        self.pushViewController(vc, false)
    }
    
    func moreButton(data: PostListDataModel, index: Int) {
        if UserDefaultsCustom.currentUserId == data.uid {
            //MARK: edit post case---
            let alert = UIAlertController(title: AppStrings.more, message: AppStrings.selectOption, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: AppStrings.editPost, style: .default , handler:{ (UIAlertAction)in
                print("edit post called.")
                let editPostVc = CreatePostPresenter.createPostModule(delegate: self, selectedImage: [], data: data, isEditPost: true)
                self.pushViewController(editPostVc, false)
            }))
            alert.addAction(UIAlertAction(title: AppStrings.delete, style: .destructive , handler:{ (UIAlertAction)in
                print("delete post called.")
                let db = Firestore.firestore()
                print("post id for delete post---\(data.id ?? "")")
                print("post description for delete post----\(data.postDescription ?? "")")
                db.collection("posts").document(data.id ?? "").delete() { err in
                    if let err = err {
                        Singleton.shared.showMessage(message: err.localizedDescription, isError: .error)
                    } else {
                        self.listPostData.removeAll()
                        self.fetchPostData(isFromRefreh: false)
                        Singleton.shared.showMessage(message: "Post deleted successfully.", isError: .success)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: AppStrings.dismiss, style: .cancel, handler:{ (UIAlertAction)in
                print("dismiss called.")
            }))
            self.present(alert, animated: true, completion: {
                print("present complition callled")
            })
        } else {
            let alert = UIAlertController(title: AppStrings.more, message: AppStrings.selectOption, preferredStyle: .actionSheet)
            data.reportedUserList?.forEach({ user_id in
                if user_id == UserDefaultsCustom.currentUserId {
                    reportOrReported = "Reported"
                    return
                } else {
                    reportOrReported = AppStrings.reportPost
                }
            })
            alert.addAction(UIAlertAction(title: reportOrReported, style: .default , handler:{ (UIAlertAction)in
                print("report post called.")
                if (data.reportedUserList?.count ?? 0) == 0 {
                    self.reportPost(data: data, index: index)
                } else {
                    data.reportedUserList?.forEach({ user_id in
                        if user_id == UserDefaultsCustom.currentUserId{
                            return
                        } else {
                            self.reportPost(data: data, index: index)
                        }
                        
                    })
                }
            }))
            alert.addAction(UIAlertAction(title: AppStrings.dismiss, style: .cancel, handler:{ (UIAlertAction)in
                print("dismiss called.")
            }))
            self.present(alert, animated: true, completion: {
            })
        }
    }
  
    
    func sharePost(data: PostListDataModel, postImage: UIImage) {
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        let name = strings?["name"] ?? ""
        var addressText = "\(name) shared poll file:"
        let postTitle = data.postDescription ?? ""
        addressText += "\n\n\(postTitle)"
        let pollOptions =  data.poll_options
        for i in 0..<(data.poll_options?.count ?? 0) {
            addressText += "\n\nOption\(i)\(pollOptions?[i] ?? "")"
        }
        self.sharePost(items: [postImage])
    }
}

extension NewsFeedViewController: PollResultTableCellDelegate {
    func likePostDatas(data: PostListDataModel, isLiked: Bool, index: Int) {
        let db = Firestore.firestore()
        var userPostLikedData = data.likedUserList
        if isLiked == true {
            userPostLikedData?.append(UserDefaultsCustom.currentUserId)
            var newDataForLikeUpdate = PostListDataModel()
            newDataForLikeUpdate.likedUserList = userPostLikedData
            let userPostCollection = db.collection("posts").document(data.id ?? "")
            userPostCollection.updateData(["likedUserList": userPostLikedData ?? []]) { (error) in
                if error == nil {
                    print("like updated")
                    self.newsFeedTableView.beginUpdates()
                    let reloadIndex = IndexPath(row: self.selectedPostIndex ?? 0, section: 0)
                    self.listPostData[index] = newDataForLikeUpdate
                    self.newsFeedTableView.reloadRows(at: [reloadIndex], with: .none)
                    self.newsFeedTableView.endUpdates()
                } else {
                    print("like not updated")
                }
            }
        } else {
            userPostLikedData?.remove(element: UserDefaultsCustom.currentUserId)
            let newDataForLikeUpdate = PostListDataModel()
            newDataForLikeUpdate.likedUserList = userPostLikedData
            let userPostCollection = db.collection("posts").document(data.id ?? "")
            userPostCollection.updateData(["likedUserList": userPostLikedData ?? []]) { (error) in
                if error == nil {
                    print("like removed updated")
                    self.newsFeedTableView.beginUpdates()
                    let reloadIndex = IndexPath(row: self.selectedPostIndex ?? 0, section: 0)
                    self.listPostData[index] = newDataForLikeUpdate
                    self.newsFeedTableView.reloadRows(at: [reloadIndex], with: .none)
                    self.newsFeedTableView.endUpdates()
                } else {
                    print("like removed not updated")
                }
            }
        }
    }
    
    func voteInPoll(data: PostListDataModel, isVodeted: Bool, selectedIndex: Int, currentPostIndex: Int) {
        let db = Firestore.firestore()
        let userPostCollection = db.collection("posts").document(data.id ?? "")
        print("selected index is -----\(selectedIndex)")
        var VotedUserList = [String]()
        VotedUserList = data.voted_user_list ?? []
        VotedUserList.append(UserDefaultsCustom.currentUserId)
        var votedOptionArray = [Int]()
        for i in 0..<(data.selectedAnswerCount?.count ?? 0) {
            if i == selectedIndex {
                votedOptionArray.append((data.selectedAnswerCount?[i] ?? 0) + 1)
            } else {
                votedOptionArray.append(data.selectedAnswerCount?[i] ?? 0)
            }
        }
         
        let newPollData = PostListDataModel()
        newPollData.voted_user_list = VotedUserList
        newPollData.selectedAnswerCount = votedOptionArray
        newPollData.author = data.author
        newPollData.id = data.id
        newPollData.createdAt =  data.createdAt
        newPollData.uid =  data.uid
        newPollData.comments = data.comments
        newPollData.likedUserList = data.likedUserList
        newPollData.poll_options =  data.poll_options
        newPollData.poll_title = data.poll_title
        newPollData.post_type = data.post_type
        newPollData.selectedAnswer = data.selectedAnswer
        newPollData.updatedAt = data.updatedAt
        newPollData.json = data.json
        newPollData.profileImage = data.profileImage
        
        userPostCollection.updateData(["selectedAnswer": [], "selectedAnswerCount": votedOptionArray, "voted_user_list": VotedUserList, "selectedAnserIndex": selectedIndex]) { error in
            if error == nil {
                Singleton.shared.showMessage(message: "voted", isError: .success)
                DispatchQueue.main.async {
                    let indexpath = IndexPath(row: currentPostIndex + 1 , section: 0)
                    self.listPostData[currentPostIndex] = newPollData
                    self.newsFeedTableView.reloadRows(at: [indexpath], with: .none)
                }
            } else {
                if let error = error {
                    Singleton.shared.showMessage(message: error.localizedDescription , isError: .error)
                }
            }
        }
    }
    
    func commmnetsPoll(data: PostListDataModel, isCommented: Bool, index: Int) {
        let vc = CommentsViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.listPostData = self.listPostData[index - 1]
        self.pushViewController(vc, false)
    }
    
    func pollMoreButton(data: PostListDataModel, index: Int) {
        if UserDefaultsCustom.currentUserId == data.uid {
            let alert = UIAlertController(title: AppStrings.more, message: AppStrings.selectOption, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: AppStrings.delete, style: .destructive , handler:{ (UIAlertAction)in
                print("delete post called.")
                let db = Firestore.firestore()
                print("documnets id for deletion---\(data.id ?? "")")
                print("doc data------\(data.poll_title)")
                print("hello poll data is----\(data.poll_options?.count ?? 0)")
                for i in 0..<(data.poll_options?.count ?? 0) {
                    print("poll optionsa----\(data.poll_options?[i] ?? "")")
                }
                db.collection("posts").document(data.id ?? "").delete() { err in
                    if err == nil {
                        self.fetchPostData(isFromRefreh: false)
                        Singleton.shared.showMessage(message: "Post deleted successfully.", isError: .success)
                    } else {
                        if let err = err {
                            Singleton.shared.showMessage(message: err.localizedDescription, isError: .error)
                        }
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: AppStrings.dismiss, style: .cancel, handler:{ (UIAlertAction)in
                print("dismiss post called.")
            }))
            self.present(alert, animated: true, completion: {
            })
        } else {
            let alert = UIAlertController(title: AppStrings.more, message: AppStrings.selectOption, preferredStyle: .actionSheet)
            data.reportedUserList?.forEach({ user_id in
                if user_id == UserDefaultsCustom.currentUserId {
                    reportOrReported = "Reported"
                    return
                } else {
                    reportOrReported = AppStrings.reportPost
                }
            })
            alert.addAction(UIAlertAction(title: reportOrReported, style: .default , handler:{ (UIAlertAction)in
                print("report poll called.")
                if (data.reportedUserList?.count ?? 0) == 0 {
                    self.reportPost(data: data, index: index)
                } else {
                    data.reportedUserList?.forEach({ user_id in
                        if user_id == UserDefaultsCustom.currentUserId{
                            return
                        } else {
                            self.reportPost(data: data, index: index)
                        }
                    })
                }
            }))
            alert.addAction(UIAlertAction(title: AppStrings.dismiss, style: .cancel, handler:{ (UIAlertAction)in
                print("dismiss post called.")
            }))
            self.present(alert, animated: true, completion: {
            })
        }
    }
    
    func sharePoll(data: PostListDataModel, pollImage: UIImage) {
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        var name = strings?["name"] ?? ""
        var addressText = "\(name) shared poll file:"
        let pollTitle = "Poll title:-\(data.poll_title ?? "")"
        addressText += "\n\n\(pollTitle)"
        let pollOptions =  data.poll_options
        for i in 0..<(data.poll_options?.count ?? 0) {
            addressText += "\n\nOption:-\(i + 1)\(pollOptions?[i] ?? "")"
        }
        self.sharePost(items: [pollImage])
    }
}

extension NewsFeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.newsFeedTableView.setStrachyHeader()
    }
}

extension NewsFeedViewController: NewsFeedViewProtocol {}

extension NewsFeedViewController: CreatePostUploadDelegate {
    func uploadProgress(data: CreatePostModel, isEditProfile: Bool) {
        self.isEditProfile = isEditProfile
        self.data = data
        self.uploadDataForPost(data: data)
        self.newsFeedTableView.reload(row: 0)
    }
}

extension NewsFeedViewController: NewsHeaderProtocol {
    func notificationBtnAction() {
        let notificationVc = NotificationPresenter.createNotificationModule()
        notificationVc.hidesBottomBarWhenPushed = true
        self.pushViewController(notificationVc, false)
    }
}

