//
//  OrdersHistoryResult.swift
//  Lekha
//
//  Created by Mallesh Kurva on 17/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class OrdersHistoryResult: Mappable {
    
    var _id :Int64?
    var productsList : [OrdersHistoryProducts]?
    var orderId : String?
    var vendorId : String?
    var vendorName : String?
    
    init(productId:String?,productDict:[OrdersHistoryProducts]?,_id:String?) {
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map ["_id"]
        self.productsList <- map["ordersList"]
        self.orderId <- map["orderId"]
        self.vendorId <- map["vendorId"]
        self.vendorName <- map["vendorName"]

    }
}
