//
//  TournamentDetailViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 27/03/23.
//

import UIKit

class TournamentDetailViewController: UIViewController, UIScrollViewDelegate, TournamentDetailViewProtocol {
    
    @IBOutlet weak var tournamentScrollView: UIScrollView!
    @IBOutlet weak var participantNumberLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var viewOnMapBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var folfDetailsImage: UIImageView!
    @IBOutlet weak var tournamentsName: UILabel!
    @IBOutlet weak var tournamentsFormat: UILabel!
    @IBOutlet weak var offerName: UILabel!
    @IBOutlet weak var tournamentsDateAndTIme: UILabel!
    @IBOutlet weak var tournamentsLocation: UILabel!
    @IBOutlet weak var tournamentsAddress: UILabel!
    @IBOutlet weak var tournamentsPrice: UILabel!
    @IBOutlet weak var tournamentsSpecialPrize: UILabel!
    @IBOutlet weak var tournamentsFirstPrize: UILabel!
    @IBOutlet weak var tournamentsSecondsPrize: UILabel!
    @IBOutlet weak var attendedPriceButton: UIButton!
    
    var tournamentData: TournamentModel?
    var presenter: TournamentDetailPresenterProtocol?
    var tournamentsDetailsImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passedTounamentsData()
        self.setTournamentsDetailsData()
    }
    
    func passedTounamentsData() {
        print("passes data -----")
        print("a--\(tournamentData?.title)")
        print("b--\(tournamentData?.date)")
        print("c--\(tournamentData?.address)")
        print("d--\(tournamentData?.location)")
        print("e--\(tournamentData?.descriptions)")
        print("f--\(tournamentData?.availability)")
        print("g--\(tournamentData?.time?.count)")
        print("h--\(tournamentData?.time)")
        print("i--\(tournamentData?.price)")
        print("j---\(tournamentData?.sale_price)")
        print("passed all data........")
        print("avalibility in int value ----\(tournamentData?.availability?.toInt ?? 0)")
    }
    
    func setTournamentsDetailsData() {
        if (tournamentData?.availability?.toInt ?? 0) < 1 {
            self.participantNumberLabel.text = "\(0)"
            self.minusBtn.isUserInteractionEnabled = false
            self.plusBtn.isUserInteractionEnabled = false
        } else {
            self.minusBtn.isUserInteractionEnabled = true
            self.plusBtn.isUserInteractionEnabled = true
        }
        self.folfDetailsImage.image = tournamentsDetailsImage
        self.tournamentsName.text = tournamentData?.title ?? ""
        self.tournamentsDateAndTIme.text = tournamentData?.date ?? ""
        self.tournamentsLocation.text = tournamentData?.location ?? ""
        self.tournamentsAddress.text = tournamentData?.address ?? ""
        self.tournamentsPrice.text = "CAD\(tournamentData?.price ?? "")"
        self.attendedPriceButton.setTitle("Attend CAD\(tournamentData?.price ?? "")", for: .normal)
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
        if (tournamentData?.availability?.toInt ?? 0) > 0 {
            let variationType = self.selectLabel.text
            let quantity = Int(participantNumberLabel.text ?? "")
            let orderSummryVc = OrderSummryPresenter.createOrderSummryModule(tournamenDetailstData: tournamentData ?? TournamentModel(), variations: variationType, quantity: quantity)
            orderSummryVc.hidesBottomBarWhenPushed = true
            self.pushViewController(orderSummryVc, true)
        } else {
            Singleton.shared.showMessage(message: "No avalibility.", isError: .error)
         return
        }
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        guard let presentValue = Int(participantNumberLabel.text ?? "") else { return }
        if presentValue == 1 {
            return
        }
        let newValue = presentValue - 1
        if newValue == -1 {
            self.minusBtn.isEnabled = false
        } else {
            self.minusBtn.isEnabled = true
            participantNumberLabel.text = String(newValue)
        }
        self.minusBtn.isEnabled = true
        //MARK: code for update price acc to to quantity---
        let myString = tournamentData?.price ?? ""
        self.attendedPriceButton.setTitle("Attend CAD$\(newValue * (myString.numbers.toInt ?? 0))", for: .normal)
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
        guard let presentValue = Int(participantNumberLabel.text ?? "") else { return }
        if presentValue == tournamentData?.availability?.toInt ?? 0 {
            return
        }
        let newValue = presentValue + 1
        participantNumberLabel.text = String(newValue)
        //MARK: code for update price acc to to quantity---
        let myString = tournamentData?.price ?? ""
        self.attendedPriceButton.setTitle("Attend CAD$\(newValue * (myString.numbers.toInt ?? 0))", for: .normal)
    }
    
    @IBAction func viewOnMapAction(_ sender: Any) {}
}

extension TournamentDetailViewController: VariationViewControllerDelegate {
    func playerCount(text:String) {
        self.selectLabel.text = text
    }
}

