//
//  ServiceController.swift
//  Lekha
//
//  Created by Mallesh on 18/09/20.
//  Copyright © 2020 Mallesh. All rights reserved.
//

import Foundation
import Toast_Swift

var appDelegate = AppDelegate()

let content_type = "application/json; charset=utf-8"

class ServiceController: NSObject {
    
            //🌿☘️🍂🍁🍃🌱🌴🌴🐾🦚.......GET METHOD.....🌿☘️🍂🍁🍃🌱🌴🌴🐾🦚//
    
    //@@@@@@@@@@@@@@@@@@@@@@@@ GET METHOD FUNCTIONALITY @@@@@@@@@@@@@@@@@@@@@@@@@@@@//
    
    func requestGETURL(strURL:String,success:@escaping(_ _result:Any)->Void,failure:@escaping(_ error:String) -> Void) {
        
        if strURL==""
        {
            
        }
        else
        {
        let request = NSMutableURLRequest(url: URL(string: strURL)!)
        request.addValue(content_type, forHTTPHeaderField: "Content-Type")
        request.addValue(content_type, forHTTPHeaderField: "Accept")
        
        //// request.setValue(api_key, forHTTPHeaderField: "api_key")
        //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "token")
        
//        accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InN0YXR1cyI6dHJ1ZSwibW9iaWxlTnVtYmVyIjoiODAxOTAxNjQ0OCJ9LCJpYXQiOjE2MDI3NDEwOTV9.VmZuIObtGk1h17N_d0yW_ZdYbfbESCjpj-1k0BQOqwM"
        
//        if(accessToken != nil){
//            request.setValue("Bearer \(String(describing: accessToken!))", forHTTPHeaderField: "Authorization")
//
//        }
        
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with:request as URLRequest){(data,response,error) in
            DispatchQueue.main.async(){
                
                if response != nil {
                    
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("statusCode:\(statusCode)")
                    
                    if statusCode == 401 {
                        
                        failure("unAuthorized")
                        
                    }
                    else if error != nil
                    {
                        //                    failure(error! as NSError)
                        print(error?.localizedDescription)
                        failure("error")
                    }else{
                        
                        do{
                            let parsedData = try JSONSerialization.jsonObject(with:data!,options:.mutableContainers) as! [String:Any]
                            print(parsedData)
                            success(parsedData as Any)
                        }
                        catch{
                            print("error=\(error)")
                            failure("error")
                            return
                        }
                        
                    }
                }
                else {
                    
                    failure("error")
                }
                
            }
        }
        task.resume()
        }
    }
    func requestDeleteURL(strURL:String,success:@escaping(_ _result:Any)->Void,failure:@escaping(_ error:String) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL)
        request.addValue(content_type, forHTTPHeaderField: "Content-Type")
        request.addValue(content_type, forHTTPHeaderField: "Accept")
        
        //// request.setValue(api_key, forHTTPHeaderField: "api_key")
        //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "token")
        
//        accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InN0YXR1cyI6dHJ1ZSwibW9iaWxlTnVtYmVyIjoiODAxOTAxNjQ0OCJ9LCJpYXQiOjE2MDI3NDEwOTV9.VmZuIObtGk1h17N_d0yW_ZdYbfbESCjpj-1k0BQOqwM"
        
//        if(accessToken != nil){
//            request.setValue("Bearer \(String(describing: accessToken!))", forHTTPHeaderField: "Authorization")
//
//        }
        
        
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with:request as URLRequest){(data,response,error) in
            DispatchQueue.main.async(){
                
                if response != nil {
                    
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("statusCode:\(statusCode)")
                    
                    if statusCode == 401 {
                        
                        failure("unAuthorized")
                        
                    }
                    else if error != nil
                    {
                        //                    failure(error! as NSError)
                        print(error?.localizedDescription)
                        failure("error")
                    }else{
                        
                        do{
                            let parsedData = try JSONSerialization.jsonObject(with:data!,options:.mutableContainers) as! [String:Any]
                            print(parsedData)
                            success(parsedData as Any)
                        }
                        catch{
                            print("error=\(error)")
                            failure("error")
                            return
                        }
                        
                    }
                }
                else {
                    
                    failure("error")
                }
                
            }
        }
        task.resume()
    }
    
    func requestGETAddressURL(strURL:String,success:@escaping(_ _result:Any)->Void,failure:@escaping(_ error:String) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL)
        request.addValue(content_type, forHTTPHeaderField: "Content-Type")
        request.addValue(content_type, forHTTPHeaderField: "Accept")
        
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "token")
        
        if(accessToken != nil){
            request.setValue("Bearer \(String(describing: accessToken!))", forHTTPHeaderField: "Authorization")

        }

        
        //// request.setValue(api_key, forHTTPHeaderField: "api_key")
        //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with:request as URLRequest){(data,response,error) in
            DispatchQueue.main.async(){
                
                if response != nil {
                    
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("statusCode:\(statusCode)")
                    
                    if statusCode == 401 {
                        
                        failure("unAuthorized")
                        
                    }
                    else if error != nil
                    {
                        //                    failure(error! as NSError)
                        print(error?.localizedDescription)
                        failure("error")
                    }else{
                        
                        do{
                            let parsedData = try JSONSerialization.jsonObject(with:data!,options:.mutableContainers) as! NSMutableArray
                            print(parsedData)
                            success(parsedData as Any)
                        }
                        catch{
                            print("error=\(error)")
                            failure("error")
                            return
                        }
                        
                    }
                }
                else {
                    
                    failure("error")
                }
            }
        }
        
        task.resume()
    }
    
    
            //🌿☘️🍂🍁🍃🌱🌴🌴🐾🦚.......POST METHOD........🌿☘️🍂🍁🍃🌱🌴🌴🐾🦚//
    
    //@@@@@@@@@@@@@@@@@@@@@@@@ POST METHOD FUNCTIONALITY @@@@@@@@@@@@@@@@@@@@@@@@@@@@//
    
    
    func requestPOSTURL(strURL:NSString,postParams:NSDictionary,postHeaders:NSDictionary,successHandler:@escaping(_ _result:Any)->Void,failureHandler:@escaping (_ error:String)->Void) -> Void {
        
        let urlStr:NSString = strURL.addingPercentEscapes(using:String.Encoding.utf8.rawValue)! as NSString
        let url: NSURL = NSURL(string: urlStr as String)!
        
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "token")
        
        let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField:"Content-Type")
        request.addValue("application/json",forHTTPHeaderField:"Accept")
        
//        accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InN0YXR1cyI6dHJ1ZSwibW9iaWxlTnVtYmVyIjoiODAxOTAxNjQ0OCJ9LCJpYXQiOjE2MDI3NDEwOTV9.VmZuIObtGk1h17N_d0yW_ZdYbfbESCjpj-1k0BQOqwM"
        
        if(accessToken != nil){
            request.setValue( "Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")

        }
        
        print("Access Token is\(accessToken)")

        do {
            let data = try! JSONSerialization.data(withJSONObject:postParams, options:.prettyPrinted)
            let dataString = String(data: data, encoding: String.Encoding.utf8)!
            
            let headerData = try! JSONSerialization.data(withJSONObject:postHeaders, options:.prettyPrinted)
            let headerDataString = String(data: headerData, encoding: String.Encoding.utf8)!
            
            print("Request Url :\(url)")
            print("Request Header Data :\(headerDataString)")
            print("Request Data : \(dataString)")
            
            request.httpBody = data
            // do other stuff on success
            
        }
        catch {
            DispatchQueue.main.async(){
                
            }
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            
            //            print(data)
            //            print(response)
            //            print(error)
            
            DispatchQueue.main.async(){
                
                if response != nil {
                    
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("statusCode:\(statusCode)")
                    
                    if statusCode == 401 {
                        failureHandler("unAuthorized")
                        
                    }
                    else if error != nil
                    {
                        print("error=\(String(describing: error))")
                        
                        return
                        
                    } else{
                        do {
                            let parsedData = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as! [String:Any]
                            print("result: \(parsedData)")
                            successHandler(parsedData as Any)
                            
                        } catch let error as NSError {
                            
                            print("error=\(error)")
                            failureHandler("error=\(error)")
                            
                            return
                        }
                    }
                    
                }
                else {
                    
                    print("Respone:The server couldn't send a response")
                     failureHandler("The server couldn't send a response")
                    
                }
            }
        }
        task.resume()
        
    }
    
    
    func requestPOSTURLWithArray(strURL:NSString,postParams:NSArray,postHeaders:NSDictionary,successHandler:@escaping(_ _result:Any)->Void,failureHandler:@escaping (_ error:String)->Void) -> Void {
        
        let urlStr:NSString = strURL.addingPercentEscapes(using:String.Encoding.utf8.rawValue)! as NSString
        let url: NSURL = NSURL(string: urlStr as String)!
        
        let defaults = UserDefaults.standard
        var accessToken = defaults.string(forKey: "token")
        
        let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField:"Content-Type")
        request.addValue("application/json",forHTTPHeaderField:"Accept")
        
//        accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InN0YXR1cyI6dHJ1ZSwibW9iaWxlTnVtYmVyIjoiODAxOTAxNjQ0OCJ9LCJpYXQiOjE2MDI3NDEwOTV9.VmZuIObtGk1h17N_d0yW_ZdYbfbESCjpj-1k0BQOqwM"
        
        if(accessToken != nil){
            request.setValue( "Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")

        }

        do {
            let data = try! JSONSerialization.data(withJSONObject:postParams, options:.prettyPrinted)
            let dataString = String(data: data, encoding: String.Encoding.utf8)!
            
            let headerData = try! JSONSerialization.data(withJSONObject:postHeaders, options:.prettyPrinted)
            let headerDataString = String(data: headerData, encoding: String.Encoding.utf8)!
            
//            print("Request Url :\(url)")
//            print("Request Header Data :\(headerDataString)")
                        print("Request Data : \(dataString)")
            
            request.httpBody = data
            // do other stuff on success
            
        }
        catch {
            DispatchQueue.main.async(){
                
            }
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            
            //            print(data)
            //            print(response)
            //            print(error)
            
            DispatchQueue.main.async(){
                
                if response != nil {
                    
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("statusCode:\(statusCode)")
                    
                    if statusCode == 401 {
                        
                        failureHandler("unAuthorized")
                        
                    }
                    else if error != nil
                    {
                        print("error=\(String(describing: error))")
                        
                        return
                        
                    } else{
                        do {
                            let parsedData = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as! [String:Any]
                            print("result: \(parsedData)")
                            successHandler(parsedData as Any)
                            
                        } catch let error as NSError {
                            
                            print("error=\(error)")
                            
                            failureHandler("error=\(error)")
                            
                            return
                        }
                    }
                    
                }
                else {
                    
                    print("Respone:The server couldn't send a response")
                     failureHandler("The server couldn't send a response")
                    
                }
                
            }
        }
        task.resume()
        
    }
    
    
    func requestGSTPOSTURL(strURL:NSString,postParams:NSDictionary,postHeaders:NSDictionary,successHandler:@escaping(_ _result:Any)->Void,failureHandler:@escaping (_ error:String)->Void) -> Void {
        
        
        let urlStr:NSString = strURL.addingPercentEscapes(using:String.Encoding.utf8.rawValue)! as NSString
        let url: NSURL = NSURL(string: urlStr as String)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField:"Content-Type")
        request.addValue("application/json",forHTTPHeaderField:"Accept")
        request.addValue("61e964c2-8c2c-4a83-b943-a8ebbbdf4eea",forHTTPHeaderField:"qt_api_key")
        request.addValue("f1206a1d-71b1-4bb3-abde-e0f1f2d52bfc",forHTTPHeaderField:"qt_agency_id")
        
        let defaults = UserDefaults.standard
        let accessToken = defaults.string(forKey: "token")
        
        if(accessToken != nil){
            request.setValue("Bearer \(String(describing: accessToken!))", forHTTPHeaderField: "Authorization")

        }

        
        do {
            let data = try! JSONSerialization.data(withJSONObject:postParams, options:.prettyPrinted)
            let dataString = String(data: data, encoding: String.Encoding.utf8)!
            
            let headerData = try! JSONSerialization.data(withJSONObject:postHeaders, options:.prettyPrinted)
            let headerDataString = String(data: headerData, encoding: String.Encoding.utf8)!
            
            print("Request Url :\(url)")
            print("Request Header Data :\(headerDataString)")
            //            print("Request Data : \(dataString)")
            
            request.httpBody = data
            // do other stuff on success
            
        }
        catch {
            DispatchQueue.main.async(){
                
            }
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            
            //            print(data)
            //            print(response)
            //            print(error)
            
            DispatchQueue.main.async(){
                
                if response != nil {
                    
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("statusCode:\(statusCode)")
                    
                    if statusCode == 401 {
                        
                        failureHandler("unAuthorized")
                        
                    }
                    else if error != nil
                    {
                        print("error=\(String(describing: error))")
                        
                        return
                        
                    } else{
                        do {
                            let parsedData = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as! [String:Any]
                            print("result: \(parsedData)")
                            successHandler(parsedData as Any)
                            
                        } catch let error as NSError {
                            
                            print("error=\(error)")
                            
                            failureHandler("error=\(error)")
                            
                            return
                        }
                    }
                    
                }
                else {
                    
                    print("Respone:The server couldn't send a response")
                    
                    //                    let alert  = UIAlertController(title: "Alert", message: "The server couldn't send a response", preferredStyle: .alert)
                    //                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    //                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
        task.resume()
        
    }
    
}
