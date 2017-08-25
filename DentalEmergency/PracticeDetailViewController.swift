//
//  PracticeDetailViewController.swift
//  DentalEmergency
//
//  Created by Lisue She on 7/21/17.
//
//

import UIKit
import CoreData
import CoreLocation

class PracticeDetailViewController: UIViewController, CLLocationManagerDelegate {

    var practiceInfo: PracticePinAnnotation?
    
    var selectedOffices = [SelectedOfficeData]()

    @IBOutlet weak var officeName: UILabel!
    @IBOutlet weak var officePhoto: UIImageView!
    @IBOutlet weak var ratingNum: UILabel!
    @IBOutlet weak var ratingPhoto: UIImageView!
    
    @IBOutlet weak var officePhone: UIButton!
    @IBOutlet weak var officeURL: UIButton!
    @IBOutlet weak var officeAddress: UILabel!
    
    @IBOutlet weak var mondayTime: UILabel!
    @IBOutlet weak var tuesdayTime: UILabel!
    @IBOutlet weak var wednesdayTime: UILabel!
    @IBOutlet weak var thursdayTime: UILabel!
    @IBOutlet weak var fridayTime: UILabel!
    @IBOutlet weak var saturdayTime: UILabel!
    @IBOutlet weak var sundayTime: UILabel!
    
    @IBOutlet weak var openNow: UILabel!
    
    @IBOutlet weak var officeDetailOutlet: UIStackView!
    @IBOutlet weak var schedule: UIStackView!
    
    @IBOutlet weak var officeHrLabel: UILabel!
    @IBOutlet weak var footNavigatorBar: UINavigationBar!
    @IBOutlet weak var reviewsButton: UIButton!
    
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addSelected: UIBarButtonItem!
    @IBOutlet weak var deletedOffice: UIButton!
   
    var myWeb: String = ""
    var myReviews: [AnyObject]?
    
    var appDelegate: AppDelegate!
    var stack: CoreDataStack!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?

    var fromSelected = false
    var myLocation: PracticePinAnnotation?
    var selectedOffice: SelectedOfficeData?
    var selectedOfficeIndex: IndexPath?
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        stack = appDelegate.stack
        
        reviewsButton.isEnabled = false
        
        practiceViewUtility.sharedInstance.switchSelectedOfficeOptions( fromSelected: fromSelected, addSelected: addSelected, deletedOffice:  deletedOffice)

       
        let dentalEmergencyDataCore = DentalEmergencyDataCore()
        fetchedResultsController = dentalEmergencyDataCore.initFetchResultsController(entityType: EntityType.selectedOffice, context: stack.context, predicate: nil)
        
        guard let placeId = getPracticeId()  else {
            return
        }
        
        if fromSelected {
            officePhoto?.image = selectedOffice?.photo
        } else {
            officePhoto?.image = UIImage(named: "default")
        }
        
        activityIndicator = practiceViewUtility.sharedInstance.showActivityIndicator(uiView: view)
        DispatchQueue.main.async {
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        
        googleSearchOfficeDetail(practiceId: placeId) { (error) in
            
            if let error = error {
                print("Network Error")
                let userInfo = error.userInfo[NSLocalizedDescriptionKey]
                let message = userInfo as! String
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.present(practiceViewUtility.sharedInstance.errorAlertView(title:"Network Error", message:message), animated: true, completion: nil)
                }
            }
            
            if self.selectedOffice == nil {
                self.selectedOffice = SelectedOfficeData( selectedOfficeInform: self.practiceInfo!, photo: self.officePhoto?.image)
            }

            self.selectedOffice?.photo = self.officePhoto?.image
            self.appDelegate.selectedOffice = self.selectedOffice
            
            if self.appDelegate.initialViewDone {
                self.appDelegate.lastVisitView = ViewControllerEnum.practiceView
            } else {
                if self.appDelegate.lastVisitView == ViewControllerEnum.practiceView {
                    self.appDelegate.initialViewDone = true
                } else {
                    self.goToLastVisitView()
                }
            }
        }
    }

    
    @IBAction func dismissedVC(_ sender: Any) {
        appDelegate.lastVisitView = ViewControllerEnum.startView
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addSelectedOffice(_ sender: Any) {
        selectedOffice = SelectedOfficeData( selectedOfficeInform: practiceInfo!, photo: officePhoto.image )
        practiceViewUtility.sharedInstance.addingOfficeToList( senderView: self, myLocation: myLocation, selectedOfficeInform: selectedOffice!, stack: stack!)
    }
    
    @IBAction func deletedSelectedOffice(_ sender: Any) {
        practiceViewUtility.sharedInstance.deleteSelectedOffice( senderView: self, indexPath: selectedOfficeIndex!, myLocation: myLocation, stack: stack!, fetchedResultsController: fetchedResultsController  )
    }
    
    @IBAction func makeCall(_ sender: Any) {
        callOffice()
    }
    
    
    @IBAction func callOfficeWithNumber(_ sender: Any) {
        callOffice()
    }
    
    @IBAction func goToOfficeWebsite(_ sender: Any) {
        
        if UIApplication.shared.canOpenURL(URL(string: myWeb)!) {
            UIApplication.shared.open(URL(string: myWeb)!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func goToDirection(_ sender: Any) {
        let directions = self.storyboard!.instantiateViewController(withIdentifier: "DirectionsViewController") as! DirectionsViewController
        
        if fromSelected {
            directions.selectedOffice = selectedOffice
        } else {
            directions.selectedOffice = SelectedOfficeData( selectedOfficeInform: practiceInfo!, photo: officePhoto.image )
        }
        
        directions.myLocation = myLocation

        self.present(directions, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier! == "reviewsDetail" {
            if let reviewsVC = segue.destination as? ReviewTableViewController {
                reviewsVC.myReviews = myReviews
                reviewsVC.fromSelected = fromSelected
                reviewsVC.selectedOffice = selectedOffice
                if fromSelected {
                    reviewsVC.selectedOfficeIndex = selectedOfficeIndex
                }
            }
        } else if segue.identifier! == "directionsRoute" {
            if let directionsVC = segue.destination as? DirectionsViewController {
                directionsVC.myLocation = myLocation
                directionsVC.selectedOffice = selectedOffice
            }
        }
    }

    func getPracticeId() ->String? {
        
        var placeId: String?
        
        if fromSelected {
            placeId = selectedOffice?.placeId
        } else {
            placeId = practiceInfo?.placeId
        }
        
        guard let practiceId = placeId  else {
            print("error: cannot get placeid")
            return placeId
        }
        
        return placeId
    }
    
    func callOffice() {
        
        if let phoneNum = officePhone.titleLabel?.text {
            let callNumber = "1"+String(phoneNum.characters.filter { "01234567890.".characters.contains($0) })
            //if let url = URL(string: "tel://\(callNumber)") {
            if let url = URL(string: "tel:\(callNumber)") {
                 if (UIApplication.shared.canOpenURL(url)) {
                     UIApplication.shared.open(url)
                 } else {
                }
            }
        } else {
        }
    }
    
    func googleSearchOfficeDetail( practiceId: String, completionHandlerForGoogleSearchOffices: @escaping (_ error: NSError? ) -> Void ) {
        
        var isOpen: Bool = false
        var myOfficeHours: [String]?
        var officeAddr: String = ""
        var officeNum: String = ""
        
        DispatchQueue.main.async {
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        
        GoogleSearchService.sharedInstance.searchGoogleDentistDetail(searchInfo: practiceId, searchType: googleSearchType.detailSearch)  { ( practice, error ) in
            
            if let practice = practice {
                if let address = practice["formatted_address"] as? String {
                        officeAddr = address
                }
                
                if let phoneNum = practice["formatted_phone_number"]  as? String {
                        officeNum = phoneNum
                }
                
                if  let  hours = practice["opening_hours"] as? [String: AnyObject] {
                    isOpen = (hours["open_now"] as? Bool)!
                    if let officeHours = hours["weekday_text"] as? [String] {
                        myOfficeHours = officeHours
                    }
                }
                
                if let getURL = practice["website"] as? String {
                        self.myWeb = getURL
                }

                if let reviews = practice["reviews"] as? [AnyObject] {
                    self.myReviews = reviews
                    
                }

                DispatchQueue.main.async() {
                    self.activityIndicator.stopAnimating()
                    self.displayOfficeDetail(isOpen: isOpen, officeHrs: myOfficeHours, officeAddr: officeAddr, officeNum: officeNum, officeWeb: self.myWeb, reviews: self.myReviews)
                    if !self.fromSelected {
                        self.addSelected.isEnabled = true
                        if let office = self.selectedOffice {
                            self.selectedOffice = office
                        }
                    }
                }
                
                if ((!self.fromSelected)&&( self.practiceInfo?.photosReference != "" )) {
                    GoogleSearchService.sharedInstance.searchGoogleDentistPhoto(searchInfo: self.practiceInfo?.photosReference, searchType: googleSearchType.photoReference)  {  ( data: Data?, error ) in

                        if let imageData = data {
                            DispatchQueue.main.async(){
                                self.officePhoto?.image = UIImage(data: imageData as! Data)
                                self.selectedOffice?.photo = self.officePhoto?.image
                                self.appDelegate.selectedOffice = self.selectedOffice
                            }
                        } else {
                            completionHandlerForGoogleSearchOffices( error )
                        }
                    }
                }
             } else {
                DispatchQueue.main.async() {
                    self.activityIndicator.stopAnimating()
                }
                print("Practice No Detail Result")
            }
            completionHandlerForGoogleSearchOffices( error )
        }
    }
   
    func displayPracticeBasic(reviews: [AnyObject]?) {
        
        var isOpen: Bool = false
        var officeRate: Float = 0.0
        
        if fromSelected {
            officeName?.text = selectedOffice?.name
            officeRate = (selectedOffice?.rating)!
            officePhoto?.image = selectedOffice?.photo
        } else {
            officeName?.text = practiceInfo?.title
            officeRate = (practiceInfo?.rating)!
            if (practiceInfo?.open)! {
               isOpen = true
            }
        }
        
        ratingPhoto?.image = UIImage(named: practiceViewUtility.sharedInstance.getRantingPhoto( officeRank:  officeRate ) )
        
        if let myReviews = reviews {
                ratingNum?.text = "\(officeRate) (\(myReviews.count))"
        } else {
                ratingNum?.text = "(\(officeRate))"
        }
    }
    
    func displayOfficeDetail( isOpen: Bool, officeHrs: [String]?, officeAddr: String, officeNum: String, officeWeb: String, reviews: [AnyObject]? ) {

        updateUIElementsConstrainDynamically()
       
        displayPracticeBasic(reviews: reviews)
        
        if isOpen {
            openNow.text = "Open Now"
        } else {
            openNow.text = "Closed Now"
        }
        
        officePhone.setTitle(officeNum, for: .normal)
        officeURL.setTitle(officeWeb, for: .normal)
       
        officeAddress?.text = officeAddr
        if let officeHrs = officeHrs {
            mondayTime.text = officeHrs[0]
            tuesdayTime.text = officeHrs[1]
            wednesdayTime.text = officeHrs[2]
            thursdayTime.text = officeHrs[3]
            fridayTime.text = officeHrs[4]
            saturdayTime.text = officeHrs[5]
            sundayTime.text = officeHrs[6]
        } else {
            mondayTime.text = "Monday: N/A"
            tuesdayTime.text = "Tuesday: N/A"
            wednesdayTime.text = "Wednes day: N/A"
            thursdayTime.text = "Thursday: N/A"
            fridayTime.text = "Friday: N/A"
            saturdayTime.text = "Saturday: N/A"
            sundayTime.text = "Sunday: N/A"
        }
        
        if let reviews = myReviews {
            if reviews.count > 0 {
                reviewsButton.isEnabled = true
            }
        }
        directionButton.isEnabled = true
        backButton.isEnabled = true
    }
    
    func updateUIElementsConstrainDynamically() {
   
        let isSmall = practiceViewUtility.sharedInstance.smallScreenSize()
   
        if !isSmall {
            let newHight: CGFloat = 175.0
            let newWidth: CGFloat = (officePhoto?.frame.width)!
            print("new size: \(officePhoto?.frame.size)")
        
            officePhoto?.frame.size.width = newWidth
            officePhoto?.frame.size.height = newHight
            officePhoto?.contentMode = .scaleAspectFit
            officeDetailOutlet?.frame.origin.y = (officeDetailOutlet?.frame.origin.y)! + 50
            mondayTime.frame.origin.y = mondayTime.frame.origin.y - 5
            tuesdayTime.frame.origin.y = tuesdayTime.frame.origin.y - 10
            wednesdayTime.frame.origin.y = wednesdayTime.frame.origin.y - 20
            thursdayTime.frame.origin.y = thursdayTime.frame.origin.y - 30
            fridayTime.frame.origin.y = fridayTime.frame.origin.y - 40
            saturdayTime.frame.origin.y = saturdayTime.frame.origin.y - 50
            sundayTime.frame.origin.y = sundayTime.frame.origin.y - 60
            footNavigatorBar.frame.origin.y = footNavigatorBar.frame.origin.y - 50
        }
    }
    
    func goToLastVisitView() {
        
        if appDelegate.lastVisitView == ViewControllerEnum.reviewView {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "ReviewTableViewController") as! ReviewTableViewController
                controller.myReviews = myReviews
            self.present(controller, animated: true, completion: nil)
        } else {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "DirectionsViewController") as! DirectionsViewController
            self.present(controller, animated: true, completion: nil)
        }
    }
}
