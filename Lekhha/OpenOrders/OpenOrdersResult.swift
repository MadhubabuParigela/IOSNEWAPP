//
//  OpenOrdersResult.swift
//  Lekha
//
//  Created by Mallesh Kurva on 17/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class OpenOrdersResult: Mappable {
    
    var _id :String?
    var productsList : [OpenOrdersProducts]?
    var accountId : String?
    var orderId : String?
    var vendorId : String?
    var vendorName : String?
    var purchaseDate : String?
    var orderList : NSMutableArray?

    init(productId:String?,productDict:[OpenOrdersProducts]?,_id:String?) {
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map ["_id"]
        self.productsList <- map["ordersList"]
        self.accountId <- map["accountId"]
        self.orderId <- map["orderId"]
        self.vendorId <- map["vendorId"]
        self.vendorName <- map["vendorName"]
        self.purchaseDate <- map["purchaseDate"]
        self.orderList <- map["ordersList"]
//        self.vendordetails <- map["vendordetails"]
    }
}

