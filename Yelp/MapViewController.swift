//
//  MapViewController.swift
//  Yelp
//
//  Created by CRISTINA MACARAIG on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    // OUTLET
    @IBOutlet weak var mapView: MKMapView!
/*    
    // SET UP
    let defaultCenterLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
    let regionRadius: CLLocationDistance = 2000
    var restaurants: RestaurantLocations!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        title = "Maps"

        goToLocation(location: defaultCenterLocation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        restaurants.businesses.forEach { Business in
            let restaurantPin = RestaurantPin(
                restaurant: restaurant,
                title: Business.name,
                subtitle: Business.address!
                )
            
            self.mapView.addAnnotation(restaurantPin)
            
        }
    }
    
    func goToLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor viewForAnnotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView()
        
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton (type: .infoLight) as UIView
        if #available(iOS 9.0, *) {
            view.pinTintColor = UIColor.red
        } else {
            // Fallback on earlier versions
        }
        view.tintColor = UIColor.lightText
        return view
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            (segue.destinationViewController as! EateryDetailViewController).eatery = (sender as! EateryPin).eatery
        }
    }
}

class EateryPin: NSObject, MKAnnotation {
    
    let eatery: Eatery!
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(eatery: Eatery, title: String, subtitle: String) {
        self.eatery = eatery
        self.coordinate = CLLocationCoordinate2D(latitude: Double(eatery.latitude), longitude: Double(eatery.longitude))
        self.title = title
        self.subtitle = subtitle
    }
    
   */
    
    
    
    
   
}
