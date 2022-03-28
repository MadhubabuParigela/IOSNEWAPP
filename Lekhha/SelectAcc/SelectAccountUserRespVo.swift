//
//  SelectAccountUserRespVo.swift
//  Lekhha
//
//  Created by USM on 01/02/22.
//

import Foundation
import ObjectMapper

class SelectAccountUserRespVo: Mappable {
    
    var message:String?
    var result:[SelectAccountUserResultVo]?
    var status:String?
    var statusCode:Int?

    init(message:String?,result:[SelectAccountUserResultVo]?,status:String?,statusCode:Int?) {
        self.message = message
        self.result = result
        self.status = status
        self.statusCode = statusCode

    }
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
        self.message <- map ["message"]
        self.result <- map ["result"]
        self.status <- map ["STATUS_MSG"]
        statusCode <- map["STATUS_CODE"]
        
    }
}
