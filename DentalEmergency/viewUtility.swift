//
//  viewUtility.swift
//  DentalEmergency
//
//  Created by Robert Alavi on 7/24/17.
//
//
import UIKit
import MapKit
import CoreData

class practiceViewUtility {
    
    var appDelegate: AppDelegate!
    
    func getRantingPhoto( officeRank: Float ) -> String {
        
        switch(officeRank) {
        case 0:
            return "rating0"
        case 0.1..<1, 1, 1.0:
            return "rating1"
        case 1.1..<2:
            return "rating1_1"
        case 2, 2.0:
            return "rating2"
        case 2.1..<3:
            return "rating2_1"
        case 3, 3.0:
            return "rating3"
        case 3.1..<4:
            return "rating3_1"
        case 4, 4.0:
            return "rating4"
        case 4.1..<5:
            return "rating4_1"
        case 5, 5.0:
            return "rating5"
        default:
            return "rating0"
        }
    }

    func switchSelectedOfficeOptions( fromSelected: Bool, addSelected: UIBarButtonItem!, deletedOffice:  UIButton!) {

        if fromSelected {
            addSelected.isEnabled = false
            addSelected.isAccessibilityElement = false
            deletedOffice.isEnabled = true
            deletedOffice.isHidden = false
        } else {
            addSelected.isAccessibilityElement = true
            deletedOffice.isEnabled = false
            deletedOffice.isHidden = true
        }
    }
    
    func addingOfficeToList( senderView: AnyObject, myLocation: PracticePinAnnotation?, selectedOfficeInform: SelectedOfficeData, stack: CoreDataStack ) {

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let officePhoto = UIImagePNGRepresentation(selectedOfficeInform.photo!)! as Data
        
        let myOffice = MySelectedOffices(photo: officePhoto as NSData?, name: selectedOfficeInform.name, placeId: selectedOfficeInform.placeId, photoReference: selectedOfficeInform.photoReference, rating: selectedOfficeInform.rating, latitude: selectedOfficeInform.latitude, longitude: selectedOfficeInform.longitude, context: stack.context)
        
        stack.save()

        let controller = senderView.storyboard!?.instantiateViewController(withIdentifier: "SelectedOfficesTableViewController") as! SelectedOfficesTableViewController
     
        controller.selectedOffice = selectedOfficeInform
        controller.myLocation = myLocation
        senderView.present(controller, animated: true, completion: nil)
    }
    
    func deleteSelectedOffice( senderView: AnyObject, indexPath: IndexPath,  myLocation: PracticePinAnnotation?, stack: CoreDataStack, fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?  ) {
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    
        if let fc = fetchedResultsController,
            fc.sections![indexPath.section].numberOfObjects > indexPath.row {
            let selectedOffice = fetchedResultsController?.object(at: indexPath) as! MySelectedOffices
            stack.context.delete(selectedOffice)
            stack.save()
        }
        
        let controller = senderView.storyboard!?.instantiateViewController(withIdentifier: "SelectedOfficesTableViewController") as! SelectedOfficesTableViewController
    
        controller.myLocation = myLocation
        senderView.present(controller, animated: true, completion: nil)
    }
    
    func convertCoreDataToDataStructure( office: MySelectedOffices ) -> SelectedOfficeData {
        
        var selectedImage: UIImage
        if let officePhoto = office.photo {
            selectedImage = UIImage(data: office.photo as! Data)!
        } else {
            selectedImage = UIImage(named: "default")!
        }
    
        var selectedOffice = SelectedOfficeData(name: office.name!, photo: selectedImage, rating: office.rating, placeId: office.placeId!, photoReference: office.photoReference!)
        
        selectedOffice.latitude = office.latitude
        selectedOffice.longitude = office.longitude
        
        return selectedOffice
    }

    func errorAlertView(title: String, message: String) -> UIAlertController {
        print("message at errorAlertView: \(message)")
        let invalidURLAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        invalidURLAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        return invalidURLAlert
    }
    
    func showActivityIndicator(uiView: UIView) -> UIActivityIndicatorView {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 60.0)
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        actInd.transform = transform
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray
    
        return actInd
    }
    
    func smallScreenSize() -> Bool {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        if screenWidth < 400 {
            return true
        } else {
            return false
        }
    }
    
    static let sharedInstance = practiceViewUtility ()
}

