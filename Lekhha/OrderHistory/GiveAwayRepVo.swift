//
//  GiveAwayRepVo.swift
//  Lekhha
//
//  Created by USM on 18/01/22.
//

import Foundation
import ObjectMapper

class GiveAwayRepVo: Mappable {
        
    var result:[GiveAwayResultVo]?
    var status:String?
    var statusCode:Int?
    var message:String?
    
    init(result:[GiveAwayResultVo]?,status:String?,statusCode:Int?, message:String?) {
        
        self.result = result
        self.status = status
        self.statusCode = statusCode
        self.message = message
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        result <- map["result"]
        status <- map["STATUS_MSG"]
        statusCode <- map["STATUS_CODE"]
        message <- map["message"]
    }
}
/*
 {
     "STATUS_MSG": "SUCCESS",
     "STATUS_CODE": 200,
     "result": [
         
     ]
 }
 */
