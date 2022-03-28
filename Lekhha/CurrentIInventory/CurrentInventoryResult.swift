//
//  File.swift
//  Lekha
//
//  Created by Mallesh Kurva on 09/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class CurrentInventoryResult: Mappable {
    
//    {
//        "_id": "5f3d09e62261d53a1c7324d8",
//        "accountId": "5f3cc69b6d03a76e219d50ab",
//        "accountEmailId": "abc@xyz.com",
//        "productUniqueNumber": "56498456156496564561564",
//        "productName": "dsfs",
//        "description": "sxzczcz",
//        "stockQuantity": "10",
//        "stockUnit": "kgs",
//        "purchaseDate": "2020-08-05T00:00:00.000Z",
//        "expiryDate": "2020-08-31T00:00:00.000Z",
//        "storageLocation": "dsfs",
//        "borrowed": "yes ",
//        "category": "dfgdg",
//        "subCategory": "sadd",
//        "orderId": "ewewsdf",
//        "vendorId": "sds",
//        "price": "234",
//        "uploadType": "Manually",
//        "status": true,
//        "productStatus": "Available",
//        "productManuallyAddOrAutoMovedDate": "2020-08-19T11:15:50.824Z"
//    },
    
    var productId:String?
    var _id : String?
    var productDict : CurrentInventoryProductDetailResp?

    init(productId:String?,productDict:CurrentInventoryProductDetailResp?,_id:String?) {
        self.productId = productId
        self.productDict = productDict
        self._id = _id
    }
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        
        self.productId <- map ["productId"]
        self.productDict <- map["productdetails"]
        self._id <- map["_id"]
        
    }
}
