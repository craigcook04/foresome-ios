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
        tournamentsName.text = tournamenDetailstData?.title ?? ""
        tournamentsDate.text = tournamenDetailstData?.date ?? ""
        variationType.text = "\(AppStrings.variation) \(variations ?? "")"
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
        var amountJson = [String:Any]()
        amountJson["amount"] = (quantity ?? 0) * (myString.numbers.toInt ?? 0)
        amountJson["currency"] = "CAD"
        var json = [String:Any]()
        json["idempotency_key"] = UUID().uuidString
        json["amount_money"] = amountJson
        json["source_id"] = "cnon:card-nonce-ok"
        ChargeApi.processPayment(param: json) { (transactionData, errorDescription) in
            if (transactionData?.id?.count ?? 0) > 0 {
                let db = Firestore.firestore()
                let currentUserId = UserDefaults.standard.value(forKey: "user_uid") ?? ""
                db.collection("payments").document(transactionData?.id ?? "").setData(["user_id":"\(currentUserId)", "createdAt":"\(transactionData?.created_at ?? "")", "id": "\(transactionData?.id ?? "")", "order_id": "\(transactionData?.order_id ?? "")", "payments_status": "\(transactionData?.status ?? "")"], merge: true)
                Singleton.shared.showMessage(message: AppStrings.paymentSuccess, isError: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    Singleton.shared.setHomeScreenView()
                })
            } else {
                if let error = errorDescription {
                    Singleton.shared.showMessage(message: error, isError: .error)
                }
            }
        }
    }
    
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didCompleteWith status: SQIPCardEntryCompletionStatus) {
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


              





