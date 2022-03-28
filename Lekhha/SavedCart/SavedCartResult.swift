//
//  SavedCartResult.swift
//  Lekha
//
//  Created by Mallesh Kurva on 15/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class SavedCartResult: Mappable {
    
    var productId:String?
    var _id : String?
    var accountId : String?
    var plannedPurchasedate : String?
    var requiredQuantity : Int?
    var cartId : String?
    var productDict : SavedCartProductDetails?
    var vendordetails : NSDictionary?
    var priceUnitDetails:[SavingPriceUnitDetailsVo]?
    var stockUnitDetails:[SavingStockUnitDetailsVo]?
    
    init(productId:String?,productDict:ShoppingCartProdDetail?,_id:String?,requiredQuantity:String?,plannedPurchasedate:String?,cartId:String?, priceUnitDetails:[SavingPriceUnitDetailsVo]?,stockUnitDetails:[SavingStockUnitDetailsVo]?) {
        
    }
    
    required init?(map: Map) {
            
    }
    
    func mapping(map: Map) {
           
        self.productId <- map ["productId"]
        self.productDict <- map["productdetails"]
        self._id <- map["_id"]
        self.accountId <- map["accountId"]
        self.requiredQuantity <- map["requiredQuantity"]
        self.plannedPurchasedate <- map["plannedPurchasedate"]
        self.cartId <- map["cartId"]
        self.vendordetails <- map["vendordetails"]
        self.priceUnitDetails <- map["priceUnitDetails"]
        self.stockUnitDetails <- map["stockUnitDetails"]
        
    }
}
class SavingPriceUnitDetailsVo: Mappable {
    
    var _id: String?
    var priceUnitDescription: String?
    var priceUnit: String?
    var status: Bool?
    var isDefault: Bool?
    var countryName: String?
    
    init(_id: String?,
          priceUnitDescription: String?,
          priceUnit: String?,
          status: Bool?,
          isDefault: Bool?,
          countryName: String?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        _id <- map["_id"]
        priceUnitDescription <- map["priceUnitDescription"]
        priceUnit <- map["priceUnit"]
        status <- map["status"]
        isDefault <- map["isDefault"]
        countryName <- map["countryName"]
        
    }
}
class SavingStockUnitDetailsVo: Mappable {
    
    var _id: String?
    var accountId: String?
    var stockUnitDescription: String?
    var stockUnitName: String?
    var isDefault: Bool?
    var canEdit: Bool?
    
    init( _id: String?,
          accountId: String?,
          stockUnitDescription: String?,
          stockUnitName: String?,
          isDefault: Bool?,
          canEdit: Bool?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        _id <- map["_id"]
        accountId <- map["accountId"]
        stockUnitDescription <- map["stockUnitDescription"]
        stockUnitName <- map["stockUnitName"]
        isDefault <- map["isDefault"]
        canEdit <- map["canEdit"]
        
    }
}
