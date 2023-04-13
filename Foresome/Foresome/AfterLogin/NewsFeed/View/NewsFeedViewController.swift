//
//  NewsFeedViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 03/04/23.
//

import UIKit

class NewsFeedViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var newsFeedTableView: UITableView!
    
    var presenter: NewsFeedPresenterProtocol?
    var selectedOption: Int?
    var imagePicker = GetImageFromPicker()
    var imageSelect: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableData()
        setTableFooter()
        let headerView = NewsHeader(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 176))
             headerView.imageView.image = UIImage(named: "irina-iriser-1379640-2")
               self.newsFeedTableView.tableHeaderView = headerView
    }
    
    func setTableFooter() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: newsFeedTableView.frame.width, height: 24))
        customView.backgroundColor = UIColor.appColor(.white_Light)
        newsFeedTableView.tableFooterView = customView
    }
    
    func setTableData() {
        self.newsFeedTableView.delegate = self
        self.newsFeedTableView.dataSource = self
        newsFeedTableView.register(cellClass: NewsFeedTableCell.self)
        newsFeedTableView.register(cellClass: TalkAboutTableCell.self)
        newsFeedTableView.register(cellClass: PollResultTableCell.self)
        newsFeedTableView.contentInset = UIEdgeInsets(top: -28, left: 0, bottom: 0, right: 0)
       
    }
}
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TalkAboutTableCell", for: indexPath) as? TalkAboutTableCell else {return UITableViewCell()}
            cell.delegate = self
            return cell
        }else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PollResultTableCell", for: indexPath) as? PollResultTableCell else{return UITableViewCell()}
            cell.delegate = self
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableCell", for: indexPath) as? NewsFeedTableCell else {return UITableViewCell()}
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView.getFromNib(className: NewsHeader.self)
        return sectionHeader
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 200
//    }
}
extension NewsFeedViewController: TalkAboutTableCellDelegate, UIImagePickerControllerDelegate {
  
    func createPost() {
        let vc = CreatePostPresenter.createPostModule()
        self.tabBarController?.tabBar.isHidden = true
        self.pushViewController(vc, true)
    }
    func cameraBtnAction() {
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
    
    func photoBtnAction() {
        self.imagePicker.setImagePicker(imagePickerType: .both, controller: self)
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
    
    func pollBtnAction() {
        let vc = CreatePollViewController()
        self.pushViewController(vc, true)
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
            print("User click Approve button")
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
extension NewsFeedViewController: PollResultTableCellDelegate {
    func PollMoreButton() {
        let alert = UIAlertController(title: "More", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report post", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
extension NewsFeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.newsFeedTableView.tableHeaderView as? NewsHeader
        headerView?.scrollViewDidScroll(scrollView: scrollView)
    }
}
extension NewsFeedViewController: NewsFeedViewProtocol {
    
}

