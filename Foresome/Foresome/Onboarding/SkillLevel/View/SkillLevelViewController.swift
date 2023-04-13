//
//  SkillLevelViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 23/03/23.
//

import UIKit

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
    
    var userSkillsData = ["Highly skilled", "Medium skilled", "Lower skilled"]
    var presenter: UserSkillPresenterProtocol?
    var isAnySkillSelected: Bool = false
    var selectedSkill: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        //MARK: code added for tabbar ----
        if isAnySkillSelected == false {
            Singleton.shared.showMessage(message: "Please select any one skill Or skip.", isError: .error)
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
