//
//  GetStorageLocationMasterRespVo.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import Foundation
import ObjectMapper

class GetStorageLocationMasterRespVo: Mappable {
    
    // MARK: Variable Declaration
    
        var result: [GetStorageLocationMasterResultVo]?
        var STATUS_CODE: Int?
        var STATUS_MSG: String?

    // MARK: JSON Object Initialization
    
        init(result: [GetStorageLocationMasterResultVo]?,
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
class GetStorageLocationMasterResultVo: Mappable {
    
    //chat model class
    
    var _id: String?
    var accountId: String?
    var slocName: String?
    var slocDescription: String?
    var hierachyLevel: Int?
    var parentLocation: String?
    var isDefault: Bool?
    var canEdit: Bool?
    
    // MARK: JSON Object Initialization
    init(_id: String?,
          accountId: String?,
           slocName: String?,
           slocDescription: String?,
           hierachyLevel: Int?,
           parentLocation: String?,
           isDefault: Bool?,
           canEdit: Bool?) {
       
        self._id = _id
        self.accountId = accountId
        self.slocName = slocName
        self.slocDescription = slocDescription
        self.hierachyLevel = hierachyLevel
        self.parentLocation = parentLocation
        self.isDefault = isDefault
        self.canEdit = canEdit
    }
    required init?(map: Map) {
    
   }
    
    // MARK: JSON Object Initialization

    func mapping(map: Map) {
                    
        self._id <- map ["_id"]
        self.accountId <- map ["accountId"]
        self.slocName <- map ["slocName"]
        self.slocDescription <- map ["slocDescription"]
        self.hierachyLevel <- map ["hierachyLevel"]
        self.parentLocation <- map ["parentLocation"]
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
             "_id": "61780acf0679a76022739c27",
             "accountId": "61780acf0679a76022739c25",
             "slocName": "NA",
             "slocDescription": "NA",
             "hierachyLevel": 1,
             "parentLocation": null,
             "isDefault": true,
             "canEdit": false
         },
         {
             "_id": "617bea22a4a519788c645db4",
             "accountId": "61780acf0679a76022739c25",
             "slocName": "6d6f",
             "slocDescription": "yxyf",
             "hierachyLevel": 1,
             "parentLocation": null,
             "isDefault": false,
             "canEdit": true
         }
     ]
 }
 */
