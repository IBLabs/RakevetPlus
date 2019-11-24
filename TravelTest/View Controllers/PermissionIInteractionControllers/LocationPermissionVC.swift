//
//  LocationPermissionVC.swift
//  RakevetPlus
//
//  Created by Itamar Biton on 24/11/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPermissionVC: PermissionInteractionController {
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var buttonLabel: UILabel!
    @IBOutlet weak private var button: UIButton!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // round the button
        self.containerView.layer.cornerRadius = 12
        
        // set as not loading
        self.set(isLoading: false, animated: false)
    }
    
    // MARK: - User Interaction Methods
    
    @IBAction private func didClickAuthorizeButton(sender: UIButton) {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        self.set(isLoading: true, animated: true)
    }
    
    // MARK: Animation Methods
    
    private func set(isLoading: Bool, animated: Bool) {
        let visualChanges = {
            if isLoading {
                self.activityIndicator.startAnimating()
                self.activityIndicator.transform = .identity
                self.buttonLabel.transform = .init(translationX: 0, y: 56)
                self.buttonLabel.alpha = 0
            } else {
                self.activityIndicator.transform = .init(translationX: 0, y: -56)
                self.buttonLabel.transform = .identity
                self.buttonLabel.alpha = 1
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: visualChanges, completion: nil)
        } else {
            visualChanges()
        }
    }
}

extension LocationPermissionVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.finish()
    }
}
