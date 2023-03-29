//
//  TournamentDetailViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 27/03/23.
//

import UIKit


class TournamentDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var tournamentScrollView: UIScrollView!
    @IBOutlet weak var participantNumberLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var viewOnMapBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    
    
    @IBOutlet weak var headerImageView: UIImageView!
    var presenter: TournamentDetailPresenter?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBAction func backAction(_ sender: Any) {
        self.popVC()
    }
    
    
    @IBAction func variationAction(_ sender: Any) {
        let vc = VariationViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, true)
    }
    
    @IBAction func attendAction(_ sender: UIButton) {
        let vc = OrderSummaryViewController()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        guard let presentValue = Int(participantNumberLabel.text ?? "") else { return }
        let newValue = presentValue - 1
        if newValue == -1 {
            self.minusBtn.isEnabled = false
        }else{
            self.minusBtn.isEnabled = true
            participantNumberLabel.text = String(newValue)
        }
        self.minusBtn.isEnabled = true
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
        
        guard let presentValue = Int(participantNumberLabel.text ?? "") else { return }
        let newValue = presentValue + 1
        participantNumberLabel.text = String(newValue)
    }
    
    @IBAction func viewOnMapAction(_ sender: Any) {
        
    }
}

extension TournamentDetailViewController: VariationViewControllerDelegate {
    func playerCount(text: String) {
        self.selectLabel.text = text
    }
}
extension TournamentDetailViewController: TournamentDetailViewProtocol {
}


