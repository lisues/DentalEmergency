//
//  ReviewTableViewCell.swift
//  DentalEmergency
//
//  Created by Lisue She on 7/30/17.
//
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var authorPicture: UIImageView!
    
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var reviewRating: UIImageView!
    @IBOutlet weak var reviewAge: UILabel!
    
    @IBOutlet weak var reviewText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


