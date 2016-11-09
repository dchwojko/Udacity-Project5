//
//  MarvelClient.swift
//  MyMarvel
//
//  Created by DONALD CHWOJKO on 10/25/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import Foundation

class MarvelClient {
    var session = URLSession.shared
    
    func taskForGETMethod(urlString: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var ts: String = getTimeStamp()
        var newParameters = parameters
        
        newParameters["hash"] = createHash(timestamp: ts) as AnyObject?
        newParameters["apikey"] = Constants.ApiPublicKey as AnyObject?
        newParameters["ts"] = ts as AnyObject?
        
        let url: URL = URL(string: urlString + escapedParameters(parameters: newParameters))!
        print("DEBUG: \(url)")
        
        let request = NSMutableURLRequest(url: url )
        request.httpMethod = "GET"

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            // helper function
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError(error: "There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2xx response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(error: "No data was returned by the request!")
                return
            }
            
            let parsedResult: AnyObject!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                completionHandlerForGET(parsedResult, nil)
            } catch let error as NSError {
                completionHandlerForGET(nil, error)
                return
            }
            
        }
        task.resume()
        return task
    }
    
    private func escapedParameters(parameters: [String:AnyObject]) -> String {
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            for (key, value) in parameters {
                let stringValue = "\(value)"
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }

    // MARK: Shared Instance
    
    class func sharedInstance() -> MarvelClient {
        struct Singleton {
            static var sharedInstance = MarvelClient()
        }
        return Singleton.sharedInstance
    }
    
    private func getTimeStamp() -> String {
        let now = NSDate()
//        return "\(now)"
        return "don"
    }
    
    public func createHash(timestamp: String) -> String {
        
        let preHashString: String = "\(timestamp)\(MarvelClient.Constants.ApiPrivateKey)\(MarvelClient.Constants.ApiPublicKey)"
        let postHashString: String = MD5(preHashString)!
        return "\(postHashString)"
    }
    
    
    // md5test: online baseline = http://www.miraclesalad.com/webtools/md5.php
    public func md5test(string: String) -> String {
        return self.MD5(string)!
    }
    
    // Funciton for getting md5 hash for given string
    func MD5(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        if let d = string.data(using: String.Encoding.utf8) {
            d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    
}

