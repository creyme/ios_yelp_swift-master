//
//  FiltersViewController.swift
//  Yelp
//
//  Created by CRISTINA MACARAIG on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit


@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController (filtersViewConroller: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController {
    
    // OUTLETS
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    // VARIABLES
    var categories: [[String:String]]!
    
    
    
    var currentDistance = ("Auto", -1)
    var currentSort = ("Best Match", 0)
    
    var filtersArray = [Filter]()
    var switchStates = [IndexPath:Bool]()
    
    
// DEFAULT FUNCTIONS ---------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // TABLEVIEW STTINGS
        tableView.delegate = self
        tableView.dataSource = self
        
        // LOAD
        
        filtersArray.append(Filter(name: "", values: [Filters.deals()], isExpandable: false, isExpanded: false, NumOfRows: 1))
            
        filtersArray.append(Filter(name: "Distance", values: Filters.distances(), isExpandable: true, isExpanded: false, NumOfRows: 1))
        
        filtersArray.append(Filter(name: "Sort by", values: Filters.sort(), isExpandable: true, isExpanded: false, NumOfRows: 1))
        
        filtersArray.append(Filter(name: "Categories", values: Filters.categories(), isExpandable: true, isExpanded: false, NumOfRows: 4))
        
        
        tableView.reloadData()
    }

    
// ACTIONS ---------------------------------------------------------------------
    
    @IBAction func filterCancelButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func filterSearchButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        var filters = [String : AnyObject]()
        var selectedCategories = [String]()
        var dealIsOn: Bool?
        
        for (indexPath,isSelected) in switchStates {
            
            if isSelected {
                if indexPath.section == 0 {
                    dealIsOn = true
                }
                if indexPath.section == 3 {
                    selectedCategories.append(filtersArray[indexPath.section].values[indexPath.row]["code"]!)
                }
            }
            
        }
        
        if selectedCategories.count > 0 {
            filters["category_filter"] = selectedCategories as AnyObject?
        }
        
        if currentDistance.1 > 0 {
            filters["radius_filter"] = currentDistance.1 as AnyObject?
        }
        
        filters["deals_filter"] = dealIsOn as AnyObject?
        
        filters["sort"] = currentSort.1 as AnyObject
        
        delegate?.filtersViewController?(filtersViewConroller: self, didUpdateFilters: filters)
        
        }
        
    }



// FILTERSET FUNCTIONS ---------------------------------------------------------------------

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
    
    
    // TABLEVIEW FUNCTIONS
    
    // Number of headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filtersArray[section].name
    }
    
    // Section height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filtersArray[section].isExpanded ? filtersArray[section].values.count : filtersArray[section].NumOfRows
        
    }
    
    // Cell configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentFilter = filtersArray[indexPath.section]
        
        switch indexPath.section {
            
            case 1,2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
            
                if currentFilter.isExpanded {
                
                    cell.expandableLabel.text = currentFilter.values[indexPath.row]["name"]
                    if (currentDistance.0 == currentFilter.values[indexPath.row]["name"] || currentSort.0 == currentFilter.values[indexPath.row]["name"]){
                        cell.expandableArrow.image = UIImage(named: "checked.png")
                    } else {
                        cell.expandableArrow.image = UIImage(named: "unchecked.png")
                    }
                } else {
                    cell.expandableLabel.text = ((indexPath.section == 1) ? currentDistance.0 : currentSort.0)
                    cell.expandableArrow.image = UIImage(named: "arrow.png")
                }
        
        
                return cell
        
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
        
                cell.delegate = self
        
                if (!currentFilter.isExpanded && indexPath.row == 3) {
                    
                    cell.seeAllLabel.isHidden = false
                    
                    
                    cell.switchLabel.isHidden = true
                    cell.onSwitch.isHidden = true
                } else {
                    if (indexPath.row == currentFilter.values.count && currentFilter.NumOfRows > 1) {
                        cell.onSwitch.isHidden = true
                        cell.seeAllLabel.isHidden = false
                    } else {
                        cell.onSwitch.isOn = switchStates[indexPath] ?? false
                        cell.onSwitch.isHidden = false
                    }
                    cell.seeAllLabel.isHidden = true
                    cell.switchLabel.isHidden = false
                    cell.switchLabel.text = currentFilter.values[indexPath.row]["name"]
                }
                return cell
            }
        }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentFilter = filtersArray[indexPath.section]
        
        switch indexPath.section {
        
        case 1, 2:
            if currentFilter.isExpanded {
                if indexPath.section == 1 {
                    currentDistance.0 = currentFilter.values[indexPath.row]["name"]!
                    currentDistance.1 = Int(currentFilter.values[indexPath.row]["code"]!)!
                } else {
                    currentSort.0 = currentFilter.values[indexPath.row]["name"]!
                    currentSort.1 = Int(currentFilter.values[indexPath.row]["code"]!)!
                }
            }
            currentFilter.isExpanded = !currentFilter.isExpanded
            tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)
        
        default:
            if ((indexPath.row == 3 && !currentFilter.isExpanded) || indexPath.row == currentFilter.values.count - 1) {
                currentFilter.isExpanded = !currentFilter.isExpanded
                tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)
            }
            
        }
        
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue: Bool) {
        
        let indexPath = tableView.indexPath(for: switchCell)!
        switchStates[indexPath] = didChangeValue
        print ("filter got switch event")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return filtersArray.count
    }
    
}


// FILTER SWITCH SETTINGS ---------------------------------------------------------------------

extension FiltersViewController {
    
    enum FilterName: Int {
        case Deals = 0, Distance, Sort, Categories
    }
}




