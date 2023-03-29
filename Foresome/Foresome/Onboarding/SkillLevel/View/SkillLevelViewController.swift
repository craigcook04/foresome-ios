//
//  SkillLevelViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 23/03/23.
//

import UIKit

class SkillLevelViewController: UIViewController {
    
    
    @IBOutlet weak var highlySkilledView: UIView!
    @IBOutlet weak var handicapOneLbl: UILabel!
    @IBOutlet weak var highlySkilledLbl: UILabel!
    @IBOutlet weak var mediumSkilledView: UIView!
    @IBOutlet weak var mediumSkilledLbl: UILabel!
    @IBOutlet weak var handicapTwoLbl: UILabel!
    @IBOutlet weak var lowSkilledView: UIView!
    @IBOutlet weak var lowerSkilledLbl: UILabel!
    @IBOutlet weak var handicapThreeLbl: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func skipForNowAction(_ sender: Any) {
        
    }
    
    @IBAction func highlySkilledAction(_ sender: UIButton) {
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
    
    @IBAction func mediumSkilledAction(_ sender: UIButton) {
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
    
    @IBAction func lowSkilledActiion(_ sender: UIButton) {
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
}
