//
//  GlobalFiltersRespo.swift
//  Lekha
//
//  Created by USM on 02/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class GlobalFiltersRespo: Mappable {
        
    var message:String?
    var currentInventoryResult:[CurrentInventoryResult]?
    var shoppingCartManagementresult:[CurrentInventoryResult]?
    var openOrdersManagementresult:[CurrentInventoryResult]?
    var orderHistoryManagementresult:[CurrentInventoryResult]?
    var status:String?
    var statusCode:Int?
    
    init(message:String?,result:[CurrentInventoryResult]?,status:String?,statusCode:Int?) {
        
        self.message = message
        self.currentInventoryResult = result
        self.status = status
        self.statusCode = statusCode
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        message <- map["message"]
        currentInventoryResult <- map["currentInventoryresult"]
        shoppingCartManagementresult <- map["shoppingCartManagementresult"]
        openOrdersManagementresult <- map["openOrdersManagementresult"]
        orderHistoryManagementresult <- map["orderHistoryManagementresult"]
        status <- map["STATUS_MSG"]
        statusCode <- map["STATUS_CODE"]
        
    }
}
