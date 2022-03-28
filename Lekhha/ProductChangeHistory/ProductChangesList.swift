//
//  ProductChangesList.swift
//  Lekhha
//
//  Created by Swapna Nimma on 07/01/22.
//

import Foundation
import ObjectMapper

class ProductChangesList: Mappable {
    
    var productdetails: ProductdetailsVo?
    var stockUnitDetails: [StockUnitDetailsVo]?
    var storageLocationLevel1Details: [StorageLocationLevel1DetailsVo]?
    var storageLocationLevel2Details :[StorageLocationLevel2DetailsVo]?
    var storageLocationLevel3Details : [StorageLocationLevel3DetailsVo]?
    var priceUnitDetails : [PriceUnitDetailsVo]?
    var userInfoDetails: [UserinfoVo]?
    var accountInfoDetails: [AccountinfoVo]?
    var updatingQuantity : Float?
    var vendorApprovalStatus : String?
    var isExpandableRow : Bool?
    var productModifingDetails : ProductModifingDetailsVo?
    var productModifingEditDetails : ProductModifingDetailsVo?
    var stockQuantity: Double?
    var cellHeight : Int?
    
    init(productdetails: ProductdetailsVo?,
     stockUnitDetails: [StockUnitDetailsVo]?,
     storageLocationLevel1Details: [StorageLocationLevel1DetailsVo]?,
     storageLocationLevel2Details :[StorageLocationLevel2DetailsVo]?,
     storageLocationLevel3Details : [StorageLocationLevel3DetailsVo]?,
     priceUnitDetails : [PriceUnitDetailsVo]?,
    isExpandableRow : Bool?,
     productModifingDetails : ProductModifingDetailsVo?, userInfoDetails: [UserinfoVo]?,
     accountInfoDetails: [AccountinfoVo]?,
   updatingQuantity : Float?,
   vendorApprovalStatus : String?,cellHeight :Int?,productModifingEditDetails : ProductModifingDetailsVo?,stockQuantity: Double?) {
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.productdetails <- map ["productdetails"]
        self.stockUnitDetails <- map ["stockUnitDetails"]
        self.storageLocationLevel1Details <- map ["storageLocationLevel1Details"]
        self.storageLocationLevel2Details <- map ["storageLocationLevel2Details"]
        self.storageLocationLevel3Details <- map ["storageLocationLevel3Details"]
        self.priceUnitDetails <- map ["priceUnitDetails"]
        self.isExpandableRow <- map ["isExpandableRow"]
        self.updatingQuantity <- map ["updatingQuantity"]
        self.vendorApprovalStatus <- map ["vendorApprovalStatus"]
        self.productModifingDetails <- map ["modifyingdetails"]
        self.cellHeight <- map ["cellHeight"]
        self.productModifingEditDetails <- map ["productModifingDetails"]
        self.stockQuantity <- map ["stockQuantity"]
    }
}

