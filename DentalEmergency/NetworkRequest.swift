//
//  NetworkRequest.swift
//  DentalEmergency
//
//  Created by Lisue She on 7/19/17.
//
//

import Foundation

struct connectionError {
    static let sucess=0
    static let generalError=1
    static let networkError=2
    static let authenticationError=3
}

class NetworkRequestAPIs: NSObject {
    func taskRequest(_ requestType: String?,_ method: String, addHeaderField: [String:String]?, setHeaderField: [String:String]?, parameters: [String:AnyObject], jsonBody: String?, completionHandlerForRequest: @escaping (_ data: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {

        let urlPath = method+escapedParameters(parameters)
        
        let request = NSMutableURLRequest(url: URL(string:urlPath)!)
        if let urlRequest=requestType {
            request.httpMethod = urlRequest
        }
        
        if let addHeaderField=addHeaderField{
            for (key, value) in addHeaderField {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let setHeaderField=setHeaderField{
            for (key, value) in setHeaderField {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let jsonBody = jsonBody {
            request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        }
        
        let tempRequest = request as URLRequest
       
        let task = taskNetworkRequest(request as URLRequest)  { (data, error) in
            guard error==nil else {
                completionHandlerForRequest(nil, error)
                return
            }
            completionHandlerForRequest(data, nil)
        }
        
        return task
    }
    
    
    private func taskNetworkRequest(_ request: URLRequest, completionHandlerForNetworkRequest: @escaping (_ data: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String,_ errorCode: Int) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForNetworkRequest(nil, NSError(domain: "taskNetworkRequest", code: errorCode, userInfo: userInfo))
            }
            
            guard error==nil else {
                if let additionalInfo = error?.localizedDescription {
                    sendError("\nThere was an error with your request: \n\n\(additionalInfo)", connectionError.generalError)
                } else {
                    sendError("\nThere was an error with your request", connectionError.generalError)
                }
                return
            }
            
            if let statusCode = (response as?HTTPURLResponse)?.statusCode {
                if !(statusCode>=200 && statusCode<=299) {
                    if (statusCode >= 401 && statusCode <= 409) {
                        sendError("Unauthorized: Authentication Failed.", connectionError.authenticationError)
                    } else if (statusCode >= 500 && statusCode <= 510) {
                        sendError("Network failed.", connectionError.networkError)
                    } else {
                        sendError("Your request returned a status code other than 2xx!", connectionError.generalError)
                    }
                    return
                }
            }
            
            guard let data = data else {
                sendError("No data is returned.", connectionError.generalError)
                return
            }
            
            completionHandlerForNetworkRequest(data, nil)
        }
        
        task.resume()
        
        return task
    }
    
    private func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                let stringValue = "\(value)"
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
                
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }

    func performJSONSerialization(data: Data?, completionHandlerpPrformJSON: @escaping (_ parsedData: [String:AnyObject]?) -> Void ) {
        let parsedData:[String:AnyObject]!
        do {
            parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
            completionHandlerpPrformJSON(parsedData)
        } catch {
            print("Error on parsing data")
            completionHandlerpPrformJSON(nil)
            return
        }
    }
    
    static let sharedInstance = NetworkRequestAPIs()
}



