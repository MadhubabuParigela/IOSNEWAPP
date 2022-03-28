//
//  EditInventoryResult.swift
//  Lekha
//
//  Created by USM on 04/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class EditInventoryResult: Mappable {
    
    var productId:String?
    var _id : String?
    var productDict : EditInventoryProductDict?
    var vendorDict : NSDictionary?
    var stockUnitArray : NSArray?
    var stockUnitName : String?
    var storageLocation : String?
    var storageLocation1 : String?
    var storageLocation2 : String?
    var storageLocationArray : NSArray?
    var storageLocation1Array : NSArray?
    var storageLocation2Array : NSArray?
    var priceUnitArray : NSArray?
    var priceUnit : String?
    var categorydetailsArray : NSDictionary?
    var subcategorydetailsArray : NSDictionary?
    var shared : Bool?
    var isBorrowed : Bool?
    var stockQuantity: Double?

    init(productId:String?,productDict:EditInventoryProductDict?,_id:String?,stockQuantity: Double?) {
        self.productId = productId
        self.productDict = productDict
        self._id = _id
        self.stockQuantity = stockQuantity
    }
    
    required init?(map: Map) {
        
    }

    
    func mapping(map: Map) {
        
        self.productId <- map ["productId"]
        self.productDict <- map["productdetails"]
        self._id <- map["_id"]
        self.vendorDict <- map["vendordetails"]
        self.stockUnitArray <- map["stockUnitDetails"]
        self.storageLocationArray <- map["storageLocationLevel1Details"]
        self.storageLocation1Array <- map["storageLocationLevel2Details"]
        self.storageLocation2Array <- map["storageLocationLevel3Details"]
        self.priceUnitArray <- map["priceUnitDetails"]
        self.categorydetailsArray <- map["categorydetails"]
        self.subcategorydetailsArray <- map["subcategorydetails"]
        self.priceUnit <- map["priceUnit"]
        self.stockUnitName <- map["stockUnitName"]
        self.storageLocation <- map["slocName"]
        self.storageLocation1 <- map["slocName"]
        self.storageLocation2 <- map["slocName"]
        self.shared <- map["shared"]
        self.isBorrowed <- map["isBorrowed"]
        self.stockQuantity <- map["stockQuantity"]
    }
}
