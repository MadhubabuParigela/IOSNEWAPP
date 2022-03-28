//
//  OrderHistoryResultVo.swift
//  Lekhha
//
//  Created by USM on 23/11/21.
//

import Foundation
import ObjectMapper

class OrderHistoryResultVo: Mappable {
    
    var accountId: String?
    var accountEmailId: String?
    var status: Bool?
    var createdDate: String?
    var purchaseDate: String?
    var _id :Int64?
    var productsList : [OrderListVo]?
    var ordersList : [AnyObject]?
   
    var orderId : String?
    var vendorId : String?
    var vendorName : String?
    
    init(productId:String?,productsList:[OrderListVo]?,_id:String?, accountId: String?,
          accountEmailId: String?,
          orderId: String?,
          status: Bool?,
          createdDate: String?, ordersList : [AnyObject]?,purchaseDate: String?) {
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map ["_id"]
        self.productsList <- map["ordersList"]
        self.orderId <- map["orderId"]
        self.vendorId <- map["vendorId"]
        self.vendorName <- map["vendorName"]
        self.accountId <- map["accountId"]
        self.accountEmailId <- map["accountEmailId"]
        self.orderId <- map["orderId"]
        self.status <- map["status"]
        self.createdDate <- map["createdDate"]
        self.ordersList <-  map["ordersList"]
        self.purchaseDate <-  map["purchaseDate"]

    }
}
