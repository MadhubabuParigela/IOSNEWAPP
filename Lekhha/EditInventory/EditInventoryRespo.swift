//
//  EditInventoryRespo.swift
//  Lekha
//
//  Created by USM on 04/12/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class EditInventoryRespo: Mappable {
        
    var message:String?
    var result:[EditInventoryResult]?
    var status:String?
    var statusCode:Int?
    
    init(message:String?,result:[EditInventoryResult]?,status:String?,statusCode:Int?) {
        
        self.message = message
        self.result = result
        self.status = status
        self.statusCode = statusCode
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        message <- map["message"]
        result <- map["result"]
        status <- map["STATUS_MSG"]
        statusCode <- map["STATUS_CODE"]
        
    }
}
