//
//  SkillLevelViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 23/03/23.
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

enum SkillData {
    case highySkilled
    case mediumSkilled
    case lowerSkilled
    
    var description: String {
        switch self {
        case .highySkilled:
            return "Highly skilled"
        case .mediumSkilled:
            return "Medium skilled"
        case .lowerSkilled:
            return "Lower skilled"
        }
    }
}

class SkillLevelViewController: UIViewController, UserSkillViewProtocol {
    
    @IBOutlet weak var highlySkilledView: UIView!
    @IBOutlet weak var handicapOneLbl: UILabel!
    @IBOutlet weak var highlySkilledLbl: UILabel!
    @IBOutlet weak var mediumSkilledView: UIView!
    @IBOutlet weak var mediumSkilledLbl: UILabel!
    @IBOutlet weak var handicapTwoLbl: UILabel!
    @IBOutlet weak var lowSkilledView: UIView!
    @IBOutlet weak var lowerSkilledLbl: UILabel!
    @IBOutlet weak var handicapThreeLbl: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipNowButton: UIButton!
    
    var userSkillsData = ["Highly skilled", "Medium skilled", "Lower skilled"]
    var presenter: UserSkillPresenterProtocol?
    var isAnySkillSelected: Bool = false
    var selectedSkill: String?
    var isFromEditProfile: Bool = false
    var isFromEditSkill: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSkillData()
        setBottomButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSkillData()
    }
    
    func setBottomButton() {
        if isFromEditProfile == true {
            self.skipNowButton.isHidden = true
            self.nextButton.setTitle(AppStrings.save, for: .normal)
        } else {
            self.skipNowButton.isHidden = false
            self.nextButton.setTitle(AppStrings.next, for: .normal)
        }
    }
    
    func setSkillData() {
        let strings = UserDefaults.standard.object(forKey: AppStrings.userDatas) as? [String: Any]
        let userSkills = (strings?["user_skill_level"] as? String) ?? ""
        if userSkills.count > 0 {
            if userSkills == SkillData.highySkilled.description {
                self.highelySkillSelectedUi()
            } else if userSkills == SkillData.mediumSkilled.description {
                self.midiumSkillSelectedUi()
            } else {
                self.lowerSkillSelectedUi()
            }
        } else {
            return
        }
    }
    
    func lowerSkillSelectedUi() {
        isAnySkillSelected = true
        highlySkilledView.backgroundColor = .white
        mediumSkilledView.backgroundColor =  .white
        lowSkilledView.backgroundColor = UIColor.appColor(.yellow_dark)
        lowerSkilledLbl.textColor = .white
        handicapThreeLbl.textColor = .white
        highlySkilledLbl.textColor = UIColor.appColor(.Grey_dark)
        handicapOneLbl.textColor = UIColor.appColor(.Grey_dark)
        mediumSkilledLbl.textColor = UIColor.appColor(.Grey_dark)
        handicapTwoLbl.textColor = UIColor.appColor(.Grey_dark)
    }
    
    func midiumSkillSelectedUi() {
        isAnySkillSelected = true
        highlySkilledView.backgroundColor = .white
        mediumSkilledView.backgroundColor = UIColor.appColor(.yellow_dark)
        mediumSkilledLbl.textColor = .white
        handicapTwoLbl.textColor = .white
        lowSkilledView.backgroundColor = .white
        highlySkilledLbl.textColor = UIColor.appColor(.Grey_dark)
        handicapOneLbl.textColor = UIColor.appColor(.Grey_dark)
        lowerSkilledLbl.textColor = UIColor.appColor(.Grey_dark)
        handicapThreeLbl.textColor = UIColor.appColor(.Grey_dark)
    }
    
    func highelySkillSelectedUi() {
        isAnySkillSelected = true
        highlySkilledView.backgroundColor = UIColor.appColor(.yellow_dark)
        highlySkilledLbl.textColor = .white
        handicapOneLbl.textColor = .white
        mediumSkilledView.backgroundColor =  .white
        lowSkilledView.backgroundColor = .white
        mediumSkilledLbl.textColor = UIColor.appColor(.Grey_dark)
        handicapTwoLbl.textColor = UIColor.appColor(.Grey_dark)
        lowerSkilledLbl.textColor = UIColor.appColor(.Grey_dark)
        handicapThreeLbl.textColor = UIColor.appColor(.Grey_dark)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
     
    @IBAction func nextAction(_ sender: UIButton) {
        //MARK: code added for tabbar ----
        if isAnySkillSelected == false {
            Singleton.shared.showMessage(message: AppStrings.selectOneSkill, isError: .error)
            return
        } else {
            self.presenter?.updateUserSkillToFirestore(skillType: self.selectedSkill ?? "")
        }
    }
    
    @IBAction func skipForNowAction(_ sender: UIButton) {
        Singleton.shared.setHomeScreenView()
    }
    
    @IBAction func highlySkilledAction(_ sender: UIButton) {
        isAnySkillSelected = true
        highlySkilledView.backgroundColor = UIColor.appColor(.yellow_dark)
        highlySkilledLbl.textColor = .white
        handicapOneLbl.textColor = .white
        mediumSkilledView.backgroundColor =  .white
        lowSkilledView.backgroundColor = .white
        mediumSkilledLbl.textColor = UIColor.appColor(.Grey_dark)
        handicapTwoLbl.textColor = UIColor.appColor(.Grey_dark)
        lowerSkilledLbl.textColor = UIColor.appColor(.Grey_dark)
        handicapThreeLbl.textColor = UIColor.appColor(.Grey_dark)
        self.selectedSkill = "\(userSkillsData[0])"
    }
    
    @IBAction func mediumSkilledAction(_ sender: UIButton) {
        isAnySkillSelected = true
        highlySkilledView.backgroundColor = .white
        mediumSkilledView.backgroundColor = UIColor.appColor(.yellow_dark)
        mediumSkilledLbl.textColor = .white
        handicapTwoLbl.textColor = .white
        lowSkilledView.backgroundColor = .white
        highlySkilledLbl.textColor = UIColor.appColor(.Grey_dark)
        handicapOneLbl.textColor = UIColor.appColor(.Grey_dark)
        lowerSkilledLbl.textColor = UIColor.appColor(.Grey_dark)
        handicapThreeLbl.textColor = UIColor.appColor(.Grey_dark)
        self.selectedSkill = "\(userSkillsData[1])"
    }
    
    @IBAction func lowSkilledActiion(_ sender: UIButton) {
        isAnySkillSelected = true
        highlySkilledView.backgroundColor = .white
        mediumSkilledView.backgroundColor =  .white
        lowSkilledView.backgroundColor = UIColor.appColor(.yellow_dark)
        lowerSkilledLbl.textColor = .white
        handicapThreeLbl.textColor = .white
        highlySkilledLbl.textColor = UIColor.appColor(.Grey_dark)
        handicapOneLbl.textColor = UIColor.appColor(.Grey_dark)
        mediumSkilledLbl.textColor = UIColor.appColor(.Grey_dark)
        handicapTwoLbl.textColor = UIColor.appColor(.Grey_dark)
        self.selectedSkill = "\(userSkillsData[2])"
    }
}
