//
//  DetailsViewController.swift
//  Yelp
//
//  Created by CRISTINA MACARAIG on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var businessDetail: Business!
    
    // OUTLETS
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewsCounterLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

                /*if businessDetail.imageURL != nil {
                    businessImageView.setImageWith(businessDetail.imageURL!)
                } else {
                    businessImageView.image = UIImage(named: "icon1@2x.png")
                }
                if businessDetail.ratingImageURL != nil {
                    ratingImageView.setImageWith(businessDetail.ratingImageURL!)
                } else {
                    ratingImageView.image = UIImage(named: "icon1@2x.png")
                }
                
                
                self.nameLabel.text = businessDetail.name
                self.distanceLabel.text = businessDetail.distance
                self.reviewsCounterLabel.text = "\(businessDetail.reviewCount!) Reviews"
                self.addressLabel.text = businessDetail.address
                self.categoriesLabel.text = businessDetail.categories
                
        */
        
        
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
