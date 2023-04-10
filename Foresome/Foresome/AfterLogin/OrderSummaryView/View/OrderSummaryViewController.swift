//
//  OrderSummaryViewController.swift
//  Foresome
//
//  Created by Piyush Kumar on 28/03/23.
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
import SquareInAppPaymentsSDK

class OrderSummaryViewController: UIViewController, OrderSummryViewProtocol {
    
    @IBOutlet weak var tournamentsName: UILabel!
    @IBOutlet weak var tournamentsDate: UILabel!
    @IBOutlet weak var variationType: UILabel!
    @IBOutlet weak var tournamentsLocations: UILabel!
    @IBOutlet weak var tournamentsAddress: UILabel!
    @IBOutlet weak var tournamentsPriceWithQuantity: UILabel!
    @IBOutlet weak var subtotalValue: UILabel!
    @IBOutlet weak var taxesValue: UILabel!
    @IBOutlet weak var totalPriceValue: UILabel!
    
    var presenter: OrderSummryPresenterProtocol?
    var tournamenDetailstData: TournamentModel?
    var variations: String?
    var quantity: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showOrderDetails()
    }
    
    func showOrderDetails() {
        print("tournaments title---\(tournamenDetailstData?.title)")
        print("tournaments date---\(tournamenDetailstData?.date)")
        print("tournaments variations---\(variations)")
        print("tournaments locations---\(tournamenDetailstData?.location)")
        print("tournaments address---\(tournamenDetailstData?.address)")
        print("tournaments quantity---\(quantity)")
        
        tournamentsName.text = tournamenDetailstData?.title ?? ""
        tournamentsDate.text = tournamenDetailstData?.date ?? ""
        variationType.text = "Variation: \(variations ?? "")"
        tournamentsLocations.text = tournamenDetailstData?.location ?? ""
        tournamentsAddress.text = tournamenDetailstData?.address ?? ""
        tournamentsPriceWithQuantity.text = "\(quantity ?? 0)x CAD\(tournamenDetailstData?.price ?? "")"
        let myString = tournamenDetailstData?.price ?? ""
        subtotalValue.text = "CAD$\((quantity ?? 0) * (myString.numbers.toInt ?? 0))"
        taxesValue.text = "CAD$0.00"
        totalPriceValue.text = "CAD$\((quantity ?? 0) * (myString.numbers.toInt ?? 0))"
    }
    
    func getPaymentDetailsFromFireStore() {
        self.presenter?.getPaymenstDetails()
    }
    //MARK: code for square payments configuration-------
    func configureSquarePayments() {
        let theme = SQIPTheme()
        theme.tintColor =  UIColor(hexString: "#40CD93", alpha: 1.0)
        let cardEntry = SQIPCardEntryViewController(theme: theme)
        cardEntry.collectPostalCode = false
        cardEntry.delegate = self
        self.present(cardEntry, animated: true)
    }
    
    private var serverHostSet: Bool {
        return Constants.Square.CHARGE_SERVER_HOST != "https://connect.squareupsandbox.com/v2/payments"
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.popVC()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func makePaymentAction(_ sender: UIButton) {
        configureSquarePayments()
    }
}

extension OrderSummaryViewController : SQIPCardEntryViewControllerDelegate {
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didObtain cardDetails: SQIPCardDetails) async throws {
        let myString = tournamenDetailstData?.price ?? ""
        print("delegate b called")
        var amountJson = [String:Any]()
        amountJson["amount"] = (quantity ?? 0) * (myString.numbers.toInt ?? 0)
        amountJson["currency"] = "CAD"
        var json = [String:Any]()
        json["idempotency_key"] = UUID().uuidString
        json["amount_money"] = amountJson
        json["source_id"] = "cnon:card-nonce-ok"
        ChargeApi.processPayment(param: json) { (transactionData, errorDescription) in
            if (transactionData?.id?.count ?? 0) > 0 {
                Singleton.shared.showMessage(message: "Payments successfull.", isError: .success)
                Singleton.shared.setHomeScreenView()
            } else {
            }
            guard let errorDescription = errorDescription else {
                return
            }
        }
    }
    
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didCompleteWith status: SQIPCardEntryCompletionStatus) {
        print("delegate c called")
        dismiss(animated: true) {
            switch status.rawValue {
            case 0:
                print("canceled or failure cases...")
                break
            case 1:
                guard self.serverHostSet else {
                    return
                }
                print("success cases.....")
            default:
                print("default cases executed-----")
                break
            }
        }
    }
}

extension OrderSummaryViewController :  PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    }
}









