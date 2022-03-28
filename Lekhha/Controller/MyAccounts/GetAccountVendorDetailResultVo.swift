//
//  GetAccountVendorDetailResultVo.swift
//  Lekhha
//
//  Created by USM on 30/11/21.
//

import Foundation
import ObjectMapper

class GetAccountVendorDetailResultVo: Mappable {
    
    var _id: String?
    var userId: String?
    var accountId: String?
    var primaryUser: String?
    var setVicinity: Int?
    var soonToexpiryLeadTime: Int?
    var dateOfCreation: String?
    var status: Bool?
    var modulePermissions: ModulePermissionsVo?
    var kycVerification: String?
    var GSTIn: String?
    var aadharNumber: Int?
    var panNumber: String?
    var businessConstitution: String?
    var businessPlace: String?
    var dateOfReg: String?
    var legalName: String?
    var rejectionComment: String?
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
          userDetails: UserinfoVo?,
           setVicinity: Int?,
           soonToexpiryLeadTime: Int?,
           kycVerification: String?,
           GSTIn: String?,
           aadharNumber: Int?,
           panNumber: String?,
           businessConstitution: String?,
           businessPlace: String?,
           dateOfReg: String?,
           legalName: String?,
           rejectionComment: String?) {
        
        self._id = _id
        self.userId = userId
        self.accountId = accountId
        self.primaryUser = primaryUser
        self.dateOfCreation = dateOfCreation
        self.status = status
        self.modulePermissions = modulePermissions
        self.accountDetails = accountDetails
        self.userDetails = userDetails
        self.setVicinity = setVicinity
        self.soonToexpiryLeadTime = soonToexpiryLeadTime
        self.kycVerification = kycVerification
        self.GSTIn = GSTIn
        self.aadharNumber = aadharNumber
        self.panNumber = panNumber
        self.businessConstitution = businessConstitution
        self.businessPlace = businessPlace
        self.dateOfReg = dateOfReg
        self.legalName = legalName
        self.rejectionComment = rejectionComment
        
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
        
        self.setVicinity <- map["setVicinity"]
        self.soonToexpiryLeadTime <- map["soonToexpiryLeadTime"]
        self.kycVerification <- map["kycVerification"]
        self.GSTIn <- map["GSTIn"]
        self.aadharNumber <- map["aadharNumber"]
        self.panNumber <- map["panNumber"]
        self.businessConstitution <- map["businessConstitution"]
        self.businessPlace <- map["businessPlace"]
        self.dateOfReg <- map["dateOfReg"]
        self.legalName <- map["legalName"]
        self.rejectionComment <- map["rejectionComment"]
        
    }
}

