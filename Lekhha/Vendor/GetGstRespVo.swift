//
//  GetGstRespVo.swift
//  OWO
//
//  Created by Apple on 6/4/20.
//  Copyright © 2020 Rajeshwari. All rights reserved.
//

import Foundation
import ObjectMapper
//{
//"id": "e8d3148b-9e38-44ad-9a81-3cebadf13c8b",
//"consent": "Y",
//"consent_text": "&lt;&lt; Consent Message &gt;&gt;",
//"env": 1,
//"response_code": "101",
//"response_msg": "Success",
//"transaction_status": 1,
//"request_timestamp": "2020-06-04 16:38:55:984 +05:30",
//"response_timestamp": "2020-06-04 16:38:56:014 +05:30",
//"result": {}
//}


class GetGstRespVo: Mappable {
    
    var id: String?
    var consent: String?
    var consent_text: String?
    var env: Int?
    var response_code: String?
    var response_msg: String?
    var transaction_status:Int?
    var request_timestamp: String?
    var response_timestamp: String?
    var result:GetGstResultVo?
    
    init(id: String?,
        consent: String?,
        consent_text: String?,
        env: Int?,
        response_code: String?,
        response_msg: String?,
        transaction_status:Int?,
        request_timestamp: String?,
        response_timestamp: String?,
        result:GetGstResultVo?) {
        
        self.id = id
        self.consent = consent
        self.consent_text = consent_text
        self.env = env
        self.response_code = response_code
        self.response_msg = response_msg
        self.transaction_status = transaction_status
        self.request_timestamp = request_timestamp
        self.response_timestamp = response_timestamp
        self.result = result
    }
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
        id <- map ["id"]
        consent <- map ["consent"]
        consent_text <- map ["consent_text"]
        env <- map ["env"]
        response_code <- map ["response_code"]
        response_msg <- map ["response_msg"]
        transaction_status <- map ["transaction_status"]
        request_timestamp <- map ["request_timestamp"]
        response_timestamp <- map ["response_timestamp"]
        result <- map ["result"]
        
    }
    
    
}
