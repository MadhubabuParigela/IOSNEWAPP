//
//  StatesResultVo.swift
//  Lekhha
//
//  Created by USM on 26/10/21.
//

import Foundation
import ObjectMapper

/*
 {
     "_id": "616fd5365041085a07d69b1b",
     "stateName": "Andhra Pradesh",
     "stateCode": "AP",
     "stateDescription": "Andhra Pradesh",
     "status": true,
     "countryName": "INDIA"
 }
 */

class StatesResultVo: Mappable {
        
    var _id: String?
    var stateName: String?
    var stateCode: String?
    var stateDescription: String?
    var status: Bool?
    var countryName: String?
    
    init( _id: String?,
          stateName: String?,
          stateCode: String?,
          stateDescription: String?,
          status: Bool?,
          countryName: String?) {
        
        self._id = _id
        self.stateName = stateName
        self.stateCode = stateCode
        self.stateDescription = stateDescription
        self.status = status
        self.countryName = countryName
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map["_id"]
        self.stateName <- map["stateName"]
        self.stateCode <- map["stateCode"]
        self.stateDescription <- map["stateDescription"]
        self.status <- map["status"]
        self.countryName <- map["countryName"]
        
    }
}
