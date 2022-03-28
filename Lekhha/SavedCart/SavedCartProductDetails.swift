//
//  SavedCartProductDetails.swift
//  Lekha
//
//  Created by Mallesh Kurva on 15/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class SavedCartProductDetails: Mappable {
    
    var accountEmailId:String?
    var category:String?
    var description : String?
    var expiryDate : String?
    var orderId : String?
    var price : Float?
    var productUniqueNumber : String?
    var productName : String?
    var stockQuantity : Int?
    var stockUnit : String?
    var storageLocation : String?
    var purchaseDate : String?
    var subCategory: String?
    var productImages : NSArray?
    var vendorId : String?
    var unitPrice : Float?

    init(accountEmailId:String?,category:String?,description:String?,expiryDate:String?,orderId:String?,price:String?,productUniqueNumber:String?,productName:String?,stockQuantity:Int?,stockUnit:String?,storageLocation:String?,purchaseDate:String?,subCategory:String?,productImages:NSArray?,vendorId:String?,unitPrice : Float?) {
        
    }
    required init?(map: Map) {
            
    }
    
    func mapping(map: Map) {
            
        self.accountEmailId <- map ["accountEmailId"]
        self.category <- map ["category"]
        self.description <- map ["description"]
        self.expiryDate <- map ["expiryDate"]
        self.orderId <- map ["orderId"]
        self.price <- map ["price"]
        self.productUniqueNumber <- map ["productUniqueNumber"]
        self.stockQuantity <- map ["stockQuantity"]
        self.stockUnit <- map ["stockUnit"]
        self.storageLocation <- map ["storageLocation"]
        self.purchaseDate <- map ["purchaseDate"]
        self.subCategory <- map ["subCategory"]
        self.productImages <- map ["productImages"]
        self.vendorId <- map["vendorId"]
        self.productName <- map ["productName"]
        self.unitPrice <- map ["unitPrice"]

    }
}
