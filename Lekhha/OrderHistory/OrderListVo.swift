//
//  OrderListVo.swift
//  Lekhha
//
//  Created by USM on 23/11/21.
//

import Foundation
import ObjectMapper

class OrderListVo: Mappable {
    
    var productdetails: ProductdetailsVo?
    var vendordetails: VendordetailsVo?
    var stockUnitDetails: [StockUnitDetailsVo]?
    var storageLocationLevel1Details: [StorageLocationLevel1DetailsVo]?
    var storageLocationLevel2Details :[StorageLocationLevel2DetailsVo]?
    var storageLocationLevel3Details : [StorageLocationLevel3DetailsVo]?
    var priceUnitDetails : [PriceUnitDetailsVo]?
    var userInfoDetails: [UserinfoVo]?
    var accountInfoDetails: [AccountinfoVo]?
    var updatingQuantity : Float?
    var vendorApprovalStatus : String?
    var isExpandableRow : Bool?
    var productModifingDetails : [ProductModifingDetailsVo]?
    var cellHeight : Int?
    
    init(productdetails: ProductdetailsVo?,
     vendordetails: VendordetailsVo?,
     stockUnitDetails: [StockUnitDetailsVo]?,
     storageLocationLevel1Details: [StorageLocationLevel1DetailsVo]?,
     storageLocationLevel2Details :[StorageLocationLevel2DetailsVo]?,
     storageLocationLevel3Details : [StorageLocationLevel3DetailsVo]?,
     priceUnitDetails : [PriceUnitDetailsVo]?,
     updatingQuantity : Float?,
     vendorApprovalStatus : String?,isExpandableRow : Bool?,
     productModifingDetails : [ProductModifingDetailsVo]?,
     cellHeight :Int? ) {
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.productdetails <- map ["productdetails"]
        self.vendordetails <- map ["vendordetails"]
        self.stockUnitDetails <- map ["stockUnitDetails"]
        self.storageLocationLevel1Details <- map ["storageLocationLevel1Details"]
        self.storageLocationLevel2Details <- map ["storageLocationLevel2Details"]
        self.storageLocationLevel3Details <- map ["storageLocationLevel3Details"]
        self.priceUnitDetails <- map ["priceUnitDetails"]
        self.updatingQuantity <- map ["updatingQuantity"]
        self.vendorApprovalStatus <- map ["vendorApprovalStatus"]
        self.isExpandableRow <- map ["isExpandableRow"]
        self.productModifingDetails <- map ["productModifingDetails"]
        self.cellHeight <- map ["cellHeight"]
    }
}
class ProductdetailsVo: Mappable {
        
    var _id: String?
    var id: String?
    var accountId: String?
    var accountEmailId: String?
    var productUniqueNumber: String?
    var productName: String?
    var description: String?
    var stockQuantity: Double?
    var updatingQuantity:Float?
    var isUpdatedQuan:String?
    var stockUnit: String?
    var expiryDate: String?
    var purchaseDate: String?
    var storageLocation1: String?
    var storageLocation2: String?
    var storageLocation3: String?
    var borrowed: Any?
    var lent: Bool?
    var category: String?
    var subCategory: String?
    var otherCategoryName: String?
    var otherSubCategoryName: String?
    var priceUnit: String?
    var price: Double?
    var unitPrice: Double?
    var uploadType: String?
    var status: Bool?
    var orderId: String?
    var vendorId: String?
    var giveAwayStatus: Bool?
    var shared: Bool?
    var productStatus: String?
    var productManuallyAddOrAutoMovedDate: String?
    var addedByUserId: String?
    var productImages: NSArray?
    
    init(_id: String?,
          id: String?,
          accountId: String?,
          accountEmailId: String?,
          productUniqueNumber: String?,
          productName: String?,
          description: String?,
          stockQuantity: Double?,
          updatingQuantity:Float?,
          isUpdatedQuan:String?,
          stockUnit: String?,
          expiryDate: String?,
          purchaseDate: String?,
          storageLocation1: String?,
          storageLocation2: String?,
          storageLocation3: String?,
          borrowed: Any?,
          lent: Bool?,
          category: String?,
          subCategory: String?,
          otherCategoryName: String?,
          otherSubCategoryName: String?,
          priceUnit: String?,
          price: Double?,
          unitPrice: Double?,
          uploadType: String?,
          status: Bool?,
          orderId: String?,
          vendorId: String?,
          giveAwayStatus: Bool?,
          shared: Bool?,
          productStatus: String?,
          productManuallyAddOrAutoMovedDate: String?,
          addedByUserId: String?,
          productImages: NSArray?) {
        
        self._id = _id
        self.id = id
        self.accountId = accountId
        self.accountEmailId = accountEmailId
        self.productUniqueNumber = productUniqueNumber
        self.productName = productName
        self.description = description
        self.stockQuantity = stockQuantity
        self.updatingQuantity=updatingQuantity
        self.isUpdatedQuan=isUpdatedQuan
        self.stockUnit = stockUnit
        self.expiryDate = expiryDate
        self.purchaseDate = purchaseDate
        self.storageLocation1 = storageLocation1
        self.storageLocation2 = storageLocation2
        self.storageLocation3 = storageLocation3
        self.borrowed = borrowed
        self.lent = lent
        self.category = category
        self.subCategory = subCategory
        self.otherCategoryName = otherCategoryName
        self.otherSubCategoryName = otherSubCategoryName
        self.priceUnit = priceUnit
        self.price = price
        self.unitPrice = unitPrice
        self.uploadType = uploadType
        self.status = status
        self.orderId = orderId
        self.vendorId = vendorId
        self.giveAwayStatus = giveAwayStatus
        self.shared = shared
        self.productStatus = productStatus
        self.productManuallyAddOrAutoMovedDate = productManuallyAddOrAutoMovedDate
        self.addedByUserId = addedByUserId
        self.productImages = productImages
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map["_id"]
        self.id <- map["id"]
        self.accountId <- map["accountId"]
        self.accountEmailId <- map["accountEmailId"]
        self.productUniqueNumber <- map["productUniqueNumber"]
        self.productName <- map["productName"]
        self.description <- map["description"]
        self.stockQuantity <- map["stockQuantity"]
        self.stockUnit <- map["stockUnit"]
        self.expiryDate <- map["expiryDate"]
        self.purchaseDate <- map["purchaseDate"]
        self.storageLocation1 <- map["storageLocation1"]
        self.storageLocation2 <- map["storageLocation2"]
        self.storageLocation3 <- map["storageLocation3"]
        self.borrowed <- map["borrowed"]
        self.lent <- map["lent"]
        self.category <- map["categoryId"]
        self.subCategory <- map["subCategoryId"]
        self.otherCategoryName <- map["otherCategoryName"]
        self.otherSubCategoryName <- map["otherSubCategoryName"]
        self.priceUnit <- map["priceUnit"]
        self.price <- map["price"]
        self.unitPrice <- map["unitPrice"]
        self.uploadType <- map["uploadType"]
        self.status <- map["status"]
        self.orderId <- map["orderId"]
        self.vendorId <- map["vendorId"]
        self.giveAwayStatus <- map["giveAwayStatus"]
        self.shared <- map["shared"]
        self.productStatus <- map["productStatus"]
        self.productManuallyAddOrAutoMovedDate <- map["productManuallyAddOrAutoMovedDate"]
        self.addedByUserId <- map["addedByUserId"]
        self.productImages <- map["productImages"]
                
    }
}
class VendordetailsVo: Mappable {
        
    var _id: String?
    var accountId: String?
    var accountEmailId: String?
    var vendorName: String?
    var vendorDescription: String?
    var category: String?
    var subCategory: String?
    var otherCategoryName: String?
    var otherSubCategoryName: String?
    var vendorCompany: String?
    var vendorGSTIN: String?
    var vendorLocation: String?
    var vendorAddress: String?
    var status: Bool?
    var dateOfCreation: String?
    var canEdit: Bool?
    
    init(_id: String?,
          accountId: String?,
          accountEmailId: String?,
          vendorName: String?,
          vendorDescription: String?,
          category: String?,
          subCategory: String?,
          otherCategoryName: String?,
          otherSubCategoryName: String?,
          vendorCompany: String?,
          vendorGSTIN: String?,
          vendorLocation: String?,
          vendorAddress: String?,
          status: Bool?,
          dateOfCreation: String?,
          canEdit: Bool?) {
    
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        _id <- map["_id"]
        accountId <- map["accountId"]
        accountEmailId <- map["accountEmailId"]
        vendorName <- map["vendorName"]
        vendorDescription <- map["vendorDescription"]
        category <- map["category"]
        subCategory <- map["subCategory"]
        otherCategoryName <- map["otherCategoryName"]
        otherSubCategoryName <- map["otherSubCategoryName"]
        vendorCompany <- map["vendorCompany"]
        vendorGSTIN <- map["vendorGSTIN"]
        vendorLocation <- map["vendorLocation"]
        vendorAddress <- map["vendorAddress"]
        status <- map["status"]
        dateOfCreation <- map["dateOfCreation"]
        canEdit <- map["canEdit"]
        
    }
}
class StockUnitDetailsVo: Mappable {
    
    var _id: String?
    var accountId: String?
    var stockUnitDescription: String?
    var stockUnitName: String?
    var isDefault: Bool?
    var canEdit: Bool?
    
    init( _id: String?,
          accountId: String?,
          stockUnitDescription: String?,
          stockUnitName: String?,
          isDefault: Bool?,
          canEdit: Bool?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        _id <- map["_id"]
        accountId <- map["accountId"]
        stockUnitDescription <- map["stockUnitDescription"]
        stockUnitName <- map["stockUnitName"]
        isDefault <- map["isDefault"]
        canEdit <- map["canEdit"]
        
    }
}
class StorageLocationLevel1DetailsVo: Mappable {
        
    var _id: String?
    var accountId: String?
    var isDefault: Bool?
    var canEdit: Bool?
    var slocName: String?
    var slocDescription: String?
    var hierachyLevel: Int?
    var parentLocation: String?
    
    init(_id: String?,
          accountId: String?,
          isDefault: Bool?,
          canEdit: Bool?,
     slocName: String?,
     slocDescription: String?,
     hierachyLevel: Int?,
     parentLocation: String?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        _id <- map["_id"]
        accountId <- map["accountId"]
        isDefault <- map["isDefault"]
        canEdit <- map["canEdit"]
        slocName <- map["slocName"]
        slocDescription <- map["slocDescription"]
        hierachyLevel <- map["hierachyLevel"]
        parentLocation <- map["parentLocation"]
        
    }
}
class StorageLocationLevel2DetailsVo: Mappable {
        
    var _id: String?
    var accountId: String?
    var isDefault: Bool?
    var canEdit: Bool?
    var slocName: String?
    var slocDescription: String?
    var hierachyLevel: Int?
    var parentLocation: String?
    
    init(_id: String?,
          accountId: String?,
          isDefault: Bool?,
          canEdit: Bool?,
     slocName: String?,
     slocDescription: String?,
     hierachyLevel: Int?,
     parentLocation: String?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        _id <- map["_id"]
        accountId <- map["accountId"]
        isDefault <- map["isDefault"]
        canEdit <- map["canEdit"]
        slocName <- map["slocName"]
        slocDescription <- map["slocDescription"]
        hierachyLevel <- map["hierachyLevel"]
        parentLocation <- map["parentLocation"]
        
    }
}
class StorageLocationLevel3DetailsVo: Mappable {
        
    var _id: String?
    var accountId: String?
    var isDefault: Bool?
    var canEdit: Bool?
    var slocName: String?
    var slocDescription: String?
    var hierachyLevel: Int?
    var parentLocation: String?
    
    init(_id: String?,
          accountId: String?,
          isDefault: Bool?,
          canEdit: Bool?,
     slocName: String?,
     slocDescription: String?,
     hierachyLevel: Int?,
     parentLocation: String?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        _id <- map["_id"]
        accountId <- map["accountId"]
        isDefault <- map["isDefault"]
        canEdit <- map["canEdit"]
        slocName <- map["slocName"]
        slocDescription <- map["slocDescription"]
        hierachyLevel <- map["hierachyLevel"]
        parentLocation <- map["parentLocation"]
        
    }
}
class PriceUnitDetailsVo: Mappable {
    
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
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        _id <- map["_id"]
        priceUnitDescription <- map["priceUnitDescription"]
        priceUnit <- map["priceUnit"]
        status <- map["status"]
        isDefault <- map["isDefault"]
        countryName <- map["countryName"]
        
    }
}
class ProductModifingDetailsVo: Mappable {
    
    var changeType: String?
    var modifiedDateTime: String?
    var change: String?
    var addedByUserId: String?
    var userinfo: [UserinfoVo]?
    var accountinfo: [AccountinfoVo]?
    var message: String?
    var availableStockQuantity: Double?
    var changedStockQuantity: Double?
    var currentProductStatus: String?
    var updatedProductStatus: String?
    var statusUpdatedDate: String?
    var shared: Bool?
    var giveAwayStatus:Bool?
    var sharedUserDetails: NSDictionary?
    var borrowLentDetails:NSDictionary?
    
    init( changeType: String?,
          modifiedDateTime: String?,
          change: String?,
          addedByUserId: String?,
          userinfo: [UserinfoVo]?,
          accountinfo: [AccountinfoVo]?,
          message: String?, availableStockQuantity: Double?,
    changedStockQuantity: Double?,
    currentProductStatus: String?,
    statusUpdatedDate: String?,shared: Bool?,giveAwayStatus:Bool?,sharedUserDetails: NSDictionary?,updatedProductStatus: String?,borrowLentDetails:NSDictionary?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
         changeType <- map["changeType"]
         modifiedDateTime <- map["modifiedDateTime"]
         change <- map["change"]
         addedByUserId <- map["addedByUserId"]
         userinfo <- map["userinfo"]
         accountinfo <- map["accountinfo"]
         message <- map["message"]
         availableStockQuantity <- map["availableStockQuantity"]
         changedStockQuantity <- map["changedStockQuantity"]
         currentProductStatus <- map["currentProductStatus"]
         statusUpdatedDate <- map["statusUpdatedDate"]
         shared <- map["shared"]
        giveAwayStatus <- map["giveAwayStatus"]
        sharedUserDetails <- map["sharedUserDetails"]
        updatedProductStatus <- map["updatedProductStatus"]
        borrowLentDetails <- map["borrowLentDetails"]
    }
}
class UserinfoVo: Mappable {

    var _id: String?
    var userId: String?
    var firstName: String?
    var lastName: String?
    var mobileNumber: String?
    var salt: String?
    var hash: String?
    var status: Bool?
    var dateOfCreation: String?
    var dateOfBirth: String?
    var mobileStatus: String?
    var gender: String?
    var longitude: String?
    var latitude: String?
    var countryCode: String?
    var countryName: String?
    var loc: [Any]?
    var mobileOTP: Int?
    var fcmToken: String?
    
    var loginDeviceInfo:LoginDeviceInfoVo?
    var privacypolicy_acceptance_status: Bool?
    var privacypolicy_accepted_version: String?
    var termsandconditions_acceptance_status: Bool?
    var termsandconditions_accepted_version: String?
    var privacypolicy_latest_version: String?
    var termsandconditions_latest_version: String?
    
    init( _id: String?,
          userId: String?,
          firstName: String?,
          lastName: String?,
          mobileNumber: String?,
          salt: String?,
          hash: String?,
          status: Bool?,
          dateOfCreation: String?,
          dateOfBirth: String?,
          mobileStatus: String?,
          gender: String?,
          longitude: String?,
          latitude: String?,
          countryCode: String?,
          countryName: String?,
          loc: [Any]?,
          mobileOTP: Int?,
          fcmToken: String?,
          loginDeviceInfo:LoginDeviceInfoVo?,
          privacypolicy_acceptance_status: Bool?,
          privacypolicy_accepted_version: String?,
          termsandconditions_acceptance_status: Bool?,
          termsandconditions_accepted_version: String?,
          privacypolicy_latest_version: String?,
          termsandconditions_latest_version: String?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
         _id <- map["_id"]
         userId <- map["userId"]
         firstName <- map["firstName"]
         lastName <- map["lastName"]
         mobileNumber <- map["mobileNumber"]
         salt <- map["salt"]
         hash <- map["hash"]
         status <- map["status"]
         dateOfCreation <- map["dateOfCreation"]
         dateOfBirth <- map["dateOfBirth"]
         mobileStatus <- map["mobileStatus"]
         gender <- map["gender"]
         longitude <- map["longitude"]
         latitude <- map["latitude"]
         countryCode <- map["countryCode"]
         countryName <- map["countryName"]
         loc <- map["loc"]
         mobileOTP <- map["mobileOTP"]
         fcmToken <- map["fcmToken"]
        loginDeviceInfo <- map["loginDeviceInfo"]
        privacypolicy_acceptance_status <- map["privacypolicy_acceptance_status"]
        privacypolicy_accepted_version <- map["privacypolicy_accepted_version"]
        termsandconditions_acceptance_status <- map["termsandconditions_acceptance_status"]
        termsandconditions_accepted_version <- map["termsandconditions_accepted_version"]
        privacypolicy_latest_version <- map["privacypolicy_latest_version"]
        termsandconditions_latest_version <- map["termsandconditions_latest_version"]
        
    }
}
class LoginDeviceInfoVo: Mappable {
    
    var type: String?
    var coordinates: [Any]?
    
    var basebandVersion: String?
    var serial: String?
    var appVersion: String?
    var osVersion: String?
    var kernelVersion: String?
    var model: String?
    var deviceName: String?
    var longitude: String?
    var manufacture: String?
    var buildNo: String?
    var lattitude: String?
    
    init(basebandVersion: String?,
          serial: String?,
          appVersion: String?,
          osVersion: String?,
          kernelVersion: String?,
          model: String?,
          deviceName: String?,
          longitude: String?,
          manufacture: String?,
          buildNo: String?,
          lattitude: String?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        type <- map["type"]
        coordinates <- map["coordinates"]
        basebandVersion <- map["coordinates"]
        serial <- map["serial"]
        appVersion <- map["appVersion"]
        osVersion <- map["osVersion"]
        kernelVersion <- map["kernelVersion"]
        model <- map["model"]
        deviceName <- map["deviceName"]
        longitude <- map["longitude"]
        manufacture <- map["manufacture"]
        buildNo <- map["buildNo"]
        lattitude <- map["lattitude"]
        
    }
}

class AccountinfoVo: Mappable {

    var _id: String?
    var emailAddress: String?
    var primaryMobileNumber: String?
    var address01: String?
    var address02: String?
    var street: String?
    var city: String?
    var state: String?
    var landMark: String?
    var pincode: String?
    var accountUniqueId: String?
    var companyName: String?
    var companySize: String?
    var accountStatus: String?
    var dateOfCreation: String?
    var status: Bool?
    var vendorName: String?
    var setVicinityMax: Int?
    var setVicinityMin: Int?
    var loc: LocVo?
    
    init( _id: String?,
           emailAddress: String?,
           primaryMobileNumber: String?,
           address01: String?,
           address02: String?,
           street: String?,
           city: String?,
           state: String?,
           landMark: String?,
           pincode: String?,
           accountUniqueId: String?,
           companyName: String?,
           companySize: String?,
           accountStatus: String?,
           dateOfCreation: String?,
           status: Bool?,
           vendorName: String?,
           setVicinityMax: Int?,
           setVicinityMin: Int?,
           loc: Any?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
               _id <- map["_id"]
               emailAddress <- map["emailAddress"]
               primaryMobileNumber <- map["primaryMobileNumber"]
               address01 <- map["address01"]
               address02 <- map["address02"]
               street <- map["street"]
               city <- map["city"]
               state <- map["state"]
               landMark <- map["landMark"]
               pincode <- map["pincode"]
               accountUniqueId <- map["accountUniqueId"]
               companyName <- map["companyName"]
               companySize <- map["companySize"]
               accountStatus <- map["accountStatus"]
               dateOfCreation <- map["dateOfCreation"]
               status <- map["status"]
               vendorName <- map["vendorName"]
               setVicinityMax <- map["setVicinityMax"]
               setVicinityMin <- map["setVicinityMin"]
               loc <- map["loc"]
        
    }
}
class LocVo: Mappable {
    
    var type: String?
    var coordinates: [Any]?
    
    init(type: String?,coordinates: [Any]?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        type <- map["type"]
        coordinates <- map["coordinates"]
        
    }
}


