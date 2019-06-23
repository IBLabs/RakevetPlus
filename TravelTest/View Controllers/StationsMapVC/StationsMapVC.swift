//
//  StationsMapVC.swift
//  TravelTest
//
//  Created by Itamar Biton on 14/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit
import MapKit

class StationsMapVC: UIViewController {
    
    var stations = [TrainStation]()
    
    @IBOutlet private weak var stationsMapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotations = self.stations.map { (trainStation) -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = trainStation.coordinate
            annotation.title = trainStation.heName
            
            return annotation
        }
        
        stationsMapView.addAnnotations(annotations)
    }
    
    @IBAction private func didClickedCloseButton(sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension StationsMapVC: MKMapViewDelegate {
    var stationAnnotationIdentifier: String { return "co.itamarbiton.TravelTest.StationAnnotationIdentifier" }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: stationAnnotationIdentifier) {
            annotationView = dequeuedAnnotationView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: stationAnnotationIdentifier)
        }
        
        annotationView?.canShowCallout = true
        annotationView?.image = UIImage(named: "train_pin_image")
        
        return annotationView
    }
}
