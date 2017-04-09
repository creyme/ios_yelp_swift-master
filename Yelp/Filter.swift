//
//  Filter.swift
//  Yelp
//
//  Created by CRISTINA MACARAIG on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

class Filter {
    
    var name: String
    var values: [[String:String]]
    var isExpandable: Bool
    var isExpanded: Bool
    var NumOfRows: Int
    
    init(name: String, values:[[String:String]], isExpandable: Bool, isExpanded: Bool, NumOfRows: Int) {
        
        self.name = name
        self.values = values
        self.isExpandable = isExpandable
        self.isExpanded = isExpanded
        self.NumOfRows = NumOfRows

   }
}
