//
//  MobileRespVo.swift
//  Lekhha
//
//  Created by USM on 17/03/22.
//

import Foundation
import ObjectMapper

class MobileRespVo: Mappable {
        
    var message:String?
    var result:[MobileResultVo]?
    var status:String?
    var statusCode:Int?
    var pageContentResult:[PageContentResultVo]?
    
    init(message:String?,result:[MobileResultVo]?,status:String?,statusCode:Int?,pageContentResult:[PageContentResultVo]?) {
        
        self.message = message
        self.result = result
        self.status = status
        self.statusCode = statusCode
        self.pageContentResult = pageContentResult
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        message <- map["message"]
        result <- map["result"]
        status <- map["STATUS_MSG"]
        statusCode <- map["STATUS_CODE"]
        pageContentResult <- map["pageContentResult"]
        
    }
}
class MobileResultVo: Mappable {
    
    var _id: String?
    var mobileNumber: String?
    var countryCode: String?
    var networkCode: String?
    var mobileOTP: Int?
    var mobileStatus: String?
    var emailId: String?
    var hash: String?
    var loginDeviceInfo: LoginDeviceInfoVo?
    var privacypolicy_accepted_version: String?
    var salt: String?
    var signUpDeviceInfo: LoginDeviceInfoVo?
    var status: Bool?
    var termsandconditions_accepted_version: String?
    var userId: String?
    var dateOfBirth: String?
    var firstName: String?
    var gender: String?
    var lastName: String?
    
    init(_id: String?,
           mobileNumber: String?,
           countryCode: String?,
           networkCode: String?,
           mobileOTP: Int?,
           mobileStatus: String?,
           emailId: String?,
           hash: String?,
           loginDeviceInfo: LoginDeviceInfoVo?,
           privacypolicy_accepted_version: String?,
           salt: String?,
           signUpDeviceInfo: LoginDeviceInfoVo?,
           status: Bool?,
           termsandconditions_accepted_version: String?,
           userId: String?,
           dateOfBirth: String?,
           firstName: String?,
           gender: String?,
           lastName: String?) {
        
        self._id = _id
        self.mobileNumber = mobileNumber
        self.countryCode = countryCode
        self.networkCode = networkCode
        self.mobileOTP = mobileOTP
        self.mobileStatus = mobileStatus
        self.emailId = emailId
        self.hash = hash
        self.loginDeviceInfo = loginDeviceInfo
        self.privacypolicy_accepted_version = privacypolicy_accepted_version
        self.salt = salt
        self.signUpDeviceInfo = signUpDeviceInfo
        self.status = status
        self.termsandconditions_accepted_version = termsandconditions_accepted_version
        self.userId = userId
        self.dateOfBirth = dateOfBirth
        self.firstName = firstName
        self.gender = gender
        self.lastName = lastName
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map["_id"]
        self.mobileNumber <- map["mobileNumber"]
        self.countryCode <- map["countryCode"]
        self.networkCode <- map["networkCode"]
        self.mobileOTP <- map["mobileOTP"]
        self.mobileStatus <- map["mobileStatus"]
        self.emailId <- map["emailId"]
        self.hash <- map["hash"]
        self.loginDeviceInfo <- map["loginDeviceInfo"]
        self.privacypolicy_accepted_version <- map["privacypolicy_accepted_version"]
        self.salt <- map["salt"]
        self.signUpDeviceInfo <- map["signUpDeviceInfo"]
        self.status <- map["status"]
        self.termsandconditions_accepted_version <- map["termsandconditions_accepted_version"]
        self.userId <- map["userId"]
        self.dateOfBirth <- map["dateOfBirth"]
        self.firstName <- map["firstName"]
        self.gender <- map["gender"]
        self.lastName <- map["lastName"]
        
    }
}
class PageContentResultVo: Mappable {
        
    var message:String?
    var result:[MobileResultVo]?
    var status:String?
    var statusCode:Int?
    var pageContentResult:[NSArray]?
    
    var _id: String?
    var screenName: String?
    var version: String?
    var title: String?
    
    init( _id: String?,
     screenName: String?,
     version: String?,
     title: String?){
        self._id = _id
        self.screenName = screenName
        self.version = version
        self.title = title
    }
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        
        self._id <- map["_id"]
        self.screenName <- map["screenName"]
        self.version <- map["version"]
        self.title <- map["title"]
    }
}

/*
 {
     "STATUS_MSG": "Error",
     "STATUS_CODE": 202,
     "message": "Mobile Number Already Existed",
     "result": [
         {
             "_id": "62320b0d1cafe02a79302176",
             "mobileNumber": "956d5ed272b73f53ce463d1f33f41fe3",
             "countryCode": "IND",
             "networkCode": "+91",
             "mobileOTP": 3650,
             "mobileStatus": "Completed",
             "emailId": "e4ff36f31dc92630480fe14ae9eb661ce4ffdbefdc8fb51d56d49c9ce2834886",
             "hash": "a1a4885a48666acad8c35e3800d8d1edf9a0117bd6e95609f29cc070011c728b5dcad39fcfecf5d5a9259a0a6aefbb4dc5750a939c8d738cc356fec0a1f670ec",
             "loginDeviceInfo": {
                 "appVersion": "3.3.2",
                 "basebandVersion": "710_GEN_PACK-1.403126.1.404425.1,710_GEN_PACK-1.403126.1.404425.1",
                 "buildNo": "RP1A.200720.012 release-keys",
                 "deviceName": "1951",
                 "kernelVersion": "4.9.227-perf+",
                 "lattitude": "NA",
                 "longitude": "NA",
                 "manufacture": "vivo",
                 "model": "vivo 1951",
                 "osVersion": "11",
                 "serial": "unknown"
             },
             "privacypolicy_accepted_version": "1",
             "salt": "d8e6e7e3464e694fdf0e5950bb2df6b74d606174215c7e3b2370d41df11d72be",
             "signUpDeviceInfo": {
                 "appVersion": "3.3.2",
                 "basebandVersion": "710_GEN_PACK-1.403126.1.404425.1,710_GEN_PACK-1.403126.1.404425.1",
                 "buildNo": "RP1A.200720.012 release-keys",
                 "deviceName": "1951",
                 "kernelVersion": "4.9.227-perf+",
                 "lattitude": "NA",
                 "longitude": "NA",
                 "manufacture": "vivo",
                 "model": "vivo 1951",
                 "osVersion": "11",
                 "serial": "unknown"
             },
             "status": true,
             "termsandconditions_accepted_version": "1",
             "userId": "hpZRS3gf",
             "dateOfBirth": "1990-06-05T00:00:00.000Z",
             "firstName": "f033ff89e8252a711b2e0ced7102e802",
             "gender": "Male",
             "lastName": "d993df3e05aa2398f25436f9ba501438"
         }
     ],
     "pageContentResult": [
         {
             "_id": "622b227dcd001522bc9f0914",
             "screenName": "privacypolicy",
             "version": "1",
             "title": "privacy policy"
         },
         {
             "_id": "622b229f82900422bcfa2b37",
             "screenName": "termsandconditions",
             "version": "1",
             "title": "terms and conditions"
         }
     ]
 }
 */
