//
//  RouteDetailsViewController.swift
//  DentalEmergency
//
//  Created by Lisue She on 8/26/17.
//
//

import UIKit


class RouteDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var routeStepsTable: UITableView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var address: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTempFunctionGitHubProblem() {
        //testing on github activities
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("-------at route steps table view - 1 --------")
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("-------at route steps table view - 2 --------")
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeSetp", for: indexPath) as! RouteStepsTableViewCell
     //   cell.mile.text = "1.5"
      //  cell.detail.text = "testing"
       // cell.de
        return cell
    }


}
