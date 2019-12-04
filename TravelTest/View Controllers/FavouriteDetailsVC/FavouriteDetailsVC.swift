//
//  FavouriteDetailsVC.swift
//  TravelTest
//
//  Created by Itamar Biton on 26/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit

class FavouriteDetailsVC: UIViewController {
    
    @IBOutlet weak private var overlayButton: UIButton!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var origStationLabel: UILabel!
    @IBOutlet weak private var destStationLabel: UILabel!
    @IBOutlet weak private var nameTextField: UITextField!
    
    private var origStation: TrainStation?
    private var destStation: TrainStation?
    
    private var favouriteRoute: FavouriteRoute?
    
    private var completion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let favouriteRoute = self.favouriteRoute {
            self.configure(with: favouriteRoute)
        }
        
        prepareForEnterAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performEnterAnimation { succeeded in 
            self.nameTextField.becomeFirstResponder()
        }
    }
    
    private func configure(with favouriteRoute: FavouriteRoute) {
        self.origStation = favouriteRoute.origStation
        self.destStation = favouriteRoute.destStation
        
        self.nameTextField.text = favouriteRoute.name
        self.origStationLabel.text = favouriteRoute.origStation.name
        self.destStationLabel.text = favouriteRoute.destStation.name
    }
    
    @IBAction private func didClickedSetOrigStationButton(sender: UIButton) {
        SearchStationVC.present(from: self, stations: DataStore.shared.stations, type: .origin) { (selectedStation) in
            self.origStation = selectedStation
            self.origStationLabel.text = selectedStation.name
        }
    }
    
    @IBAction private func didClickedSetDestStationButton(sender: UIButton) {
        SearchStationVC.present(from: self, stations: DataStore.shared.stations, type: .destination) { (selectedStation) in
            self.destStation = selectedStation
            self.destStationLabel.text = selectedStation.name
        }
    }
    
    @IBAction private func didClickedAddButton(sender: UIButton) {
        if self.nameTextField.text == nil || self.nameTextField.text == "" {
            self.nameTextField.shake()
        }
        
        if self.origStation == nil {
            self.origStationLabel.superview?.shake()
        }
        
        if self.destStation == nil {
            self.destStationLabel.superview?.shake()
        }
        
        if saveFavouriteRoute() {
            self.completion?()
            self.performExitAnimation { (succeeded) in
                self.presentingViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @IBAction private func didClickedCloseButton(sender: UIButton) {
        self.nameTextField.resignFirstResponder()
        
        self.performExitAnimation { (suceeded) in
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: Utility Methods
    
    private func saveFavouriteRoute() -> Bool {
        guard let origStation = self.origStation, let destStation = self.destStation, self.nameTextField.text != "", let name = self.nameTextField.text else {
            return false
        }
        
        if let favouriteRoute = self.favouriteRoute {
            let updateFavouriteRoute = favouriteRoute.updated(origStation: origStation, destStation: destStation, name: name)
            DataStore.shared.add(favouriteRoute: updateFavouriteRoute)
        } else {
            DataStore.shared.add(favouriteRoute: FavouriteRoute(origStation: origStation, destStation: destStation, name: name))
        }
        
        return true
    }

    // MARK: Animation Methods
    
    private func prepareForEnterAnimation() {
        self.overlayButton.alpha = 0
        
        let screenHeight = UIScreen.main.bounds.height
        self.containerView.transform = .init(translationX: 0, y: screenHeight)
    }
    
    private func performEnterAnimation(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            self.overlayButton.alpha = 1
            self.containerView.transform = .identity
        }, completion: completion)
    }
    
    private func performExitAnimation(completion: ((Bool) -> Void)? = nil) {
        let screenHeight = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            self.overlayButton.alpha = 0
            self.containerView.transform = .init(translationX: 0, y: screenHeight)
        }, completion: completion)
    }
    
    static func present(from presentingVC: UIViewController, favouriteRoute: FavouriteRoute? = nil, completion: (() -> Void)?) {
        let favouriteDetailsVC = FavouriteDetailsVC()
        favouriteDetailsVC.modalPresentationStyle = .overCurrentContext
        favouriteDetailsVC.completion = completion
        favouriteDetailsVC.favouriteRoute = favouriteRoute
        
        presentingVC.present(favouriteDetailsVC, animated: false, completion: nil)
    }
    
}

extension FavouriteDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
