//
//  ReviewTableViewController.swift
//  DentalEmergency
//
//  Created by Lisue She on 7/29/17.
//
//

import UIKit
import CoreData

class ReviewTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var fromSelected: Bool = false
    var myLocation: PracticePinAnnotation?
    var selectedOffice: SelectedOfficeData?
    var selectedOfficeIndex: IndexPath?
    var myReviews: [AnyObject]?
    
    @IBOutlet weak var reviewsTable: UITableView!
    @IBOutlet weak var addSelected: UIBarButtonItem!
    @IBOutlet weak var deletedOffice: UIButton!
    
    var selectedRowIndex: Int = -1
    let defaultHeight: CGFloat = 130
    var expenderHeight: CGFloat = 0.0
    
    var appDelegate: AppDelegate!
    var stack: CoreDataStack!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        stack = appDelegate.stack
        
        reviewsTable.dataSource = self
        reviewsTable.delegate = self
        
        let dentalEmergencyDataCore = DentalEmergencyDataCore()
        fetchedResultsController = dentalEmergencyDataCore.initFetchResultsController(entityType: EntityType.selectedOffice, context: stack.context, predicate: nil)
        
        if appDelegate.initialViewDone {
            appDelegate.lastVisitView = ViewControllerEnum.reviewView
        } else {
                appDelegate.initialViewDone = true
                appDelegate.lastVisitView = ViewControllerEnum.reviewView
                myLocation = appDelegate.myLocation
                selectedOffice = appDelegate.selectedOffice
        }
        
        practiceViewUtility.sharedInstance.switchSelectedOfficeOptions( fromSelected: fromSelected, addSelected: addSelected, deletedOffice:  deletedOffice)
    }
    
    @IBAction func dismissedTableView(_ sender: Any) {
        appDelegate.lastVisitView = ViewControllerEnum.practiceView
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addSelectedOffice(_ sender: Any) {
        practiceViewUtility.sharedInstance.addingOfficeToList( senderView: self, myLocation: myLocation, selectedOfficeInform:  selectedOffice!, stack: stack! )
    }
    
    @IBAction func deletedSelectedOffice(_ sender: Any) {
         practiceViewUtility.sharedInstance.deleteSelectedOffice( senderView: self,  indexPath: selectedOfficeIndex!, myLocation: myLocation, stack: stack!, fetchedResultsController: fetchedResultsController )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let reviews = myReviews {
            return reviews.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as? ReviewTableViewCell

        let isSmall = practiceViewUtility.sharedInstance.smallScreenSize()
        
        let myReview = myReviews?[(indexPath as NSIndexPath).row]

        if let authPhoto = myReview?["profile_photo_url"] as? String {
            let urlImage = URL(string: authPhoto)
            if let photoData = try? Data(contentsOf: urlImage!) {
                DispatchQueue.main.async() {
                    cell?.authorPicture?.image = UIImage(data: photoData)
                }
            }
        }
  
        if let authName = myReview?["author_name"] as? String {
            cell?.authorName.text = authName
        }
        
        if let rating = myReview?["rating"] as? Float {
            cell?.reviewRating?.image = UIImage(named: practiceViewUtility.sharedInstance.getRantingPhoto( officeRank: rating ) )
        }
    
        if let reviewTime = myReview?["relative_time_description"] as? String {
            if isSmall {
                cell?.reviewAge.font.withSize(13)
            }
            cell?.reviewAge.text = reviewTime
        }
        
        if let reviewText = myReview?["text"] as? String {
            if isSmall {
                cell?.reviewText.frame.size.width = 205.0
            }
            if self.selectedRowIndex == (indexPath as NSIndexPath).row {
                cell?.reviewText.frame.size.height = (cell?.reviewText.frame.size.height)!+expenderHeight
            } else {
                cell?.reviewText.frame.size.height = 46 //default reviewText height
            }
            cell?.reviewText.text = reviewText
        }
 
        if self.selectedRowIndex == (indexPath as NSIndexPath).row {
            cell?.backgroundColor = UIColor.lightGray
        } else {
            cell?.backgroundColor = UIColor.white
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var needHeight: CGFloat = defaultHeight
        let isSmall = practiceViewUtility.sharedInstance.smallScreenSize()
    
        if selectedRowIndex == indexPath.row {
            if let slectedReview = myReviews?[(indexPath as NSIndexPath).row], let textLength = slectedReview["text"] as? String {
                if isSmall {
                    needHeight = CGFloat((46*textLength.characters.count) / 55) + 84
                } else {
                    needHeight = CGFloat((46*textLength.characters.count) / 60) + 84
                }
            }
            expenderHeight = needHeight - defaultHeight
        }
        
        return needHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        guard let cell = tableView.cellForRow(at: indexPath) as? ReviewTableViewCell else {
            return
        }

        if ( selectedRowIndex == indexPath.row ) {
                selectedRowIndex = -1
        } else {
            selectedRowIndex = indexPath.row
        }
        self.reviewsTable.reloadData()
    }
}
