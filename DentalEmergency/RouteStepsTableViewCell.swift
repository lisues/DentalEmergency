//
//  RouteStepsTableViewCell.swift
//  DentalEmergency
//
//  Created by Lisue She on 9/13/17.
//
//

import UIKit

class RouteStepsTableViewCell: UITableViewCell {

    @IBOutlet weak var mile: UILabel!

    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
