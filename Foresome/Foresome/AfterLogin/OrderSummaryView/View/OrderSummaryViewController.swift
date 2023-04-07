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
    
    var presenter: OrderSummryPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getPaymentDetailsFromFireStore() {
        self.presenter?.getPaymenstDetails()
    }
    //MARK: code for square payments configuration-------
    func configureSquarePayments() {
        let theme = SQIPTheme()
        theme.tintColor = .green
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
        print("delegate b called")
        var amountJson = [String:Any]()
        amountJson["amount"] = 251
        amountJson["currency"] = "CAD"
        var json = [String:Any]()
        json["idempotency_key"] = UUID().uuidString
        json["amount_money"] = amountJson
        json["source_id"] = "cnon:card-nonce-ok"
        ChargeApi.processPayment(param: json) { (transactionData, errorDescription) in
            print("return transection id ---\(transactionData?.id)")
            Singleton.shared.setHomeScreenView()
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









