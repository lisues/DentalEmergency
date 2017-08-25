//
//  GoogleConstant.swift
//  DentalEmergency
//
//  Created by Lisue She on 7/19/17.
//
//

import Foundation


enum googleSearchType {
    case nearBy, textSearch, moreSearch, detailSearch, photoReference
}

struct Constants {
    
    // MARK: Google Web Service
    struct GoogleService {
        static let APIScheme = "https"
        static let APIHost = "maps.googleapis.com"
        static let APIPathNearby = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        static let APIPathQuery = "https://maps.googleapis.com/maps/api/place/textsearch/json"
        static let APIPathDetail = "https://maps.googleapis.com/maps/api/place/details/json"
        static let APIPathPhoto = "https://maps.googleapis.com/maps/api/place/photo"
    }
    
    // MARK: Google Web Service Parameter Keys
    struct GoogleServiceParameterKeys {
        static let Method = "method"
        static let APIKey = "key"
        static let SearchType = "types"
        static let Location = "location"
        static let Radius = "radius"
        static let Keyword = "keyword"
        static let Query = "query"
        static let RankBy = "rankby"
        static let PlaceId = "placeid"
        static let PageToken = "pagetoken"
        static let PhotoReference = "photoreference"
        static let MaxWidth = "maxwidth"
    }
    
    // MARK: Google Web Service Parameter Values
    struct GoogleServiceParameterValues {
        static let APIKey = "AIzaSyCDXGNPg06E9jFs_tszAUJ3FOvBs836wiI"
        static let SearchType = "dentist"
        static let RankBy = "distance"
        static let MaxWidth = "400"
    }
    
    // MARK:Google Web Service Response Keys
    struct GoogleServiceResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    // MARK: Google Web Service Response Values
    struct GoogleServiceResponseValues {
        static let OKStatus = "ok"
    }
}
