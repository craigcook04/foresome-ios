//
//  SquarePaymentsApiFile.swift
//  Foresome
//
//  Created by Deepanshu on 06/04/23.
//

import Foundation

struct Constants {
    struct ApplePay {
        static let MERCHANT_IDENTIFIER: String = "REPLACE_ME"
        static let COUNTRY_CODE: String = "US"
        static let CURRENCY_CODE: String = "USD"
    }
    
    struct Square {
        static let SQUARE_LOCATION_ID: String = "REPLACE_ME"
        static let APPLICATION_ID: String  = "sq0idp-Zmcos_008lyfULDLITy2PA"
        static let CHARGE_SERVER_HOST: String = "https://connect.squareupsandbox.com/v2/payments"
        static let CHARGE_URL: String = "\(CHARGE_SERVER_HOST)/chargeForCookie"
        static let squarePaymentHost = "https://connect.squareupsandbox.com/v2/payments"
    }
}

class ChargeApi {
    static public func processPayment(param:[String:Any], completion: @escaping (PaymentsCreateData?, String?) -> Void) {
        let url = URL(string: Constants.Square.squarePaymentHost)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let accessToken = "Bearer EAAAEEL4gDM2dJX1MRIWGAGjs75M0eDCREnl33mh5T6TMK6diaPG2bXvk-zvUaxy"
        request.setValue("\(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let json = param//["nonce": nonce]
        print("sended json---\(json)")
        let httpBody = try? JSONSerialization.data(withJSONObject: json)
        //        request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as NSError?{
                if error.domain == NSURLErrorDomain {
                    DispatchQueue.main.async {
                        completion(nil, "Could not contact host")
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, "Something went wrong")
                    }
                }
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    print("josn after JSONSerialization---\(json)")
                    let launch = try JSONDecoder().decode(PaymentsDataModel.self, from: data)
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            completion(launch.payment, nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil, json["errorMessage"] as? String)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, "Failure")
                    }
                }
            }
        }.resume()
    }
}

//MARK: code for make model ofpayments data-------
class PaymentsDataModel:Codable {
    var payment: PaymentsCreateData?
}

class PaymentsCreateData:Codable {
    var id: String?
    var created_at: String?
    var updated_at: String?
//    var amount_money: AmountData?
    var status: String?
    var delay_duration: String?
    var source_type: String?
//    var card_details: CardDetails?
    var location_id: String?
    var order_id: String?
//    var total_money: TotalMoney?
//    var approved_money: ApprovedMoney?
    var receipt_number: String?
    var receipt_url: String?
    var delay_action: String?
    var delayed_until: String?
//    var application_details: ApplicationDetails?
    var version_token:String?
}

class AmountData:Codable {
    var amount: Int?
    var currency: String?
}

class CardDetails:Codable {
    var status: String?
    var card: CardaData
    var entry_method: String?
    var cvv_status:String?
    var avs_status:String?
    var statement_description:String?
    var card_payment_timeline: CardPaymentTimeLine?
}

class CardaData:Codable {
    var card_brand: String?
    var last_4: Int?
    var exp_month:Int?
    var exp_year: Int?
    var fingerprint: String?
    var card_type: String?
    var prepaid_type: String?
    var bin: Double?
}

class CardPaymentTimeLine:Codable {
    var authorized_at: String?
    var captured_at: String?
}

class TotalMoney:Codable {
    var amount:Int?
    var currency:String
}

class ApprovedMoney:Codable {
    var amount: Int?
    var currency: String?
}

class ApplicationDetails:Codable {
    var square_product: String?
    var application_id: String?
}
//
//{
//  "payment": {
//    "id": "P571mEIiCvyzHj6rktIF91B8wfUZY",
//    "created_at": "2023-04-06T07:37:54.586Z",
//    "updated_at": "2023-04-06T07:37:54.823Z",
//    "amount_money": {
//      "amount": 2000,
//      "currency": "USD"
//    },
//    "status": "COMPLETED",
//    "delay_duration": "PT168H",
//    "source_type": "CARD",
//    "card_details": {
//      "status": "CAPTURED",
//      "card": {
//        "card_brand": "VISA",
//        "last_4": "5858",
//        "exp_month": 4,
//        "exp_year": 2025,
//        "fingerprint": "sq-1-TSTWntVXl0u-UoUnlB2PG5jWAVzeVLu3djoA31tKG2-ens5Ml_qSe2r9eQ3LjchfjQ",
//        "card_type": "CREDIT",
//        "prepaid_type": "NOT_PREPAID",
//        "bin": "453275"
//      },
//      "entry_method": "KEYED",
//      "cvv_status": "CVV_ACCEPTED",
//      "avs_status": "AVS_ACCEPTED",
//      "statement_description": "SQ *DEFAULT TEST ACCOUNT",
//      "card_payment_timeline": {
//        "authorized_at": "2023-04-06T07:37:54.700Z",
//        "captured_at": "2023-04-06T07:37:54.824Z"
//      }
//    },
//    "location_id": "L348N7706W9PA",
//    "order_id": "71avwsyOByWP1w6iZ1UmCqJIPlTZY",
//    "total_money": {
//      "amount": 2000,
//      "currency": "USD"
//    },
//    "approved_money": {
//      "amount": 2000,
//      "currency": "USD"
//    },
//    "receipt_number": "P571",
//    "receipt_url": "https://squareupsandbox.com/receipt/preview/P571mEIiCvyzHj6rktIF91B8wfUZY",
//    "delay_action": "CANCEL",
//    "delayed_until": "2023-04-13T07:37:54.586Z",
//    "application_details": {
//      "square_product": "ECOMMERCE_API",
//      "application_id": "sandbox-sq0idb-aDYl1a5nsjxaSTLf25MucA"
//    },
//    "version_token": "6WnPmePj0ksq2ai9gTmSNLlfA5Fk18pJjUuNiQXmqQt6o"
//  }
//}
