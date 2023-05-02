//
//  TournamentsModel.swift
//  Foresome
//
//  Created by Deepanshu on 04/04/23.
//

import Foundation

class TournamentModel : NSObject {
    var descriptions: String? = ""
    var location: String? = ""
    var price: String? = ""
    var sale_price: String? = ""
    var date: String? = ""
    var title: String? = ""
    var json: JSON!
    var availability: Int?  = 0
    var address: String? = ""
    var tournament_id: String?
    var time: [String]?
}

extension TournamentModel {
    convenience init(json: [String: Any]) {
        self.init()
        self.json = json
        if let descriptions = json["descriptions"] as? String {
            self.descriptions = descriptions
        }
        if let location = json["location"] as? String {
            self.location = location
        }
        if let price = json["price"] as? String {
            self.price = price
        }
        if let sale_price = json["sale_price"] as? String {
            self.sale_price = sale_price
        }
        if let date = json["date"] as? String {
            self.date = date
        }
        if let title = json["title"] as? String {
            self.title = title
        }
        if let availability = json["availability"] as? Int {
            self.availability = availability
        }
        if let address = json["address"] as? String {
            self.address = address
        }
        if let tournament_id = json["tournament_id"] as? String {
            self.tournament_id = tournament_id
        }
        
        if let tournaments_time = json["time"] as? [String] {
            self.time = tournaments_time
        }
    }
}


