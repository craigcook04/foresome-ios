//
//  TournamentDetailViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 27/03/23.
//

import UIKit


class TournamentDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var participantNumberLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var viewOnMapBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    
  //var presenter: TournamentDetailPresenterProtocol?
    
   override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.popVC()
    }
    
    @IBAction func variationAction(_ sender: Any) {
        let vc = VariationViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, true)
    }
    
    @IBAction func attendAction(_ sender: UIButton) {
        let vc = OrderSummaryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        guard let presentValue = Int(participantNumberLabel.text ?? "") else { return }
         
        let newValue = presentValue - 1
        participantNumberLabel.text = String(newValue)
        if presentValue < 1 {
            self.minusBtn.isUserInteractionEnabled = false
        }
        
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
        
        guard let presentValue = Int(participantNumberLabel.text ?? "") else { return }

         let newValue = presentValue + 1
         participantNumberLabel.text = String(newValue)
        
    }
    
    @IBAction func viewOnMapAction(_ sender: Any) {
        
    }
}
