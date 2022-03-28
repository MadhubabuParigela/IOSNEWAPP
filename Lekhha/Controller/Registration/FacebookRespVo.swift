//
//  FacebookRespVo.swift
//  SmartBike
//
//  Created by Rajeshwari Y on 11/8/19.
//  Copyright © 2019 Fugenx. All rights reserved.
//
//["picture": {
//    data =     {
//        height = 200;
//        "is_silhouette" = 0;
//        url = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=2799961450037645&height=200&width=200&ext=1577261052&hash=AeRViOwJXvVucMMi";
//        width = 200;
//    };
//    }, "first_name": Parigela, "email": madhubme020@gmail.com, "last_name": Madhubabu, "name": Parigela Madhubabu, "id": 2799961450037645]
import Foundation
//        ["id": 2799961450037645,
//           "email": madhubme020 @gmail.com,
//           "picture": {
//            data = {
//                height = 200;
//                "is_silhouette" = 0;
//                url = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=2799961450037645&height=200&width=200&ext=1575807170&hash=AeT4_i8ADvKwiCwc";
//                width = 200;
//            };
//            },
//        "first_name": Parigela, "last_name": Madhubabu, "name": Parigela Madhubabu]

import ObjectMapper

class FacebookRespVo: Mappable {
    
    var id:NSString?
    var email:String?
    var picture:Any?
    var first_name:String?
    var last_name:String?
    var name:String?
    
    init(id:NSString?,email:String?,picture:Any?,first_name:String?,last_name:String?,name:String?) {
        
        self.id = id
        self.email = email
        self.picture = picture
        self.first_name = first_name
        self.last_name = last_name
        self.name = name
    }
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        email <- map["email"]
        picture <- map["picture"]
        first_name <- map["first_name"]
        name <- map["name"]
        last_name <- map["last_name"]
        
    }
    
}
