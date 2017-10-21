//
//  API.swift
//
//  Created by Tal Shachar on 11/02/2017.
//  Copyright © 2017 Tal Shachar. All rights reserved.
//
// https://thatthinginswift.com/write-your-own-api-clients-swift/

import Foundation

let kSerrverErrorDomain = "Server Error"
let kParsingErrorDomain = "Parsing Error"
let kParsingErrorCode = 1001

public enum Result<T> {
    case success(T)
    case error(e: Error?)
}

typealias DictionaryStringAnyObject = [String : AnyObject]//Dictionary<String, AnyObject>
typealias ApiCompletionResult = (Result<DictionaryStringAnyObject>) -> Void

class API {
    enum Method: String {
        case GET
        case POST
    }

    public static func request(with params: DictionaryStringAnyObject?, to path: String, methodType: Method, completion:  @escaping(ApiCompletionResult)) {
        
        let request: NSMutableURLRequest = API.clientURLRequest(path: path)
        API.dataTask(request: request, method: methodType.rawValue, completion: completion)
    }
    
    private static func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping(ApiCompletionResult) = { _ in}){
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let responseData = String(data: data, encoding: String.Encoding.utf8)
                print("request: " + (request.url?.absoluteString ?? "") + "\n" + responseData!)
                
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                if let json = json as DictionaryStringAnyObject? {
                    if let response = response as? HTTPURLResponse {
                        if 200...299 ~= response.statusCode {
                            DispatchQueue.main.async {
                                completion(Result.success(json))
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                completion(Result.error(e: NSError(domain: kSerrverErrorDomain, code: response.statusCode, userInfo: json)))
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(Result.error(e: NSError(domain: kParsingErrorDomain, code: kParsingErrorCode, userInfo: json)))
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(Result.error(e: NSError(domain: kParsingErrorDomain, code: kParsingErrorCode, userInfo: json)))
                    }
                }
            }
        }.resume()
    }
    
    private static func clientURLRequest(path: String, params: DictionaryStringAnyObject? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: path)!)
        if let params = params {
            var paramString = ""
            for (key, value) in params {
                
                let escapedKey = key.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                let escapedValue = value.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                paramString += "\(String(describing: escapedKey))=\(String(describing: escapedValue))&"
            }
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = paramString.data(using: String.Encoding.utf8)
        }
        
        return request
    }
}
