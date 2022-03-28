//
//  GetGstResultVo.swift
//  OWO
//
//  Created by Apple on 6/4/20.
//  Copyright © 2020 Rajeshwari. All rights reserved.
//

import Foundation
import ObjectMapper

//{
//"stjCd": "KA108",
//"stj": "VSO 222 - TARIKERI",
//"lgnm": "SELVARAJ SEKAR SELVARAJ",
//"dty": "Composition",
//"adadr": [],
//"cxdt": "",
//"gstin": "29FJNPS6176N1ZW",
//"nba": [
//"Retail Business"
//],
//"lstupdt": "01/04/2020",
//"rgdt": "01/07/2017",
//"ctb": "Proprietorship",
//"pradr": {
//"addr": {
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
//},
//"ntr": "Retail Business"
//},
//"sts": "Active",
//"tradeNam": "BIG BAZAAR",
//"ctjCd": "YY0604",
//"ctj": "CHIKKAMAGALURU NORTH RANGE"
//}

class GetGstResultVo: Mappable {
    
    var stjCd: String?
    var stj: String?
    var lgnm: String?
    var dty:String?
    var adadr: [Any]?
    var cxdt: String?
    var gstin: String?
    var nba: [Any]?
    var lstupdt: String?
    var rgdt: String?
    var ctb: String?
    var pradr: GetGstAddRespVo?
    var sts: String?
    var tradeNam: String?
    var ctjCd: String?
    var ctj: String?
    
    init(stjCd: String?,
         stj: String?,
         lgnm: String?,
         dty:String?,
         adadr: [Any]?,
         cxdt: String?,
         gstin: String?,
         nba:[Any]?,
         lstupdt: String?,
         rgdt: String?,
         ctb: String?,
         pradr: GetGstAddRespVo?,
         sts: String?,
         tradeNam: String?,
         ctjCd: String?,
         ctj: String?) {
        
        self.stjCd = stjCd
        self.stj = stj
        self.lgnm = lgnm
        self.dty = dty
        self.adadr = adadr
        self.cxdt = cxdt
        self.gstin = gstin
        self.nba = nba
        self.lstupdt = lstupdt
        self.rgdt = rgdt
        self.ctb = ctb
        self.pradr = pradr
        self.sts = sts
        self.tradeNam = tradeNam
        self.ctjCd = ctjCd
        self.ctj = ctj
    }
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
        stjCd <- map ["stjCd"]
        stj <- map ["stj"]
        lgnm <- map ["lgnm"]
        dty <- map ["dty"]
        adadr <- map ["adadr"]
        cxdt <- map ["cxdt"]
        gstin <- map ["gstin"]
        nba <- map ["nba"]
        lstupdt <- map ["lstupdt"]
        rgdt <- map ["rgdt"]
        ctb <- map ["ctb"]
        pradr <- map ["pradr"]
        sts <- map ["sts"]
        tradeNam <- map ["tradeNam"]
        ctjCd <- map ["ctjCd"]
        ctj <- map ["ctj"]
        
    }
    
    
}
