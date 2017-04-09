//
//  CheckMarkCell.swift
//  Yelp
//
//  Created by CRISTINA MACARAIG on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class CheckMarkCell: UITableViewCell {

    @IBOutlet weak var checkMarkLabel: UILabel!
    
    var label: String? = nil
    var isChecked: Bool = false
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadData() {
        
        checkMarkLabel.text = label
        accessoryType = isChecked ? .checkmark : .none
        
        //accessoryType = UITableViewCellAccessoryType.checkmark
    }

}
