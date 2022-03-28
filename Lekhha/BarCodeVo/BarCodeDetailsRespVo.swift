//
//  BarCodeDetailsRespVo.swift
//  Lekhha
//
//  Created by USM on 02/12/21.
//

import Foundation
import ObjectMapper

class BarCodeDetailsRespVo: Mappable {
        
    var message:String?
    var result:BarCodeDetailsResultVo?
    var status:String?
    var statusCode:Int?
    var productDetailsFound:Bool?
    
    init(message:String?,result:BarCodeDetailsResultVo?,status:String?,statusCode:Int?,productDetailsFound:Bool?) {
        
        self.message = message
        self.result = result
        self.status = status
        self.statusCode = statusCode
        self.productDetailsFound = productDetailsFound
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        message <- map["message"]
        result <- map["result"]
        status <- map["STATUS_MSG"]
        statusCode <- map["STATUS_CODE"]
        productDetailsFound <- map["productDetailsFound"]
    }
}
class BarCodeDetailsResultVo: Mappable {
        
    var _id: String?
    var accountId: String?
    var addedByUserId: String?
    var description: String?
    var price: Int?
    var productUniqueNumber: String?
    var barcode_id: String?
    var productImages: [BarCodeProductImagesVo]?
    var stockQuantity: Int?
    var storageLocation: String?
    var unitPrice: Int?
    var userId: String?
    var productName: String?
    var productDetailsFound: Bool?
    
    init( _id: String?,
          accountId: String?,
          addedByUserId: String?,
          description: String?,
          price: Int?,
          productUniqueNumber: String?,
          barcode_id: String?,
          productImages: [BarCodeProductImagesVo]?,
          stockQuantity: Int?,
          storageLocation: String?,
          unitPrice: Int?,
          userId: String?,
          productName: String?,
          productDetailsFound: Bool?) {
        
        self._id = _id
        self.accountId = accountId
        self.addedByUserId = addedByUserId
        self.description = description
        self.price = price
        self.productUniqueNumber = productUniqueNumber
        self.barcode_id = barcode_id
        self.productImages = productImages
        self.stockQuantity = stockQuantity
        self.storageLocation = storageLocation
        self.unitPrice = unitPrice
        self.userId = userId
        self.productName = productName
        self.productDetailsFound = productDetailsFound
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self._id <- map["_id"]
        self.accountId <- map["accountId"]
        self.addedByUserId <- map["addedByUserId"]
        self.description <- map["description"]
        self.price <- map["price"]
        self.productUniqueNumber <- map["productUniqueNumber"]
        self.barcode_id <- map["barcode_id"]
        self.productImages <- map["productImages"]
        self.stockQuantity <- map["stockQuantity"]
        self.storageLocation <- map["storageLocation"]
        self.unitPrice <- map["unitPrice"]
        self.userId <- map["userId"]
        self.productName <- map["productName"]
        self.productDetailsFound <- map["productDetailsFound"]
        
    }
}
class BarCodeProductImagesVo: Mappable {
        
    var productImage:String?
    
    init(productImage:String?) {
        
        self.productImage = productImage
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        productImage <- map["productImage"]
    }
}
/*
 {
     "STATUS_MSG": "SUCCESS",
     "STATUS_CODE": 200,
     "result": {
         "_id": "61a0dd519d4a7458592498d0",
         "accountId": "619755e43b879d3b29797c27",
         "addedByUserId": "619752ab3b879d3b29797c1a",
         "description": "Dabur Vatika Vatika Enriched Coconut Hair Oil, 300 ML",
         "price": null,
         "productUniqueNumber": "8901207038440",
         "barcode_id": "8901207038440",
         "productImages": [
             {
                 "productImage": "https://www.bigbasket.com/media/uploads/p/s/40121111_6-dabur-vatika-vatika-enriched-coconut-hair-oil.jpg"
             },
             {},
             {}
         ],
         "stockQuantity": null,
         "storageLocation": "SAHIBABAD",
         "unitPrice": null,
         "userId": "619752ab3b879d3b29797c1a",
         "productName": "Dabur Vatika Vatika Enriched Coconut Hair Oil, 300 ML",
         "productDetailsFound": true
     },
     "productDetailsFound": true
 }
 */
