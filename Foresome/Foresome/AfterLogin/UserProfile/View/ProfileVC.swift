//
//  ProfileVC.swift
//  Foresome
//
//  Created by Piyush Kumar on 12/04/23.
//

import UIKit

class ProfileVC: UIViewController {
    
    
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
}
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.setData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(cell: ChangeProfilePictureTableCell.self, for: indexPath)
            cell.changeProfileButton.setTitle(setData[indexPath.row].title, for: .normal)
            cell.profilePictureDisplay.image = setData[indexPath.row].icon
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
        case .editProfile :
            let vc = EditProfilePresenter.createEditProfileModule()
            self.pushViewController(vc, true)
        case .notificationSettings :
            let cell = tableView.dequeueReusableCell(cell: ProfileTableCell.self, for: indexPath)
            cell.toggleButton.isUserInteractionEnabled = true
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
extension ProfileVC: UserProfileViewProtocol {
    
}
