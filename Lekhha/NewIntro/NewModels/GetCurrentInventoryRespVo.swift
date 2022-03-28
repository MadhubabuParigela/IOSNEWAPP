//
//  GetCurrentInventoryRespVo.swift
//  Lekhha
//
//  Created by USM on 24/03/22.
//

import Foundation
import ObjectMapper

class GetCurrentInventoryRespVo: Mappable {
        
    var message:String?
    var result:[GetCurrentInventoryResultVo]?
    var status:String?
    var statusCode:Int?
    
    init(message:String?,result:[GetCurrentInventoryResultVo]?,status:String?,statusCode:Int?) {
        
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
class GetCurrentInventoryResultVo: Mappable {
    
    var id: String?
    var accountID:String?
    var userID:String?
    var purchaseDate: String?
    var orderID: Int?
    var productID:String?
    var vendorID: String?
    var status: Bool?
    var createdDate: String?
    var expiryDate:String?
    var productdetails: ProductdetailsVo?
    var categorydetails: CategoryResult?
    var subcategorydetails: SubCategoryResult?
    var stockUnitDetails: [StockUnitDetailsVo]?
    var storageLocationLevel1Details: [StorageLocationLevel1DetailsVo]?
    var storageLocationLevel2Details:[StorageLocationLevel2DetailsVo]?
    var storageLocationLevel3Details: [StorageLocationLevel3DetailsVo]?
    var priceUnitDetails: [PriceUnitDetailsVo]?
    
    init( id: String?,
          accountID:String?,
          userID:String?,
          purchaseDate: String,
          orderID: Int?,
          productID:String?,
          vendorID: String?,
          status: Bool?,
          expiryDate:String?,
          createdDate: String?,
          productdetails: ProductdetailsVo?,
          categorydetails: CategoryResult?,
          subcategorydetails: SubCategoryResult?,
          stockUnitDetails: [StockUnitDetailsVo]?,
          storageLocationLevel1Details: [StorageLocationLevel1DetailsVo]?,
          storageLocationLevel2Details:[StorageLocationLevel2DetailsVo]?,
          storageLocationLevel3Details: [StorageLocationLevel3DetailsVo]?,
          priceUnitDetails: [PriceUnitDetailsVo]?) {
        
        self.id = id
        self.accountID = accountID
        self.userID = userID
        self.purchaseDate = purchaseDate
        self.orderID = orderID
        self.productID = productID
        self.vendorID = vendorID
        self.status = status
        self.expiryDate = expiryDate
        self.createdDate = createdDate
        self.productdetails = productdetails
        self.categorydetails = categorydetails
        self.subcategorydetails = subcategorydetails
        self.stockUnitDetails = stockUnitDetails
        self.storageLocationLevel1Details = storageLocationLevel1Details
        self.storageLocationLevel2Details = storageLocationLevel2Details
        self.storageLocationLevel3Details = storageLocationLevel3Details
        self.priceUnitDetails = priceUnitDetails
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.id <- map["_id"]
        self.accountID <- map["accountId"]
        self.userID <- map["userId"]
        self.purchaseDate <- map["purchaseDate"]
        self.orderID <- map["orderId"]
        self.productID <- map["productId"]
        self.vendorID <- map["vendorId"]
        self.status <- map["status"]
        self.createdDate <- map["createdDate"]
        self.productdetails <- map["productdetails"]
        self.categorydetails <- map["categorydetails"]
        self.subcategorydetails <- map["subcategorydetails"]
        self.stockUnitDetails <- map["stockUnitDetails"]
        self.storageLocationLevel1Details <- map["storageLocationLevel1Details"]
        self.storageLocationLevel2Details <- map["storageLocationLevel2Details"]
        self.storageLocationLevel3Details <- map["storageLocationLevel3Details"]
        self.priceUnitDetails <- map["priceUnitDetails"]
        
    }
}
/*
 {
     "STATUS_CODE": 200,
     "STATUS_MSG": "SUCCESS",
     "result": [
         {
             "_id": "623c1a1b2e3d00351d05c7b6",
             "accountId": "623869d4b79f633f8b907d65",
             "userId": "623867ce92409f3ee7d5d415",
             "purchaseDate": "2021-11-29T00:00:00.000Z",
             "orderId": 10000,
             "productId": "623c1a1b2e3d00351d05c7b5",
             "vendorId": "623867fa92409f3ee7d5d419",
             "status": true,
             "createdDate": "2022-03-24T12:43:31.135Z",
             "productdetails": {
                 "_id": "623c1a1b2e3d00351d05c7b5",
                 "accountId": "623869d4b79f633f8b907d65",
                 "productUniqueNumber": "",
                 "productName": "11111",
                 "description": "gssv",
                 "stockQuantity": 4689.5,
                 "stockUnit": "623867fa92409f3ee7d5d417",
                 "storageLocation1": "623867fa92409f3ee7d5d418",
                 "storageLocation2": null,
                 "storageLocation3": null,
                 "expiryDate": null,
                 "categoryId": "623995c394b46123a004c6f9",
                 "subCategoryId": "623995f894b46123a004c6fa",
                 "otherCategoryName": null,
                 "otherSubCategoryName": null,
                 "priceUnit": "623994b494b46123a004c6f8",
                 "price": 459522.6,
                 "unitPrice": 98,
                 "uploadType": "Manual",
                 "productStatus": "Available",
                 "addedByUserId": "623867ce92409f3ee7d5d415",
                 "createdDate": "2022-03-24T12:43:31.135Z",
                 "status": true,
                 "productImages": [
                     {
                         "0": "623c1a1b2e3d00351d05c7b5_0",
                         "1": "623c1a1b2e3d00351d05c7b5_1",
                         "2": "623c1a1b2e3d00351d05c7b5_2"
                     }
                 ]
             },
             "categorydetails": {
                 "_id": "623995c394b46123a004c6f9",
                 "name": "Pens",
                 "status": true
             },
             "subcategorydetails": {
                 "_id": "623995f894b46123a004c6fa",
                 "categoryId": "623995c394b46123a004c6f9",
                 "name": "cello",
                 "status": true
             },
             "stockUnitDetails": [
                 {
                     "_id": "623867fa92409f3ee7d5d417",
                     "accountId": "623867fa92409f3ee7d5d416",
                     "stockUnitDescription": "NA",
                     "stockUnitName": "NA",
                     "isDefault": true,
                     "canEdit": false
 
                 }
             ],
             "storageLocationLevel1Details": [
                 {
                     "_id": "623867fa92409f3ee7d5d418",
                     "accountId": "623867fa92409f3ee7d5d416",
                     "slocName": "NA",
                     "slocDescription": "NA",
                     "hierachyLevel": 1,
                     "parentLocation": null,
                     "isDefault": true,
                     "canEdit": false
                 }
             ],
             "storageLocationLevel2Details": [],
             "storageLocationLevel3Details": [],
             "priceUnitDetails": [
                 {
                     "_id": "623994b494b46123a004c6f8",
                     "priceUnitDescription": "Rupee",
                     "priceUnit": "r",
                     "countryName": "IND",
                     "isDefault": true,
                     "status": true
 
                 }
             ]
         }
     ]
 }
 */

/*// MARK: - Welcome
struct Welcome: Codable {
    let statusCode: Int
    let statusMsg: String
    let result: [Result]

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMsg = "STATUS_MSG"
        case result
    }
}
// MARK: - Result
struct Result: Codable {
    let id, accountID, userID, purchaseDate: String
    let orderID: Int
    let productID, vendorID: String
    let status: Bool
    let createdDate: String
    let productdetails: Productdetails
    let categorydetails, subcategorydetails: Categorydetails
    let stockUnitDetails: [StockUnitDetail]
    let storageLocationLevel1Details: [StorageLocationLevel1Detail]
    let storageLocationLevel2Details, storageLocationLevel3Details: [JSONAny]
    let priceUnitDetails: [PriceUnitDetail]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case accountID = "accountId"
        case userID = "userId"
        case purchaseDate
        case orderID = "orderId"
        case productID = "productId"
        case vendorID = "vendorId"
        case status, createdDate, productdetails, categorydetails, subcategorydetails, stockUnitDetails, storageLocationLevel1Details, storageLocationLevel2Details, storageLocationLevel3Details, priceUnitDetails
    }
}

// MARK: - Categorydetails
struct Categorydetails: Codable {
    let id, name: String
    let status: Bool
    let categoryID: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, status
        case categoryID = "categoryId"
    }
}

// MARK: - PriceUnitDetail
struct PriceUnitDetail: Codable {
    let id, priceUnitDescription, priceUnit, countryName: String
    let isDefault, status: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case priceUnitDescription, priceUnit, countryName, isDefault, status
    }
}

// MARK: - Productdetails
struct Productdetails: Codable {
    let id, accountID, productUniqueNumber, productName: String
    let productdetailsDescription: String
    let stockQuantity: Double
    let stockUnit, storageLocation1: String
    let storageLocation2, storageLocation3, expiryDate: JSONNull?
    let categoryID, subCategoryID: String
    let otherCategoryName, otherSubCategoryName: JSONNull?
    let priceUnit: String
    let price: Double
    let unitPrice: Int
    let uploadType, productStatus, addedByUserID, createdDate: String
    let status: Bool
    let productImages: [[String: String]]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case accountID = "accountId"
        case productUniqueNumber, productName
        case productdetailsDescription = "description"
        case stockQuantity, stockUnit, storageLocation1, storageLocation2, storageLocation3, expiryDate
        case categoryID = "categoryId"
        case subCategoryID = "subCategoryId"
        case otherCategoryName, otherSubCategoryName, priceUnit, price, unitPrice, uploadType, productStatus
        case addedByUserID = "addedByUserId"
        case createdDate, status, productImages
    }
}

// MARK: - StockUnitDetail
struct StockUnitDetail: Codable {
    let id, accountID, stockUnitDescription, stockUnitName: String
    let isDefault, canEdit: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case accountID = "accountId"
        case stockUnitDescription, stockUnitName, isDefault, canEdit
    }
}

// MARK: - StorageLocationLevel1Detail
struct StorageLocationLevel1Detail: Codable {
    let id, accountID, slocName, slocDescription: String
    let hierachyLevel: Int
    let parentLocation: JSONNull?
    let isDefault, canEdit: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case accountID = "accountId"
        case slocName, slocDescription, hierachyLevel, parentLocation, isDefault, canEdit
    }
}
*/
