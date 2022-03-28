//
//  VendorListResult.swift
//  Lekha
//
//  Created by Mallesh Kurva on 21/10/20.
//  Copyright © 2020 Longdom. All rights reserved.
//

import Foundation
import ObjectMapper

class VendorListResult: Mappable {
    
    var accountId:String?
    var accountEmailId:String?
    var vendorName:String?
    var vendorDescription:String?
    var category:String?
    var subCategory:String?
    var vendorCompany:String?
    var subCategoryId:String?
    var categoryId:String?
    var vendorGSTIN:String?
    var vendorLocation:String?
    var vendorAddress:String?
    var dateOfCreation:String?
    var _id:String?
    var status:Bool?
    var canEdit:Bool?
    
    init(accountId:String?,vendorName:String?,vendorDescription:String?,category:String?,subCategory:String?,vendorCompany:String?,vendorGSTIN:String?,vendorLocation:String?,vendorAddress:String?,_id:String?,status:Bool?,dateOfCreation:String?,canEdit:Bool?,accountEmailId:String?) {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
//        {
//            "_id" = 5f8fe3132608d963261d7f4e;
//            accountEmailId = "shalini@gmail.com";
//            accountId = 5f8970b099c2f076c8c54af6;
//            category = utilities;
//            dateOfCreation = "2020-10-21T07:28:19.940Z";
//            status = 1;
//            subCategory = pens;
//            vendorAddress = Dfsdf;
//            vendorCompany = Dfd;
//            vendorDescription = Dfsdf;
//            vendorGSTIN = Dfd;
//            vendorLocation = "";
//            vendorName = Fdsfdsf;
//        }
        
        accountId <- map["accountId"]
        vendorName <- map["vendorName"]
        vendorDescription <- map["vendorDescription"]
        category <- map["category"]
        subCategory <- map["subCategory"]
        vendorCompany <- map["vendorCompany"]
        vendorGSTIN <- map["vendorGSTIN"]
        vendorLocation <- map["vendorLocation"]
        vendorAddress <- map["vendorAddress"]
        _id <- map["_id"]
        status <- map["status"]
        dateOfCreation <- map["dateOfCreation"]
        canEdit <- map["canEdit"]
        accountEmailId <- map["accountEmailId"]
    }
}

