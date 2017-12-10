//
//  SelectedOfficesTableViewController.swift
//  DentalEmergency
//
//  Created by Lisue She on 7/29/17.
//
//

import UIKit
import CoreData
    
class SelectedOfficesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var appDelegate: AppDelegate!
    var stack: CoreDataStack!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    var selectedOffices = [SelectedOfficeData]()
    
    var myLocation: PracticePinAnnotation?
    var selectedOffice: SelectedOfficeData?
    var selectedOfficeIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        stack = appDelegate.stack
        selectedOffices = appDelegate.selectedOffices

        let dentalEmergencyDataCore = DentalEmergencyDataCore()
        fetchedResultsController = dentalEmergencyDataCore.initFetchResultsController(entityType: EntityType.selectedOffice, context: stack.context, predicate: nil)
        
        if appDelegate.initialViewDone {
            appDelegate.lastVisitView = ViewControllerEnum.selectedView
        } else {
            appDelegate.initialViewDone = true
            appDelegate.lastVisitView = ViewControllerEnum.selectedView
            myLocation = appDelegate.myLocation
        }
    }

    
    @IBAction func dismissedVC(_ sender: Any) {
        appDelegate.lastVisitView = ViewControllerEnum.startView
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let fc = fetchedResultsController {
            return fc.sections![section].numberOfObjects
        }

        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedOfficeCell", for: indexPath) as! SelectedOfficesTableViewCell
        
        if let fc = fetchedResultsController,
            fc.sections![indexPath.section].numberOfObjects > indexPath.row {
            let selectedOffice = fetchedResultsController?.object(at: indexPath) as! MySelectedOffices
            if let myPhoto = selectedOffice.photo {
                cell.officePhoto.image = UIImage(data: myPhoto as Data)
            } else {
                cell.officePhoto.image = UIImage(named: "default")
            }
            if let officeInfo = selectedOffice.name {
                cell.officeName.text = "       \(officeInfo)"
            }
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(indexPath.row)
     
        let office = fetchedResultsController?.object(at: indexPath) as! MySelectedOffices
        
        selectedOffice = practiceViewUtility.sharedInstance.convertCoreDataToDataStructure( office: office )
        
        selectedOfficeIndex = indexPath
        
        performSegue(withIdentifier: "selectedOffice", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier! == "selectedOffice" {
            if let selectedOfficeVC = segue.destination as? PracticeDetailViewController {
                selectedOfficeVC.fromSelected = true
                selectedOfficeVC.myLocation = myLocation
                selectedOfficeVC.selectedOffice = selectedOffice
                selectedOfficeVC.selectedOfficeIndex = selectedOfficeIndex
            }
        }
    }
  
}
