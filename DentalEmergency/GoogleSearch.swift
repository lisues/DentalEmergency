//
//  GoogleSearch.swift
//  DentalEmergency
//
//  Created by Lisue She on 7/21/17.
//
//

import UIKit
import Foundation

class GoogleSearchService: NSObject  {
    
    private func getSearchParameter( searchInfo: String?, searchType: googleSearchType ) -> [String: AnyObject] {
        var parameters: [String:AnyObject] = [Constants.GoogleServiceParameterKeys.APIKey:
                                              Constants.GoogleServiceParameterValues.APIKey as AnyObject,
                                              Constants.GoogleServiceParameterKeys.SearchType:
                                              Constants.GoogleServiceParameterValues.SearchType as AnyObject]
        
        switch (searchType) {
        case googleSearchType.nearBy:
            parameters[Constants.GoogleServiceParameterKeys.Location] = searchInfo as AnyObject
            parameters[Constants.GoogleServiceParameterKeys.RankBy] = Constants.GoogleServiceParameterValues.RankBy as AnyObject
            return parameters
        case googleSearchType.textSearch:
            parameters[Constants.GoogleServiceParameterKeys.Query] = searchInfo as AnyObject
            return parameters
        case googleSearchType.moreSearch:
            parameters[Constants.GoogleServiceParameterKeys.PageToken] = searchInfo as AnyObject
            return parameters
        case googleSearchType.detailSearch:
            parameters = [Constants.GoogleServiceParameterKeys.APIKey:
                          Constants.GoogleServiceParameterValues.APIKey as AnyObject,
                          Constants.GoogleServiceParameterKeys.PlaceId: searchInfo as AnyObject]
            return parameters
        case googleSearchType.photoReference:
            parameters = [Constants.GoogleServiceParameterKeys.APIKey:
                            Constants.GoogleServiceParameterValues.APIKey as AnyObject,
                          Constants.GoogleServiceParameterKeys.MaxWidth:
                            Constants.GoogleServiceParameterValues.MaxWidth as AnyObject,
                          Constants.GoogleServiceParameterKeys.PhotoReference: searchInfo as AnyObject]
            return parameters
        }
    }
    
    func getGoogleServiceAPI( searchType: googleSearchType ) -> String {
        
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        switch (searchType) {
        case googleSearchType.nearBy:
            appDelegate.googleSearchApi = Constants.GoogleService.APIPathNearby
            return Constants.GoogleService.APIPathNearby
        case googleSearchType.textSearch:
            appDelegate.googleSearchApi = Constants.GoogleService.APIPathQuery
            return Constants.GoogleService.APIPathQuery
        case googleSearchType.moreSearch:
            return appDelegate.googleSearchApi
        case googleSearchType.detailSearch:
            return Constants.GoogleService.APIPathDetail
        case googleSearchType.photoReference:
            return Constants.GoogleService.APIPathPhoto
        }
    }
    
    func searchGoogleDentist(searchInfo: String?, searchType: googleSearchType, completionHandlerForGoogleSearch: @escaping (_ practices: [AnyObject]?, _ nextPageToken: String?, _ error: NSError? ) -> Void) {

        let googleAPI = getGoogleServiceAPI( searchType: searchType )
        
        let parameters = getSearchParameter( searchInfo: searchInfo, searchType: searchType )
            
        NetworkRequestAPIs.sharedInstance.taskRequest(nil, googleAPI, addHeaderField: nil, setHeaderField: nil, parameters: parameters, jsonBody: nil) { (data, error) in
            
            guard let data=data else {
                print("Client task request failed")
                completionHandlerForGoogleSearch(nil, nil, error)
                return
            }
            
            print("get data, let parse it")
            
            let parsedData: [String:AnyObject]!
            do {
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
               /*
                for (key,value) in parsedData {
                    print("\(key): \(value)")
                }
                */
                guard let results=parsedData["results"] as? [AnyObject] else {
                    completionHandlerForGoogleSearch(nil, nil, error)
                    return

                }
                //print("count of results: \(results.count)")
                var nextPageToken = ""
                if let nextToken = parsedData["next_page_token"] as? String {
                        nextPageToken = nextToken
                }
                
                completionHandlerForGoogleSearch(results, nextPageToken, error)
                return
                
            } catch {
                completionHandlerForGoogleSearch(nil, nil, error as NSError?)
                return
            }
        }
        
    }

    func searchGoogleDentistDetail(searchInfo: String?, searchType: googleSearchType, completionHandlerForGoogleSearch: @escaping (_ practices: [String: AnyObject]?, _ error: NSError? ) -> Void) {
        
        let googleAPI = getGoogleServiceAPI( searchType: searchType )
        let parameters = getSearchParameter( searchInfo: searchInfo, searchType: searchType )
        
        NetworkRequestAPIs.sharedInstance.taskRequest(nil, googleAPI, addHeaderField: nil, setHeaderField: nil, parameters: parameters, jsonBody: nil) { (data, error) in
            
            guard let data=data else {
                completionHandlerForGoogleSearch(nil, error)
                return
            }
            
            print("get data, let parse it")
            let parsedData: [String:AnyObject]!
            do {
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                
                for (key,value) in parsedData {
                    print("\(key): \(value)")
                }
 
                guard let result=parsedData["result"] as? [String: AnyObject] else {
                    print("error: 1")
                    completionHandlerForGoogleSearch(nil, error)
                    return
                }
                completionHandlerForGoogleSearch(result, error)
            
            } catch {
                completionHandlerForGoogleSearch(nil, error as NSError?)
                return
            }
        }
    }

    func searchGoogleDentistPhoto(searchInfo: String?, searchType: googleSearchType, completionHandlerForGoogleSearch: @escaping (_ photo: Data?, _ error: NSError?) -> Void) {
        
        let googleAPI = getGoogleServiceAPI( searchType: searchType )
        
        let parameters = getSearchParameter( searchInfo: searchInfo, searchType: searchType )
        
        NetworkRequestAPIs.sharedInstance.taskRequest(nil, googleAPI, addHeaderField: nil, setHeaderField: nil, parameters: parameters, jsonBody: nil) { (data, error) in
            
            guard let data=data else {
                print("Client task request failed")
                completionHandlerForGoogleSearch(nil, error)
                return
            }
            
            if let error = error {
                print("google photo request error: \(error)")
                completionHandlerForGoogleSearch(nil, error)
            } else {
                 completionHandlerForGoogleSearch(data, error)
            }
            return
        }
    }

    static let sharedInstance = GoogleSearchService()
}
