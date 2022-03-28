//
//  GetAccountConsumerResultVo.swift
//  Lekhha
//
//  Created by USM on 27/11/21.
//

import Foundation
import ObjectMapper

class GetAccountConsumerResultVo: Mappable {
    
    var _id: String?
    var userId: String?
    var accountId: String?
    var primaryUser: String?
    var dateOfCreation: String?
    var status: Bool?
    var modulePermissions: ModulePermissionsVo?
    var accountDetails: AccountinfoVo?
    var userDetails: UserinfoVo?
    
    init(_id: String?,
          userId: String?,
          accountId: String?,
          primaryUser: String?,
          dateOfCreation: String?,
          status: Bool?,
          modulePermissions: ModulePermissionsVo?,
          accountDetails: AccountinfoVo?,
          userDetails: UserinfoVo?) {
        
        self._id = _id
        self.userId = userId
        self.accountId = accountId
        self.primaryUser = primaryUser
        self.dateOfCreation = dateOfCreation
        self.status = status
        self.modulePermissions = modulePermissions
        self.accountDetails = accountDetails
        self.userDetails = userDetails
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map["_id"]
        self.userId <- map["userId"]
        self.accountId <- map["accountId"]
        self.primaryUser <- map["primaryUser"]
        self.dateOfCreation <- map["dateOfCreation"]
        self.status <- map["status"]
        self.modulePermissions <- map["modulePermissions"]
        self.accountDetails <- map["accountDetails"]
        self.userDetails <- map["userDetails"]
        
    }
}
class ModulePermissionsVo: Mappable {
    
    var currentInventory_management: Bool?
    var openOrders_management: Bool?
    var shoppingCart_management: Bool?
    var orderHistory_management: Bool?
    var vendors_management: Bool?
    
    init(currentInventory_management: Bool?,
           openOrders_management: Bool?,
           shoppingCart_management: Bool?,
           orderHistory_management: Bool?,
           vendors_management: Bool?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
               currentInventory_management <- map["currentInventory_management"]
               openOrders_management <- map["openOrders_management"]
               shoppingCart_management <- map["shoppingCart_management"]
               orderHistory_management <- map["orderHistory_management"]
               vendors_management <- map["vendors_management"]
        
    }
}
