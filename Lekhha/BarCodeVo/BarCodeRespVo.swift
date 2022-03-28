//
//  BarCodeRespVo.swift
//  Lekhha
//
//  Created by USM on 08/02/22.
//

import Foundation
import ObjectMapper

class BarCodeRespVo: Mappable {
        
    var entries:Int?
    var products:[BarCodeResultVo]?
    var return_code:Int?
    var return_message:String?
    var upc_code:Int?
    
    init(entries:Int?,
     products:[BarCodeResultVo]?,
     return_code:Int?,
     return_message:String?,
     upc_code:Int?) {
        
        self.entries = entries
        self.products = products
        self.return_code = return_code
        self.return_message = return_message
        self.upc_code = upc_code
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.entries <- map["entries"]
        self.products <- map["products"]
        self.return_code <- map["return_code"]
        self.return_message <- map["return_message"]
        self.upc_code <- map["upc_code"]
    }
}
class BarCodeResultVo: Mappable {
    
    var brand:String?
    var description:String?
    var formattedNutrition:String?
    var gcp:String?
    var gcp_gcp:String?
    var image:String?
    var ingredients:String?
    var language:String?
    var manufacturer:NSDictionary?
    var nutrition:String?
    var product_web_page:String?
    var return_code:Int?
    var return_message:String?
    var thumbnail:NSDictionary?
    var uom:String?
    var upc_code: String?
    var usage:String?
    var website:String?

    
    init(brand:String?,
     description:String?,
     formattedNutrition:String?,
     gcp:String?,
     gcp_gcp:String?,
     image:String?,
     ingredients:String?,
     language:String?,
     manufacturer:NSDictionary?,
     nutrition:String?,
     product_web_page:String?,
     return_code:Int?,
     return_message:String?,
     thumbnail:NSDictionary?,
     uom:String?,
     upc_code: String?,
     usage:String?,
     website:String?) {
        
        self.brand = brand
        self.description = description
        self.formattedNutrition = formattedNutrition
        self.gcp = gcp
        self.gcp_gcp = gcp_gcp
        self.image = image
        self.ingredients = ingredients
        self.language = language
        self.manufacturer = manufacturer
        self.nutrition = nutrition
        self.product_web_page = product_web_page
        self.return_code = return_code
        self.return_message = return_message
        self.thumbnail = thumbnail
        self.uom = uom
        self.upc_code = upc_code
        self.usage = usage
        self.website = website
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        self.brand <- map["brand"]
        self.description <- map["description"]
        self.formattedNutrition <- map["formattedNutrition"]
        self.gcp <- map["gcp"]
        self.gcp_gcp <- map["gcp_gcp"]
        self.image <- map["image"]
        self.ingredients <- map["ingredients"]
        self.language <- map["language"]
        self.manufacturer <- map["manufacturer"]
        self.nutrition <- map["nutrition"]
        self.product_web_page <- map["product_web_page"]
        self.return_code <- map["return_code"]
        self.return_message <- map["return_message"]
        self.thumbnail <- map["thumbnail"]
        self.uom <- map["uom"]
        self.upc_code <- map["upc_code"]
        self.usage <- map["usage"]
        self.website <- map["website"]
    }
}

/*
 {
     entries = 1;
     products =     (
                 {
             brand = Minar;
             description = "Minar Vinegar - Non Fruit, 500 ML Bottle";
             formattedNutrition = "<null>";
             gcp = "<null>";
             "gcp_gcp" = "<null>";
             image = "https://www.bigbasket.com/media/uploads/p/s/20002727_1-minar-vinegar-non-fruit.jpg";
             ingredients = "<null>";
             language = en;
             manufacturer =             {
                 address = "<null>";
                 address2 = "<null>";
                 city = "<null>";
                 company = Minar;
                 contact = "<null>";
                 country = "<null>";
                 phone = "<null>";
                 "postal_code" = "<null>";
                 state = "<null>";
             };
             nutrition = "<null>";
             "product_web_page" = "https://www.bigbasket.com/pd/20002727/minar-vinegar-non-fruit-500-ml-bottle/";
             "return_code" = 0;
             "return_message" = Success;
             thumbnail =             {
             };
             uom = "<null>";
             "upc_code" = 8907860290508;
             usage = "";
             website = "www.bigbasket.com/";
         }
     );
     "return_code" = 000;
     "return_message" = Success;
     "upc_code" = 8907860290508;
 }
 */
