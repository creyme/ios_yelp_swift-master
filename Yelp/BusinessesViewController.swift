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
    
    var currentSearch = "Restaurants"
    
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
        hideKeyboard.numberOfTapsRequired = 2
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
        Business.searchWithTerm(filter: filters, term: currentSearch, offset: offSet) { (businesses, error) in
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
        
    
        Business.searchWithTerm(filter: filters, term: currentSearch, offset: offSet) { (businesses, error) in
            self.businesses = businesses
            self.filteredBusiness = self.businesses
            self.tableView.reloadData()
            self.tableView.scrollsToTop = true

            }
        
        }



// SEGUE ------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print ("prepare for segue")
        


        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "filtersViewControllerSegue" {
            let navigationController = segue.destination as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            
            filtersViewController.delegate = self
            
        } else {
            if segue.identifier == "businessDetailsSegue" {
            let detailsViewController = segue.destination as! DetailsViewController
                if let cell = sender as? BusinessCell {
                    self.tableView.deselectRow(at: self.tableView.indexPath(for: cell)!, animated: true)
                    detailsViewController.businessDetail = self.businesses![(self.tableView.indexPath(for: cell)!.row)]
                }
                
            }
    
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
            self.tableView.scrollsToTop = true
        }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        
        offSet = 0
        filters["term"] = searchBar.text! as AnyObject?
        filters["offset"] = offSet as AnyObject
        
        Business.searchWithTerm(filter: filters, term: currentSearch, offset: offSet) { (businesses, error) in
            if businesses != nil {
                self.businesses = businesses
                self.filteredBusiness = self.businesses
                self.tableView.reloadData()
                self.tableView.scrollsToTop = true
            } else {
                print("0 search")
            }
        }
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
        
        currentSearch = searchBar.text!
        offSet = offSet + 10
        filters["offset"] = offSet as AnyObject

        Business.searchWithTerm(filter: self.filters, term: currentSearch, offset: offSet) { (businesses, error) in
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
            self.businesses! += businesses!
            self.filteredBusiness = self.businesses
            self.tableView.reloadData()
        }
    }
}

