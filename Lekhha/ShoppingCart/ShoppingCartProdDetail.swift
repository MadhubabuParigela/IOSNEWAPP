//
//  ShoppingCartProdDetail.swift
//  Lekha
//
//  Created by Mallesh Kurva on 15/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class ShoppingCartProdDetail: Mappable {
    
//    {
//        accountEmailId = "madhura2419@gmail.com";
//        addedByUserId = 5f3a6361a2bab75afd9e9990;
//        borrowed = "yes ";
//        category = dfgdg;
//        description = sxzczcz;
//        expiryDate = "2020-10-31T00:00:00.000Z";
//        id = 40;
//        orderId = ewewsdf;
//        price = 234;
//        productImages =         (
//                        {
//                0 = "5f87ee5a48722c01ad5394c8_0";
//                1 = "5f87ee5a48722c01ad5394c8_1";
//                2 = "5f87ee5a48722c01ad5394c8_2";
//            }
//        );
//        productManuallyAddOrAutoMovedDate = "2020-10-15T06:38:18.536Z";
//        productName = dsfs;
//        productStatus = Available;
//        productUniqueNumber = 56498456156496564561564;
//        purchaseDate = "2020-08-08T00:00:00.000Z";
//        stockQuantity = 10;
//        stockUnit = kgs;
//        storageLocation = dsfs;
//        subCategory = sadd;
//        uploadType = scan;
//        vendorId = sds;
//    }
    
    var accountEmailId:String?
    var category:String?
    var description : String?
    var expiryDate : String?
    var orderId : String?
    var price : Float?
    var productUniqueNumber : String?
    var productName : String?
    var stockQuantity : Float?
    var stockUnit : String?
    var storageLocation : String?
    var purchaseDate : String?
    var subCategory: String?
    var productImages : NSArray?
    var vendorId : String?
    var unitPrice: Float?
    
    
    init(accountEmailId:String?,category:String?,description:String?,expiryDate:String?,orderId:String?,price:Int?,productUniqueNumber:String?,productName:String?,stockQuantity:Int?,stockUnit:String?,storageLocation:String?,purchaseDate:String?,subCategory:String?,productImages:NSArray?,unitPrice: Float?) {
        
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
        self.productName <- map["productName"]
        self.vendorId <- map["vendorId"]
        self.unitPrice <- map["unitPrice"]
        
    }
}
