//
//  OrdersHistoryProducts.swift
//  Lekha
//
//  Created by Mallesh Kurva on 17/11/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class OrdersHistoryProducts: Mappable {
    
    var _id : String?
    var accountId : String?
    var productDetails : OrdersHistoryProductDetails?
    var trancationId : String?
    var productId : String?
    var orderedQuantity : Int?
    var orderStatus : String?
    var unitPrice: Float?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {

        _id <- map["message"]
        accountId <- map["result"]
        productDetails <- map["productdetails"]
        productId <- map["productId"]
        trancationId <- map["trancationId"]
        orderedQuantity <- map["updatingQuantity"]
        orderStatus <- map["orderStatus"]
        unitPrice <- map["unitPrice"]

    }
}
