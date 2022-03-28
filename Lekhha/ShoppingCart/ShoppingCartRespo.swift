//
//  File.swift
//  Lekha
//
//  Created by Mallesh Kurva on 15/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class ShoppingCartRespo: Mappable {
        
    var message:String?
    var result:[ShoppingCartResult]?
    var result1:[AnyObject]?
    var pageContentResult:[AnyObject]?
    var status:String?
    var statusCode:Int?
    var shoppingCartresult:[ShoppingCartResult]?
    
    init(message:String?,result:[ShoppingCartResult]?,status:String?,statusCode:Int?,result1:[AnyObject]?,pageContentResult:[AnyObject]?) {
        
        self.message = message
        self.result = result
        self.status = status
        self.statusCode = statusCode
        self.result1 = result1
        self.pageContentResult = pageContentResult
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        message <- map["message"]
        result <- map["result"]
        status <- map["STATUS_MSG"]
        statusCode <- map["STATUS_CODE"]
        shoppingCartresult <- map["shoppingCartresult"]
        result1 <- map["result"]
        pageContentResult <- map["pageContentResult"]
        
    }
    
    
}
