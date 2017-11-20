//
//  NearByOfficesViewController.swift
//  DentalEmergency
//
//  Created by Lisue She on 7/19/17.
//
//

import UIKit
import CoreData
import MapKit
import CoreLocation


class NearByOfficesViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mapView: MKMapView!
     
    var appDelegate: AppDelegate!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?

    var locationManager: CLLocationManager!
    var myAnnotation = PracticePinAnnotation()
    var mySearchText: String = ""
    var searchLocation = ""
    var locationInit = false
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate
           
        mapView.delegate = self
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        
        if (CLLocationManager.locationServicesEnabled())  {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    @IBAction func refreashNextSearch(_ sender: Any) {
        
        if appDelegate.googlePageToken != "" {
            searchNearByDentists(searchInfo: appDelegate.googlePageToken, searchType:googleSearchType.moreSearch) {
                return
            }
        } else {
            if mySearchText != "" {
                searchNearByDentists(searchInfo: mySearchText, searchType:googleSearchType.textSearch) {
                    return
                }
            } else {
                searchNearByDentists(searchInfo: searchLocation, searchType:googleSearchType.nearBy) {
                    return
                }
            }
        }
    }
   
    @IBAction func viewSelectedOffices(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "SelectedOfficesTableViewController") as! SelectedOfficesTableViewController
        controller.myLocation = myAnnotation
        self.present(controller, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let currentLocation = manager.location {
            searchLocation = String(currentLocation.coordinate.latitude)+","+String(currentLocation.coordinate.longitude)
            myAnnotation.coordinate = currentLocation.coordinate
            myAnnotation.title = "I am here"
            myAnnotation.here = true
            appDelegate.myLocation = myAnnotation
        } else {
            mySearchText = "USA"
        }
        
        locationManager.stopUpdatingLocation()
        if ( locationInit ==  false ) {
            searchNearByDentists(searchInfo: searchLocation, searchType:googleSearchType.nearBy) {
                self.goToLastViewController()
            }
            locationInit = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        searchNearByDentists(searchInfo: "", searchType:googleSearchType.nearBy) {
            return
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text=""
    }
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text=""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.characters.count)! > 0 {
            mySearchText = searchBar.text!
            searchBar.placeholder = mySearchText
            searchBar.text = ""
            searchNearByDentists(searchInfo: mySearchText, searchType:googleSearchType.textSearch) {
                return
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        let practicePinAnnotation = annotation as! PracticePinAnnotation
        let ratingImage = practiceViewUtility.sharedInstance.getRantingPhoto( officeRank: practicePinAnnotation.rating )
        pinView?.detailCalloutAccessoryView = UIImageView(image: UIImage(named: ratingImage))
        
        if practicePinAnnotation.here {
           pinView?.image = UIImage(named: "pin_here.png")
        } else if practicePinAnnotation.open {
            pinView?.image = UIImage(named: "pin_blue.png")
        } else {
            pinView?.image = UIImage(named: "pin_purple.png")
        }
       
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "practiceDetail", sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier! == "practiceDetail" {
            
            if let detailVC = segue.destination as? PracticeDetailViewController {
                if let view=sender as? MKAnnotationView, let annotation=view.annotation as?
                    PracticePinAnnotation {
                        detailVC.practiceInfo = annotation
                        detailVC.myLocation = myAnnotation
                    }
            }
        }
    }
    
    func getAnnotationForPractice(practice: AnyObject)->PracticePinAnnotation? {
        
        var annotation = PracticePinAnnotation()
        
        guard let practice = practice as? [String:AnyObject] else {
            return nil
        }
 
        guard let geometry = practice["geometry"] as? [String:AnyObject] else {
            return nil
        }
        
        guard let location = geometry["location"]  else {
            return nil
        }
        
        if let latitude = location["lat"] as? Double,  let longitude = location["lng"] as? Double{
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            annotation.coordinate = coordinate
        }
        
        if let practiceName = practice["name"] as? String  {
            annotation.title = practiceName
        }
        
        if let openNow = practice["opening_hours"], let open = openNow["open_now"] as? Bool {
            if open {
                annotation.open = true
            }
        }
        
        if let rating = practice["rating"] as? Float {
            annotation.rating = rating
        }
    
        if let placeId = practice["place_id"] as? String {
            annotation.placeId = placeId
        }
        
        if let photos = practice["photos"]  as? [AnyObject]{
            if let first_photo = photos[0] as? [String:AnyObject] {
                if let myTest = first_photo["photo_reference"] as? String {
                    annotation.photosReference = myTest
                }
            }
        }
    
        return annotation
    }
    
    func setMapRegion( annotations: [PracticePinAnnotation] ) -> [PracticePinAnnotation] {
        
        var finalAnnotations: [PracticePinAnnotation] = annotations
        
        var minLat: Double = 0.0
        var minLng: Double = 0.0
        var maxLat: Double = 0.0
        var maxLng: Double = 0.0
        var initDone = false
        
        for annotation in annotations {
            if initDone  {
                minLat = min(minLat, annotation.coordinate.latitude)
                maxLat = max(maxLat, annotation.coordinate.latitude)
                minLng = min(minLng, annotation.coordinate.longitude)
                maxLng = max(maxLng, annotation.coordinate.longitude)
            } else {
                minLat = annotation.coordinate.latitude
                minLng = annotation.coordinate.longitude
                maxLat = annotation.coordinate.latitude
                maxLng = annotation.coordinate.longitude
                initDone = true
            }
        }
        
        if myAnnotation.coordinate.latitude >= minLat && myAnnotation.coordinate.latitude <= maxLat {
            finalAnnotations.append(self.myAnnotation)
        }
        
        let deltaLat = maxLat - minLat
        let deltaLng = maxLng - minLng
        
        let midLat = (minLat+maxLat)/2
        let midLng = (minLng+maxLng)/2
        
        let selectedDelta = max(deltaLat, deltaLng) + max(deltaLat, deltaLng)*0.1
        
        let center = CLLocationCoordinate2D(latitude: midLat, longitude: midLng)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: selectedDelta, longitudeDelta: selectedDelta))
    
        self.mapView.setRegion(region, animated: true)
        
        return finalAnnotations
    }
    
    func searchNearByDentists(searchInfo: String?, searchType: googleSearchType, completionHandlerForGoogleNearBySearch: @escaping () -> Void)  {
        
        var annotations = [PracticePinAnnotation]()

        activityIndicator = practiceViewUtility.sharedInstance.showActivityIndicator(uiView: view)
        DispatchQueue.main.async {
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        
        GoogleSearchService.sharedInstance.searchGoogleDentist(searchInfo:searchInfo, searchType:searchType)  { ( practices, nextPageToken, error ) in
 
            if let practices = practices {
                
                if let nextPageToken=nextPageToken {
                    self.appDelegate.googlePageToken = nextPageToken
                }
                
                for i in 0..<practices.count {
                    if let annotation = self.getAnnotationForPractice(practice: practices[i]) {
                        annotations.append(annotation)
                    }
                }
                
                DispatchQueue.main.async() {
                    self.activityIndicator.stopAnimating()
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    annotations = self.setMapRegion( annotations:  annotations )
                    self.mapView.addAnnotations(annotations)
                }
                
            } else {
                if let error = error {
                    let userInfo = error.userInfo[NSLocalizedDescriptionKey]
                    let message = userInfo as! String
                    DispatchQueue.main.async {
                       self.activityIndicator.stopAnimating()
                       self.present(practiceViewUtility.sharedInstance.errorAlertView(title:"Network Error", message:message), animated: true, completion: nil)
                    }
                }
                return
            }
            completionHandlerForGoogleNearBySearch()
        }
    }
    
    func goToLastViewController() {
        if appDelegate.lastVisitView == ViewControllerEnum.startView {
            appDelegate.initialViewDone = true
        } else if appDelegate.initialViewDone {
            appDelegate.lastVisitView = ViewControllerEnum.startView
        } else {
            if appDelegate.lastVisitView == ViewControllerEnum.selectedView {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "SelectedOfficesTableViewController") as! SelectedOfficesTableViewController
                controller.myLocation = myAnnotation
                controller.selectedOffice = appDelegate.selectedOffice
                self.present(controller, animated: true, completion: nil)
            } else {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "PracticeDetailViewController") as! PracticeDetailViewController
                controller.myLocation = myAnnotation
                controller.selectedOffice = appDelegate.selectedOffice
                controller.practiceInfo = PracticePinAnnotation(
                    name: (appDelegate.selectedOffice?.name)!,
                    placeId: (appDelegate.selectedOffice?.placeId)!,
                    photosReference: (appDelegate.selectedOffice?.photoReference)!,
                    rating: (appDelegate.selectedOffice?.rating)!,
                    latitude: (appDelegate.selectedOffice?.latitude)!,
                    longitude: (appDelegate.selectedOffice?.longitude)!)
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}
