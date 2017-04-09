 //
//  BusinessCell.swift
//  Yelp
//
//  Created by CRISTINA MACARAIG on 4/5/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    // OUTLETS
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewsCounterLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    
    var business: Business! {
        didSet {
            if business.imageURL != nil {
                businessImageView.setImageWith(business.imageURL!)
            } else {
                businessImageView.image = UIImage(named: "icon1@2x.png")
            }
            if business.ratingImageURL != nil {
                ratingImageView.setImageWith(business.ratingImageURL!)
            } else {
                ratingImageView.image = UIImage(named: "icon1@2x.png")
            }
            
            
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            reviewsCounterLabel.text = "\(business.reviewCount!) Reviews"
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
            
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        businessImageView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
