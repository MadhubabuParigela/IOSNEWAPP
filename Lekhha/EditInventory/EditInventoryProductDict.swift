//
//  EditInventoryProductDict.swift
//  Lekha
//
//  Created by USM on 04/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class EditInventoryProductDict: Mappable {
    
//    {
//        accountEmailId = "shalini@gmail.com";
//        accountId = 5f8970b099c2f076c8c54af6;
//        addedByUserId = 5fb2170aedafde33e809a05e;
//        borrowed = "yes ";
//        category = utilities;
//        description = sdfsdf;
//        expiryDate = "2021-02-19T00:00:00.000Z";
//        lastMOdificationsDoneByUserId = 5f89319899c2f076c8c54ae6;
//        orderId = d4325;
//        price = 34;
//        productImages =         (
//                        {
//                0 = "5fb2170aedafde33e809a05f_0";
//            }
//        );
//        productManuallyAddOrAutoMovedDate = "2020-11-16T06:07:06.132Z";
//        productName = testtodyrrrrr;
//        productStatus = Available;
//        productUniqueNumber = rfrsfcsd;
//        purchaseDate = "2020-11-10T00:00:00.000Z";
//        status = 1;
//        stockQuantity = 0;
//        stockUnit = kgs;
//        storageLocation = fdgds;
//        subCategory = pens;
//        uploadType = Manually;
//        vendorId = sds;
//    }
    
    var accountEmailId:String?
    var accountId:String?
    var addedByUserId : String?
    var borrowed : String?
    var category : String?
    var description : String?
    var expiryDate : String?
    var price : Float?
    var orderId:String?
    var productUniqueNumber : String?
    var productName : String?
    var purchaseDate:String?
    var productStatus:String?
    var stockQuantity : Float?
    var stockUnit : String?
    var storageLocation : String?
    var subCategory:String?
    var productImages : NSArray?
    var vendorId:String?
    var unitPrice:Float?
    var productManuallyAddOrAutoMovedDate:String?
    
    init(accountEmailId:String?,accountId:String?,addedByUserId:String?,borrowed:String?,description:String?,expiryDate:String?,price:String?,productUniqueNumber:String?,productName:String?,stockQuantity:Float?,stockUnit:String?,storageLocation:String?,productImages:[NSArray], unitPrice:Float?,productManuallyAddOrAutoMovedDate:String?) {
        
        self.accountEmailId = accountEmailId
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.accountEmailId <- map ["accountEmailId"]
        self.accountId <- map ["accountId"]
        self.addedByUserId <- map ["addedByUserId"]
        self.borrowed <- map ["borrowed"]
        self.description <- map ["description"]
        self.expiryDate <- map ["expiryDate"]
        self.price <- map ["price"]
        self.productUniqueNumber <- map ["productUniqueNumber"]
        self.productName <- map ["productName"]
        self.stockQuantity <- map ["stockQuantity"]
        self.stockUnit <- map ["stockUnit"]
        self.storageLocation <- map ["storageLocation"]
        self.productImages <- map ["productImages"]
        self.category <- map["category"]
        self.purchaseDate <- map["purchaseDate"]
        self.productStatus <- map["productStatus"]
        self.subCategory <- map["subCategory"]
        self.vendorId <- map["vendorId"]
        self.orderId <- map["orderId"]
        self.unitPrice <- map["unitPrice"]
        self.productManuallyAddOrAutoMovedDate <- map["productManuallyAddOrAutoMovedDate"]
    }
}
