//
//  LocalSortRespo.swift
//  Lekha
//
//  Created by USM on 19/01/21.
//  Copyright © 2021 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class LocalSortRespo: Mappable {
        
    var message:String?
    var result:[ShoppingCartResult]?
    var status:String?
    var statusCode:Int?
    
    init(message:String?,result:[ShoppingCartResult]?,status:String?,statusCode:Int?) {
        
        self.message = message
        self.result = result
        self.status = status
        self.statusCode = statusCode
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        message <- map["message"]
        result <- map["shoppingCartresult"]
        status <- map["STATUS_MSG"]
        statusCode <- map["STATUS_CODE"]
        
    }
}
