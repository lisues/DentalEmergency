//
//  RouteDetailsViewController.swift
//  DentalEmergency
//
//  Created by Lisue She on 8/26/17.
//
//

import UIKit
import MapKit

class RouteDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var routeStepsTable: UITableView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var address: UILabel!

    var destAddr: String = ""
    var miles: String = ""
    var route: MKRoute?
    
    override func viewDidLoad() {

        super.viewDidLoad()

        address.backgroundColor = UIColor(red: 0, green: 0.851, blue: 0.9294, alpha: 1.0)
        distance.backgroundColor = UIColor(red: 0, green: 0.851, blue: 0.9294, alpha: 1.0)
        address.text = destAddr
        distance.text = miles
        
        routeStepsTable.dataSource = self
        routeStepsTable.delegate = self
    }

    @IBAction func dismissed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let routeStep = route {
            return routeStep.steps.count
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeSteps", for: indexPath) as! RouteStepsTableViewCell
        let step = route?.steps[indexPath.row]
        if let distance = step?.distance {
            let miles = distance * 0.000621371
            cell.mile.text = "\(Double(round(100*miles)/100)) miles"
        }
        
        if let instruction = step?.instructions {
               cell.detail.text = "\(instruction)"
        }
        
        return cell
    }
}

