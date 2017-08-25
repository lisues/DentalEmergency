//
//  tempLocation.swift
//  DentalEmergency
//
//  Created by Robert Alavi on 7/20/17.
//
//
//-----------
/*
 import MapKit
 import UIKit
 
 class ViewController: UIViewController, MKMapViewDelegate {
 @IBOutlet weak var mapView: MKMapView!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 let request = MKDirectionsRequest()
 request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.7127, longitude: -74.0059), addressDictionary: nil))
 request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667), addressDictionary: nil))
 request.requestsAlternateRoutes = true
 request.transportType = .automobile
 
 let directions = MKDirections(request: request)
 
 directions.calculate { [unowned self] response, error in
 guard let unwrappedResponse = response else { return }
 
 for route in unwrappedResponse.routes {
 self.mapView.add(route.polyline)
 self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
 }
 }
 }
 
 func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
 let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
 renderer.strokeColor = UIColor.blue
 return renderer
 }
 } 
 
 --------------
 Job Search Plan Assignment: Think about how you might be able to overcome the challenges you identified earlier and create your personal job search plan.
 1. Create a copy of the Job Search Plan template for yourself.
 https://docs.google.com/document/d/1VD8vwfQKzNO1PK_SW4RzRACan7XluClHM_VcH9vFl5k/edit?usp=sharing
 
 2. Identify your strengths.  Write at least 3 strengths and why it will help you in your jobs search.
 
 3. Identify your challenges. Write 1-2 sentences explaining each issue and why you feel it will be difficult.  Include the challenges identified earlier along with any others that come to mind.  Earlier you noted your challenges as: Connecting with employers or other industry professionals, Differentiating myself from other applicants
 
 4. Review the following guide which provides resources and suggestions that we'd like to see you work into your plan.
 https://docs.google.com/document/d/1nVh6yp4jIQysEy_FYY4Ehf8Gobyxane8rvYBoSDtANA/edit?usp=sharing
 
 5. Commit to 1-2 actions you will do each week that help you overcome your identified challenges. Write them in your plan below each challenge.

 
 
 
 */
