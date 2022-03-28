//
//  PriceUnitRespVo.swift
//  Lekhha
//
//  Created by USM on 01/12/21.
//

import Foundation
import ObjectMapper

class PriceUnitRespVo: Mappable {
        
    var message:String?
    var result:[PriceUnitResultVo]?
    var status:String?
    var statusCode:Int?
    
    init(message:String?,result:[PriceUnitResultVo]?,status:String?,statusCode:Int?) {
        
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
class PriceUnitResultVo: Mappable {
        
    
    var _id: String?
    var priceUnitDescription: String?
    var priceUnit: String?
    var status: Bool?
    var isDefault: Bool?
    var countryName: String?
    
    init(_id: String?,
          priceUnitDescription: String?,
          priceUnit: String?,
          status: Bool?,
          isDefault: Bool?,
          countryName: String?) {
        
        self._id = _id
        self.priceUnitDescription = priceUnitDescription
        self.priceUnit = priceUnit
        self.status = status
        self.isDefault = isDefault
        self.countryName = countryName
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map["_id"]
        self.priceUnitDescription <- map["priceUnitDescription"]
        self.priceUnit <- map["priceUnit"]
        self.status <- map["status"]
        self.isDefault <- map["isDefault"]
        self.countryName <- map["countryName"]
        
    }
}
/*
 {
     "STATUS_MSG": "SUCCESS",
     "STATUS_CODE": 200,
     "result": [
         {
             "_id": "616fd4205041085a07d69b1a",
             "priceUnitDescription": "Indian Rupees",
             "priceUnit": "₹",
             "status": true,
             "isDefault": false,
             "countryName": "IND"
         }
     ]
 }
 */
