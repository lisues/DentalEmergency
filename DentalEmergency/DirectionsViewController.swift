//
//  DirectionsViewController.swift
//  DentalEmergency
//
//  Created by Lisue She on 7/29/17.
//
//

import UIKit
import MapKit

//class DirectionsViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
class DirectionsViewController: UIViewController, MKMapViewDelegate {

    var appDelegate: AppDelegate!
    
    var myLocation: PracticePinAnnotation?
    var selectedOffice: SelectedOfficeData?
    
    var destination: MKMapItem?
    var annotations = [PracticePinAnnotation]()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
   
    var stepDisplay: Bool = false
    var routeSteps: Int = 0
    
    @IBOutlet weak var distance: UILabel!
  //  @IBOutlet weak var routeStepTable: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        mapView.delegate = self
        
  //      routeStepTable.dataSource = self
  //      routeStepTable.delegate = self
        
        if appDelegate.initialViewDone {
            appDelegate.lastVisitView = ViewControllerEnum.directionView
        } else {
            appDelegate.initialViewDone = true
            appDelegate.lastVisitView = ViewControllerEnum.directionView
            myLocation = appDelegate.myLocation
            selectedOffice = appDelegate.selectedOffice
        }
        
        activityIndicator = practiceViewUtility.sharedInstance.showActivityIndicator(uiView: view)
        DispatchQueue.main.async {
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }

        if let sourceLocation = myLocation {
            self.myLocation = sourceLocation
        } else {
            self.myLocation = appDelegate.myLocation
        }
        
        guard let sourceLocation = myLocation else {
            DispatchQueue.main.async() {
                self.activityIndicator.stopAnimating()
            }
            return
        }
        
        guard let destinationOffice = selectedOffice else {
            DispatchQueue.main.async() {
                self.activityIndicator.stopAnimating()
            }
            return
        }
        
        let officeLocation = converOfficeDataToAnnotation(destinationOffice: destinationOffice)
        
        annotations.append(myLocation!)
        annotations.append(officeLocation!)
    
        self.mapView.addAnnotations(annotations)
        let request = MKDirectionsRequest()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (myLocation?.coordinate.latitude)!, longitude: (myLocation?.coordinate.longitude)!), addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (officeLocation?.coordinate.latitude)!, longitude: (officeLocation?.coordinate.longitude)!), addressDictionary: nil))

        request.requestsAlternateRoutes = true
        request.transportType = .automobile
            
        let directions = MKDirections(request: request)
            
        directions.calculate(completionHandler: {(response, error) in
            
            if let error = error as? NSError {
                print("Error on network")
                let userInfo = error.userInfo[NSLocalizedDescriptionKey]
                let message = userInfo as! String
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.present(practiceViewUtility.sharedInstance.errorAlertView(title:"Network Error", message:message), animated: true, completion: nil)
                }
            } else {
                self.activityIndicator.stopAnimating()

                DispatchQueue.main.async() {
                    if let  unwrappedResponse = response {
    
                    //self.miles.backgroundColor = UIColor(red: 0, green: 0.851, blue: 0.9294, alpha: 1.0)
                        self.showRoute( unwrappedResponse )
                        self.setMapRegion( sourceLocation: self.myLocation!, destinationLocation: officeLocation! )
                        let distance = unwrappedResponse.routes[0].distance * 0.000621371
                        //self.miles.text = "\(Double(round(100*distance)/100)) miles"
                        self.distance.text = "\(Double(round(100*distance)/100)) miles"
                        self.mapView.add(unwrappedResponse.routes[0].polyline)
                    }
                }
            }
        })
    }
    
    @IBAction func dismissedVC(_ sender: Any) {
        appDelegate.lastVisitView = ViewControllerEnum.practiceView
        dismiss(animated: true, completion: nil)
    }
   
    @IBAction func routeSteps(_ sender: Any) {
  print("-------at route steps button--------")
        if !stepDisplay {
print("-------at route steps button: yes--------")
      //      routeStepTable.reloadData()
            stepDisplay = true
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
        } else {
            pinView?.image = UIImage(named: "pin_blue.png")
        }
    
        return pinView
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3.0
        return renderer
    }
   /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
print("-------at route steps table view - 1 --------")
        if stepDisplay {
            
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
print("-------at route steps table view - 2 --------")    
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeSetp", for: indexPath) as! RouteStepsTableViewCell
        cell.inMile.text = "1.5"
        cell.directions.text = "testing"
        
        return cell
    }
    */
    func converOfficeDataToAnnotation( destinationOffice: SelectedOfficeData? ) -> PracticePinAnnotation? {
        
        var officeLocation = PracticePinAnnotation()
        
        if let office = destinationOffice {
            officeLocation.coordinate.latitude = office.latitude
            officeLocation.coordinate.longitude =  office.longitude
            officeLocation.title = office.name
            officeLocation.rating = office.rating
        }
        return officeLocation
    }
    
    func getDirections() {
        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination!
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error getting directions")
            } else {
                self.showRoute(response!)
            }
        })
    }

    func showRoute(_ response: MKDirectionsResponse) {
        for route in response.routes {
            print("route: \(route)")
            mapView.add(route.polyline,
                         level: MKOverlayLevel.aboveRoads)
            print("---step count: \(route.steps.count)")
            for step in route.steps {
                print("\(step.instructions)       \(step.distance)")
            }
        }
    }
   
    func setMapRegion( sourceLocation: PracticePinAnnotation, destinationLocation: PracticePinAnnotation ) {
        
        var minLat: Double = 0.0
        var minLng: Double = 0.0
        var maxLat: Double = 0.0
        var maxLng: Double = 0.0

        if sourceLocation.coordinate.latitude >= destinationLocation.coordinate.latitude {
            minLat = destinationLocation.coordinate.latitude
            maxLat = sourceLocation.coordinate.latitude
        } else {
            minLat = sourceLocation.coordinate.latitude
            maxLat = destinationLocation.coordinate.latitude
        }
       
        if sourceLocation.coordinate.longitude >= destinationLocation.coordinate.longitude {
            minLng = destinationLocation.coordinate.longitude
            maxLng = sourceLocation.coordinate.longitude
        } else {
            maxLng = destinationLocation.coordinate.longitude
            minLng = sourceLocation.coordinate.longitude
        }

        let deltaLat = maxLat - minLat
        let deltaLng = maxLng - minLng
        
        let midLat = (minLat+maxLat)/2
        let midLng = (minLng+maxLng)/2
        
        let selectedDelta = max(deltaLat, deltaLng) + max(deltaLat, deltaLng)*1.85
        
        let center = CLLocationCoordinate2D(latitude: midLat, longitude: midLng)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: selectedDelta, longitudeDelta: selectedDelta))
        
        self.mapView.setRegion(region, animated: true)
        print("selctedDltae: \(selectedDelta) - lat: \(midLat) and lng: \(midLng)")
    }
}


