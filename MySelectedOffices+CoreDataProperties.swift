//
//  MySelectedOffices+CoreDataProperties.swift
//  DentalEmergency
//
//  Created by Robert Alavi on 8/19/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension MySelectedOffices {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MySelectedOffices> {
        return NSFetchRequest<MySelectedOffices>(entityName: "MySelectedOffices");
    }

    @NSManaged public var photo: NSData?
    @NSManaged public var name: String?
    @NSManaged public var placeId: String?
    @NSManaged public var photoReference: String?
    @NSManaged public var rating: Float
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
