//
//  ExpandableCell.swift
//  Yelp
//
//  Created by CRISTINA MACARAIG on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class ExpandableCell: UITableViewCell {

    
    @IBOutlet weak var expandableLabel: UILabel!
    @IBOutlet weak var expandableArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
