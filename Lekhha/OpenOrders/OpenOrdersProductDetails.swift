//
//  OpenOrdersProductDetails.swift
//  Lekha
//
//  Created by Mallesh Kurva on 17/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class OpenOrdersProductDetails: Mappable {
    
    var _id:String?
    var accountId:String?
    var accountEmailId : String?
    var productUniqueNumber : String?
    var productName : String?
    var description : String?
    var stockQuantity : Float?
    var stockUnit : String?
    var purchaseDate : String?
    var expiryDate : String?
    var storageLocation : String?
    var category : String?
    var subCategory : String?
    var price : Float?
    var vendorId : String?
    var productStatus : String?
    var productImages : NSArray?
    var unitPrice:Float?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map ["_id"]
        self.accountId <- map ["accountId"]
        self.accountEmailId <- map ["accountEmailId"]
        self.productUniqueNumber <- map ["productUniqueNumber"]
        self.productName <- map ["productName"]
        self.description <- map ["description"]
        self.stockQuantity <- map ["stockQuantity"]
        self.stockUnit <- map ["stockUnit"]
        self.purchaseDate <- map ["purchaseDate"]
        self.expiryDate <- map ["expiryDate"]
        self.storageLocation <- map ["storageLocation"]
        self.category <- map ["category"]
        self.subCategory <- map ["subCategory"]
        self.price <- map ["price"]
        self.vendorId <- map ["vendorId"]
        self.productStatus <- map ["productStatus"]
        self.productImages <- map ["productImages"]
        self.unitPrice <- map ["unitPrice"]

    }
}
