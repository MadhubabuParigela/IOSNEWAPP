//
//  GetGstAddressVo.swift
//  OWO
//
//  Created by Apple on 6/4/20.
//  Copyright © 2020 Rajeshwari. All rights reserved.
//

import Foundation
import ObjectMapper
//{
//"bnm": "",
//"st": "B H road Tarikere",
//"loc": "Tarikere Taluk",
//"bno": "Sri Ganapathi Seva Samithi building",
//"stcd": "Karnataka",
//"dst": "Chikkamagaluru (Chikmagalur)",
//"city": "",
//"flno": "",
//"lt": "",
//"pncd": "577228",
//"lg": ""
//}
class GetGstAddressVo: Mappable {
    
   var bnm: String?
    var st: String?
    var loc: String?
    var bno: String?
    var stcd: String?
    var dst: String?
    var city: String?
    var flno:String?
    var lt: String?
    var pncd: String?
    var lg: String?
    
    init(bnm: String?,
     st: String?,
     loc: String?,
     bno: String?,
     stcd: String?,
     dst: String?,
     city: String?,
     flno:String?,
     lt: String?,
     pncd: String?,
     lg: String?) {
        
        self.bnm = bnm
        self.st = st
        self.loc = loc
        self.bno = bno
        self.stcd = stcd
        self.dst = dst
        self.city = city
        self.flno = flno
        self.lt = lt
        self.pncd = pncd
        self.lg = lg
    }
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
        bnm <- map ["bnm"]
        st <- map ["st"]
        loc <- map ["loc"]
        bno <- map ["bno"]
        stcd <- map ["stcd"]
        dst <- map ["dst"]
        city <- map ["city"]
        flno <- map ["flno"]
        lt <- map ["lt"]
        pncd <- map ["pncd"]
        lg <- map ["lg"]
    
    }
    
}
