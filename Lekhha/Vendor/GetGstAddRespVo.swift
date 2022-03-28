//
//  GetGstAddRespVo.swift
//  OWO
//
//  Created by Apple on 6/4/20.
//  Copyright © 2020 Rajeshwari. All rights reserved.
//

import Foundation
import ObjectMapper
//            "addr": {},
//            "ntr": "Retail Business"
//    },

class GetGstAddRespVo: Mappable {
    
    var addr:GetGstAddressVo?
    var ntr:String?
    
    init(addr:GetGstAddressVo?,
    ntr:String?) {
        self.addr = addr
        self.ntr = ntr
    }
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
       addr <- map ["addr"]
       ntr <- map ["ntr"]
        
    }
    
    
}

