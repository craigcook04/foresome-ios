//
//  FilterDataModel.swift
//  Foresome
//
//  Created by Deepanshu on 29/05/23.
//

import Foundation
import UIKit



class FilterDataModel: NSObject {
    var filterByIcon: UIImage?
    var filterPlaceHolder: String?

    public init(filterByIcon: UIImage?, filterPlaceHolder: String?) {
        self.filterByIcon = filterByIcon
        self.filterPlaceHolder = filterPlaceHolder
    }
}

class FilterData {
    static var filterArray: [FilterDataModel] = [
        FilterDataModel.init(filterByIcon: UIImage(named: "ic_search"), filterPlaceHolder: AppStrings.searchByName),
        FilterDataModel.init(filterByIcon: UIImage(named: "ic_location"), filterPlaceHolder: AppStrings.selectLocation),
        FilterDataModel.init(filterByIcon: UIImage(named: "ic_dropdown"), filterPlaceHolder: AppStrings.selectTournaments)
    ]
    
    
    
    static var filterImage = ["ic_search", "ic_location", "ic_dropdown"]
    
    
    static var sortByData = ["All", "Highest score", "Lowest score", "Most birdies"]
    
}











