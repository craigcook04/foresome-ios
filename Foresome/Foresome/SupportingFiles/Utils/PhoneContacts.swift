//
//  Contacts.swift
//  meetwise
//
//  Created by hitesh on 31/08/20.
//  Copyright © 2020 hitesh. All rights reserved.
//

import UIKit
import ContactsUI

class Contact {
    var number: String?
    var code: String?
    var fullName: String?
    
    var json:JSON? {
        var json = JSON()
        if let code = code {
            json["country_code"] = "+\(code)"
        }
        json["phone_no"] = number
        json["name"] = fullName
        return number == nil ? nil : json
    }
    
    init(number: String?, code: String?, fullName: String?) {
        self.number = number
        self.code = code
        self.fullName = fullName
    }
    
}


class PhoneContacts {
    
    enum ContactsFilter {
        case none
        case mail
        case message
    }
    
    class func getAllContacts() -> [Contact] {
        let contacts = PhoneContacts.getContacts()
        print("all contacts count is \(contacts.count)")
        var allContacts = [Contact]()
        
        contacts.forEach { contact in
            let fullName = CNContactFormatter.string(from: contact, style: .fullName)
            let value = contact.phoneNumbers.first?.value
            var countryCode:String?
            var number:String?
            
            if let cCode = value?.value(forKey: "countryCode") as? String {
                countryCode = PhoneContacts.getCountryPhoneCode(country: cCode)
            }
            if let country = countryCode {
                number = (value?.value(forKey: "digits") as? String)?.numberWithout(code: country)
            }
            if let name = fullName, name.isNotEmpty {
                let newContact = Contact(number: number, code: countryCode, fullName: name)
                allContacts.append(newContact)
               
            }
        }
        return allContacts
    }
    
    
    class func getContactPermission(_ complition: @escaping((Bool)->Void)) {
        let contactStore = CNContactStore()
        do {
            _ = try contactStore.containers(matching: nil)
            complition(true)
        } catch {
            print("Error fetching containers")
            complition(false)
        }
    }
    
    class func getContacts(filter: PhoneContacts.ContactsFilter = .none) -> [CNContact] {
        //  ContactsFilter is Enum find it below
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [CNContact] = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        return results
    }
    
    class func uploadContacts(complition: @escaping ((Bool)->())) {
        print("sync contacts action")
        _ = PhoneContacts.getAllContacts()
      //  ContactsModel.apiSyncContacts(contacts: contacts, complitionHandler: complition)
    }
    
    class func getCountryPhoneCode(country: String) -> String {
        let countryPrefixes: [String: String] = ["AF": "93",
                "AL": "355",
                "DZ": "213",
                "AS": "1",
                "AD": "376",
                "AO": "244",
                "AI": "1", "AQ": "672",
                "AG": "1",
                "AR": "54",
                "AM": "374",
                "AW": "297",
                "AU": "61",
                "AT": "43",
                "AZ": "994",
                "BS": "1",
                "BH": "973",
                "BD": "880",
                "BB": "1",
                "BY": "375",
                "BE": "32",
                "BZ": "501",
                "BJ": "229",
                "BM": "1",
                "BT": "975",
                "BA": "387",
                "BW": "267",
                "BR": "55",
                "IO": "246",
                "BG": "359",
                "BF": "226",
                "BI": "257",
                "KH": "855",
                "CM": "237",
                "CA": "1",
                "CV": "238",
                "KY": "345",
                "CF": "236",
                "TD": "235",
                "CL": "56",
                "CN": "86",
                "CX": "61",
                "CO": "57",
                "KM": "269",
                "CG": "242",
                "CK": "682",
                "CR": "506",
                "HR": "385",
                "CU": "53",
                "CY": "537",
                "CZ": "420",
                "DK": "45",
                "DJ": "253",
                "DM": "1",
                "DO": "1",
                "EC": "593",
                "EG": "20",
                "SV": "503",
                "GQ": "240",
                "ER": "291",
                "EE": "372",
                "ET": "251",
                "FO": "298",
                "FJ": "679",
                "FI": "358",
                "FR": "33",
                "GF": "594",
                "PF": "689",
                "GA": "241",
                "GM": "220",
                "GE": "995",
                "DE": "49",
                "GH": "233",
                "GI": "350",
                "GR": "30",
                "GL": "299",
                "GD": "1",
                "GP": "590",
                "GU": "1",
                "GT": "502",
                "GN": "224",
                "GW": "245",
                "GY": "595",
                "HT": "509",
                "HN": "504",
                "HU": "36",
                "IS": "354",
                "IN": "91",
                "ID": "62",
                "IQ": "964",
                "IE": "353",
                "IL": "972",
                "IT": "39",
                "JM": "1",
                "JP": "81",
                "JO": "962",
                "KZ": "77",
                "KE": "254",
                "KI": "686",
                "KW": "965",
                "KG": "996",
                "LV": "371",
                "LB": "961",
                "LS": "266",
                "LR": "231",
                "LI": "423",
                "LT": "370",
                "LU": "352",
                "MG": "261",
                "MW": "265",
                "MY": "60",
                "MV": "960",
                "ML": "223",
                "MT": "356",
                "MH": "692",
                "MQ": "596",
                "MR": "222",
                "MU": "230",
                "YT": "262",
                "MX": "52",
                "MC": "377",
                "MN": "976",
                "ME": "382",
                "MS": "1",
                "MA": "212",
                "MM": "95",
                "NA": "264",
                "NR": "674",
                "NP": "977",
                "NL": "31",
                "AN": "599",
                "NC": "687",
                "NZ": "64",
                "NI": "505",
                "NE": "227",
                "NG": "234",
                "NU": "683",
                "NF": "672",
                "MP": "1",
                "NO": "47",
                "OM": "968",
                "PK": "92",
                "PW": "680",
                "PA": "507",
                "PG": "675",
                "PY": "595",
                "PE": "51",
                "PH": "63",
                "PL": "48",
                "PT": "351",
                "PR": "1",
                "QA": "974",
                "RO": "40",
                "RW": "250",
                "WS": "685",
                "SM": "378",
                "SA": "966",
                "SN": "221",
                "RS": "381",
                "SC": "248",
                "SL": "232",
                "SG": "65",
                "SK": "421",
                "SI": "386",
                "SB": "677",
                "ZA": "27",
                "GS": "500",
                "ES": "34",
                "LK": "94",
                "SD": "249",
                "SR": "597",
                "SZ": "268",
                "SE": "46",
                "CH": "41",
                "TJ": "992",
                "TH": "66",
                "TG": "228",
                "TK": "690",
                "TO": "676",
                "TT": "1",
                "TN": "216",
                "TR": "90",
                "TM": "993",
                "TC": "1",
                "TV": "688",
                "UG": "256",
                "UA": "380",
                "AE": "971",
                "GB": "44",
                "US": "1",
                "UY": "598",
                "UZ": "998",
                "VU": "678",
                "WF": "681",
                "YE": "967",
                "ZM": "260",
                "ZW": "263",
                "BO": "591",
                "BN": "673",
                "CC": "61",
                "CD": "243",
                "CI": "225",
                "FK": "500",
                "GG": "44",
                "VA": "379",
                "HK": "852",
                "IR": "98",
                "IM": "44",
                "JE": "44",
                "KP": "850",
                "KR": "82",
                "LA": "856",
                "LY": "218",
                "MO": "853",
                "MK": "389",
                "FM": "691",
                "MD": "373",
                "MZ": "258",
                "PS": "970",
                "PN": "872",
                "RE": "262",
                "RU": "7",
                "BL": "590",
                "SH": "290",
                "KN": "1",
                "LC": "1",
                "MF": "590",
                "PM": "508",
                "VC": "1",
                "ST": "239",
                "SO": "252",
                "SJ": "47",
                "SY": "963",
                "TW": "886",
                "TZ": "255",
                "TL": "670",
                "VE": "58",
                "VN": "84",
                "VG": "284",
                "VI": "340", "EH": "121"]
        if let countryCode = countryPrefixes[country.uppercased()] {
            return countryCode
        }
        return ""
    }
    
}

extension String {
    
    func numberWithout(code: String) -> String {
        let count = code.count-1
        let numberArray = self.map { String ($0) }
        let numbersOnly = numberArray.filter { Int($0) != nil }
        let remove = numbersOnly.count > count ? numbersOnly[...count].joined() == code : false
        let result = numbersOnly[(remove ? count+1 : 0)...]
        return result.joined()
    }

}
