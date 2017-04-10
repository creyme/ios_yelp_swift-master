//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    // OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    // VARIABLES
    var businesses: [Business]!
    var filteredBusiness: [Business] = []
    var filters = [String:AnyObject]()
    
    var searchBar: UISearchBar!
    var customView: UIView!
    
    var currentSearch = "Restaurants"
    var limit = 10
    var offSet = 0
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    
// DEFAULT FUNCTIONS ---------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TABLEVIEW SETTINGS
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 81
        
        // SEARCHBAR SETTINGS
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants"
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
        
        // KEYBOARD SETTINGS
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap(_:)))
        hideKeyboard.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideKeyboard)
        
        // INFINITE SCROLLVIEW
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        
        filters["category_filter"] = nil
        filters["sort"] = YelpSortMode.bestMatched.rawValue as AnyObject
        filters["deals_filter"] = 0 as AnyObject
        filters["radius_filter"] = 4000 as AnyObject
        filters["offset"] = 0 as AnyObject
        filters["term"] = currentSearch as AnyObject
        
        // LOAD RESTAURANTS NEARBY [!]
        Business.searchWithTerm(term: currentSearch, offset: offSet) { (businesses, error) in
            if let businesses = businesses {
                self.businesses = businesses
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                    print(business.distance!)
                }
                self.filteredBusiness = self.businesses
                self.tableView.reloadData()
            }
        }

        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
}
    
    
    
// TABLEVIEW FUNCTIONS ---------------------------------------------------------------------

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate {

    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return filteredBusiness.count

    }
    
    // Cell configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = filteredBusiness[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: "businessDetailsSegue", sender: nil)
    }
    
    func filtersViewController(filtersViewConroller: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let deals = filters["deals_filter"] as? Bool
        let distance = filters["radius_filter"] as? String
        let sort = filters["sort"] as? YelpSortMode
        let categories = filters["category_filter"] as? [String]
        
    
        Business.searchWithTerm(term: currentSearch, offset: offSet, sort: sort, radius: nil, categories: categories, deals: deals) { (businesses, error) in
            self.businesses = businesses
            self.filteredBusiness = self.businesses
            self.tableView.reloadData()

        }

        
        
    }


// SEGUE ------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print ("prepare for segue")
        
        //let navigationController = segue.destination as! UINavigationController
        /*if navigationController.viewControllers[0] is MapViewController {
            let mapViewController = navigationController.viewControllers[0] as! MapViewController
            mapViewController.delegate(self)
        }*/
        /*let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
        */

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
            let errormessage = "none"
            if let cell = sender as? BusinessCell {
            let indexPath = tableView.indexPath(for: cell)
            let businessDetails = filteredBusiness[indexPath!.row]
                print (businessDetails.name ?? "0")
            
            let detailsViewController = segue.destination as! DetailsViewController
            
            
            // Pass the selected object to the new view controller.
            
            detailsViewController.businessDetail = businessDetails
        }
           
    
    }
}









// SEARCHBAR FUNCTIONS ---------------------------------------------------------------------

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredBusiness = []
        //currentSearch = searchText
        
        for business in businesses {
            
            if((business.name?.contains(searchText))! || (business.categories?.contains(searchText))!) {
                filteredBusiness.append(business)
            }
        }
        if(searchText == "") {
            filteredBusiness = businesses
        }
        /*
        Business.searchWithTerm(term: searchText, completion: { (foundBusinesses: [Business]?, error: Error?) -> Void in
            
            if let businesses = foundBusinesses {
                self.filteredBusiness = foundBusinesses!
                    for business in businesses {
                        print(business.name!)
                        print(business.address!)
                        print(business.distance!)
                    }
            } else {
                print ("no found items")
                // Set UIImage(no results)
            }*/
            self.tableView.reloadData()
        }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func hideKeyboardOnTap(_ recognizer: UITapGestureRecognizer) {
        
        self.searchBar.endEditing(true)
        
    }
    
    
}

// SCROLLVIEW FUNCTIONS ---------------------------------------------------------------------

extension BusinessesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
            
                isMoreDataLoading = true
                
                
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            
                
            }
        }
    
    }
    
    
    func loadMoreData() {
        
        
        offSet = offSet + 10
        filters["offset"] = offSet as AnyObject
       /*
        let deals = filters["deals_filter"] as? Bool
        let distance = filters["radius_filter"] as? String
        let sort = filters["sort"] as? YelpSortMode
        let categories = filters["category_filter"] as? [String]
        */
        Business.searchWithTerm(term: currentSearch, offset: offSet) { (businesses, error) in
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
                //self.filteredBusiness += businesses!
                //self.filteredBusiness.append(self.businesses)
            for business in businesses! {
                self.businesses = businesses
                self.filteredBusiness = self.businesses
            }
             self.tableView.reloadData()
        }
        
        
    }
}

