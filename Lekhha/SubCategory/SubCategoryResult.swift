//
//  SubCategoryResult.swift
//  Lekha
//
//  Created by Mallesh Kurva on 13/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class SubCategoryResult: Mappable {

    var _id:String?
    var adminId:String?
    var adminUserName : String?
    var name : String?
    var categoryId : String?
    var status: Bool?
    
    init(_id:String?,adminId:String?,adminUserName:String?,name:String?,categoryId:String?,status: Bool?){
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {

        self._id <- map ["_id"]
        self.adminId <- map ["adminId"]
        self.adminUserName <- map ["adminUserName"]
        self.name <- map ["name"]
        self.categoryId <- map["categoryId"]
        self.status <- map["categoryId"]

    }
}
