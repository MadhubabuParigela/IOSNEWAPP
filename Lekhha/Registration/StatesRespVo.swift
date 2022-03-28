//
//  StatesRespVo.swift
//  Lekhha
//
//  Created by USM on 26/10/21.
//

import Foundation
import ObjectMapper
/*"STATUS_MSG": "SUCCESS",
   "STATUS_CODE": 200,
   "result": [
       {
           "_id": "616fd5365041085a07d69b1b",
           "stateName": "Andhra Pradesh",
           "stateCode": "AP",
           "stateDescription": "Andhra Pradesh",
           "status": true,
           "countryName": "INDIA"
       }
]
*/

class StatesRespVo: Mappable {
        
    var result:[StatesResultVo]?
    var STATUS_MSG:String?
    var STATUS_CODE:Int?
    
    init(result:[StatesResultVo]?,
     STATUS_MSG:String?,
     STATUS_CODE:Int?) {
        
        self.result = result
        self.STATUS_MSG = STATUS_MSG
        self.STATUS_CODE = STATUS_CODE
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.result <- map["result"]
        self.STATUS_MSG <- map["STATUS_MSG"]
        self.STATUS_CODE <- map["STATUS_CODE"]
        
    }
}

