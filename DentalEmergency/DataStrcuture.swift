//
//  DataStrcuture.swift
//  DentalEmergency
//
//  Created by Lisue She on 7/21/17.
//
//

import Foundation
import MapKit

class PracticePinAnnotation: MKPointAnnotation {
    var placeId: String=""
    var photosReference: String=""
    var rating: Float = 0.0
    var open: Bool = false
    var here: Bool = false
    
    override init() {
        //get all default from initial
    }
    
    init(name: String, placeId: String, photosReference: String, rating: Float, latitude: Double, longitude: Double) {
        super.init()
        self.placeId = placeId
        self.photosReference = photosReference
        self.rating = rating
        title = name
        coordinate.latitude = latitude
        coordinate.longitude = longitude
    }
}

struct SelectedOfficeData {
    var name: String
    var photo = UIImage(named: "default")
    var rating: Float
    var placeId: String
    var photoReference: String
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var officeAddr: String = ""
    
    init (name: String, photo: UIImage?, rating: Float, placeId: String, photoReference: String) {
        self.name = name
        if let officePhoto = photo {
            self.photo = officePhoto
        }
        self.rating = rating
        self.placeId = placeId
        self.photoReference = photoReference
    }
    
    init ( selectedOfficeInform: PracticePinAnnotation, photo: UIImage? ) {
        name = selectedOfficeInform.title!
        if let officePhoto = photo {
            self.photo = officePhoto
        }
        rating = selectedOfficeInform.rating
        placeId = selectedOfficeInform.placeId
        photoReference = selectedOfficeInform.photosReference
        latitude = selectedOfficeInform.coordinate.latitude
        longitude = selectedOfficeInform.coordinate.longitude
    }
}
