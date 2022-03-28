//
//  StockUnitMasterRespVo.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import Foundation
import ObjectMapper

class StockUnitMasterRespVo: Mappable {
    
    // MARK: Variable Declaration
    
        var result: [StockUnitMasterResultVo]?
        var STATUS_CODE: Int?
        var STATUS_MSG: String?

    // MARK: JSON Object Initialization
    
        init(result: [StockUnitMasterResultVo]?,
         STATUS_CODE: Int?,
         STATUS_MSG: String?) {
            
            self.result = result
            self.STATUS_CODE = STATUS_CODE
            self.STATUS_MSG = STATUS_MSG
        }
    
        required init?(map: Map) {
        
       }
    
    // MARK: JSON Object Mapping
    
        func mapping(map: Map) {
            
            self.result <- map ["result"]
            self.STATUS_CODE <- map ["STATUS_CODE"]
            self.STATUS_MSG <- map ["STATUS_MSG"]
       
      }
  }

class StockUnitMasterResultVo: Mappable {
    
    //chat model class
    var _id: String?
    var accountId: String?
    var stockUnitDescription: String?
    var stockUnitName: String?
    var isDefault: Bool?
    var canEdit: Bool?
    
    // MARK: JSON Object Initialization
    init(_id: String?,
          accountId: String?,
          stockUnitDescription: String?,
          stockUnitName: String?,
          isDefault: Bool?,
          canEdit: Bool?) {
       
        self._id = _id
        self.accountId = accountId
        self.stockUnitDescription = stockUnitDescription
        self.stockUnitName = stockUnitName
        self.isDefault = isDefault
        self.canEdit = canEdit        
    }
    required init?(map: Map) {
    
   }
    
    // MARK: JSON Object Initialization

    func mapping(map: Map) {
                    
        self._id <- map ["_id"]
        self.accountId <- map ["accountId"]
        self.stockUnitDescription <- map ["stockUnitDescription"]
        self.stockUnitName <- map ["stockUnitName"]
        self.isDefault <- map ["isDefault"]
        self.canEdit <- map ["canEdit"]
        
  }
  }

/*
 {
     "STATUS_MSG": "SUCCESS",
     "STATUS_CODE": 200,
     "result": [
         {
             "_id": "61780acf0679a76022739c26",
             "accountId": "61780acf0679a76022739c25",
             "stockUnitDescription": "NA",
             "stockUnitName": "NA",
             "isDefault": true,
             "canEdit": false
         },
         {
             "_id": "617be659a4a519788c645db3",
             "accountId": "61780acf0679a76022739c25",
             "stockUnitDescription": "r7du",
             "stockUnitName": "ycyyc",
             "isDefault": false,
             "canEdit": true
         }
     ]
 }
 */
