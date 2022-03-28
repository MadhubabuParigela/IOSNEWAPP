//
//  CurrentInventoryProductDetailResp.swift
//  Lekha
//
//  Created by Mallesh Kurva on 09/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

//productdetails =     {
//    accountEmailId = "madhura2419@gmail.com";
//    accountId = 5f6d8109950eaf1c4bfea974;
//    addedByUserId = 5f6d80e4950eaf1c4bfea973;
//    borrowed = yes;
//    category = xb;
//    description = dc;
//    expiryDate = "2020-10-28T00:00:00.000Z";
//    price = 789;
//    productImages =    (
//                    {
//            0 = "5f6dbc8e54fe7d404d64c523_0";
//            1 = "5f6dbc8e54fe7d404d64c523_1";
//            2 = "5f6dbc8e54fe7d404d64c523_2";
//        }
//    );
//    productManuallyAddOrAutoMovedDate = "2020-09-25T09:46:54.545Z";
//    productName = rrrr;
//    productStatus = Available;
//    productUniqueNumber = hxgx;
//    purchaseDate = "2020-09-22T00:00:00.000Z";
//    status = 1;
//    stockQuantity = "<null>";
//    stockUnit = xv;
//    storageLocation = xvv;
//    subCategory = fh;
//    uploadType = manual;
//};

class CurrentInventoryProductDetailResp: Mappable {
    
    var accountEmailId:String?
    var accountId:String?
    var addedByUserId : String?
    var borrowed : String?
    var description : String?
    var expiryDate : String?
    var price : Float?
    var productUniqueNumber : String?
    var productName : String?
    var stockQuantity : Float?
    var stockUnit : String?
    var storageLocation : String?
    var productImages : NSArray?
    var unitPrice: Float?
    
    init(accountEmailId:String?,accountId:String?,addedByUserId:String?,borrowed:String?,description:String?,expiryDate:String?,price:Float?,productUniqueNumber:String?,productName:String?,stockQuantity:Float?,stockUnit:String?,storageLocation:String?,productImages:[NSArray], unitPrice: Float?) {
        
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
        self.unitPrice <- map ["unitPrice"]

    }
}
