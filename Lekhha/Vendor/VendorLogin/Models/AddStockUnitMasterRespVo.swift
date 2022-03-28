//
//  AddStockUnitMasterRespVo.swift
//  Lekhha
//
//  Created by USM on 05/11/21.
//

import Foundation
import ObjectMapper

class AddStockUnitMasterRespVo: Mappable {
    
    // MARK: Variable Declaration
    
        var message: String?
        var STATUS_CODE: Int?
        var STATUS_MSG: String?

    // MARK: JSON Object Initialization
    
        init(message: String?,
         STATUS_CODE: Int?,
         STATUS_MSG: String?) {
            
            self.message = message
            self.STATUS_CODE = STATUS_CODE
            self.STATUS_MSG = STATUS_MSG
        }
    
        required init?(map: Map) {
        
       }
    
    // MARK: JSON Object Mapping
    
        func mapping(map: Map) {
            
            self.message <- map ["message"]
            self.STATUS_CODE <- map ["STATUS_CODE"]
            self.STATUS_MSG <- map ["STATUS_MSG"]
       
      }
  }
