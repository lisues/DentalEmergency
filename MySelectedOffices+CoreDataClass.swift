//
//  MySelectedOffices+CoreDataClass.swift
//  DentalEmergency
//
//  Created by Robert Alavi on 8/19/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

//@objc(MySelectedOffices)
public class MySelectedOffices: NSManagedObject {
    convenience init(photo: NSData?, name: String, placeId: String, photoReference: String?, rating: Float, latitude: Double, longitude: Double, context: NSManagedObjectContext) {
  
        if let ent = NSEntityDescription.entity(forEntityName: "MySelectedOffices", in: context) {
            self.init(entity: ent, insertInto: context)
            
            if let officePhoto = photo {
                self.photo = photo
            }
            self.name =  name
            self.placeId = placeId
            
            if let myPhotoReference = photoReference {
                self.photoReference = myPhotoReference
            }
            self.rating = rating
            self.latitude =  latitude
            self.longitude = longitude

            } else {
            fatalError("Unable to find Entity: GeoPhoto!")
        }
    }
}
