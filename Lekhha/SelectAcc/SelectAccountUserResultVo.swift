//
//  SelectAccountUserResultVo.swift
//  Lekhha
//
//  Created by USM on 01/02/22.
//

import Foundation
import ObjectMapper

class SelectAccountUserResultVo: Mappable {
    
    var _id:String?
    var emailAddress:String?
    var accountDetails:[String:AnyObject]?
    
     init(_id:String?,emailAddress:String?,accountDetails:[String:AnyObject]?) {
        
        self._id = _id
        self.emailAddress = emailAddress
        self.accountDetails = accountDetails
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self._id <- map["_id"]
        self.emailAddress <- map["emailAddress"]
        self.accountDetails <- map["accountDetails"]
    }
}
