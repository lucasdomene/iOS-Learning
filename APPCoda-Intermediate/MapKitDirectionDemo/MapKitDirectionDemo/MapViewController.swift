//
//  MapViewController.swift
//  MapKitDirectionDemo
//
//  Created by Simon Ng on 18/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var segmentedControl:UISegmentedControl!
    
    var restaurant: Restaurant!
    let locationManager = CLLocationManager()
    var currentPlacemark: CLPlacemark?
    var currentTransportType = MKDirectionsTransportType.automobile
    var currentRoute: MKRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        segmentedControl.isHidden = true
        segmentedControl.addTarget(self, action: #selector(showDirection(sender:)), for: .valueChanged)
        
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.address, completionHandler: { placemarks, error in
            if error != nil {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.category
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })

    }
    
    // Route
    
    @IBAction func showDirection(sender: AnyObject) {
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        
        switch segmentedControl.selectedSegmentIndex {
            case 0: currentTransportType = .automobile
            case 1: currentTransportType = .walking
            default: break
        }
        
        segmentedControl.isHidden = false
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = currentTransportType
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (routeResponse, error) in
            guard let routeResponse = routeResponse else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = routeResponse.routes[0]
            self.currentRoute = route
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    // MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        if let currentPlacemarkCoordinate = currentPlacemark?.location?.coordinate {
            if currentPlacemarkCoordinate.latitude == annotation.coordinate.latitude && currentPlacemarkCoordinate.longitude == annotation.coordinate.longitude {
                let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                leftIconView.image = UIImage(named: restaurant.image)!
                annotationView?.leftCalloutAccessoryView = leftIconView
                
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                
                // Pin color customization
                if #available(iOS 9.0, *) {
                    annotationView?.pinTintColor = UIColor.orange
                }
            } else {
                // Pin color customization
                if #available(iOS 9.0, *) {
                    annotationView?.pinTintColor = UIColor.red
                }
            }
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = currentTransportType == .automobile ? UIColor.blue : UIColor.orange
        renderer.lineWidth = 3.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "showSteps", sender: view)
    }
    
    // Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSteps" {
            let routeTableViewController = segue.destination as! RouteTableViewController
            if let steps = currentRoute?.steps {
                routeTableViewController.routeSteps = steps
            }
        }
        
    }
    
    // Local Search
    
    @IBAction func showNearby(sender: AnyObject) {
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = restaurant.category
        searchRequest.region = mapView.region
        
        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.start { (response, error) in
            guard let response = response else {
                if let error = error {
                    print(error)
                }
                
                return
            }
            
            let mapItems = response.mapItems
            var nearbyAnnotations: [MKAnnotation] = []
            for item in mapItems {
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.subtitle = item.phoneNumber
                
                if let location = item.placemark.location {
                    annotation.coordinate = location.coordinate
                }
                nearbyAnnotations.append(annotation)
            }
            
            self.mapView.showAnnotations(nearbyAnnotations, animated: true)
        }
    }
    
}
