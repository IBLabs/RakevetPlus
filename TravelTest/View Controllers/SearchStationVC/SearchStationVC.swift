//
//  SearchStationVC.swift
//  TravelTest
//
//  Created by Itamar Biton on 14/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit

protocol SearchStationVCDelegate: class {
    func searchStationVC(_ searchStationVC: SearchStationVC, didSelectStation station: TrainStation)
}

extension SearchStationVCDelegate {
    func searchStationVC(_ searchStationVC: SearchStationVC, didSelectStation station: TrainStation) { }
}

class SearchStationVC: UIViewController {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var overlayButton: UIButton!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var stationsTableView: UITableView!
    @IBOutlet weak private var resultTableView: UITableView!
    
    var delegate: SearchStationVCDelegate?
    var stations = [TrainStation]()
    
    private var completion: ((TrainStation) -> Void)? = nil
    private var filteredStations = [TrainStation]()
    private var type: SearchType = .origin

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureLabels()
        self.configureTableViews()
        
        self.prepareForEnterAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.performEnterAnimation()
    }
    
    // MARK: User Interaction Methods

    private func configureLabels() {
        self.titleLabel.text = self.type.getTitle()
    }
    
    private func configureTableViews() {
        let cellNib = UINib(nibName: "StationResultCell", bundle: nil)
        self.stationsTableView.register(cellNib, forCellReuseIdentifier: stationResultCellIdentifier)
        self.resultTableView.register(cellNib, forCellReuseIdentifier: stationResultCellIdentifier)
    }
    
    @IBAction private func didClickedOverlayButton(sender: UIButton) {
        self.performExitAnimation { succeeded in
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: Animation Methods
    
    private func prepareForEnterAnimation() {
        let screenHeight = UIScreen.main.bounds.height
        
        self.containerView.transform = .init(translationX: 0, y: screenHeight)
        self.overlayButton.alpha = 0
    }
    
    private func performEnterAnimation(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            self.containerView.transform = .identity
            self.overlayButton.alpha = 1
        }, completion: completion)
    }
    
    private func performExitAnimation(completion: ((Bool) -> Void)? = nil) {
        let screenHeight = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            self.containerView.transform = .init(translationX: 0, y: screenHeight)
            self.overlayButton.alpha = 0
        }, completion: completion)
    }
    
    // MARK: - Presentation Methods
    
    static func present(from presentingVC: UIViewController, stations: [TrainStation], type: SearchType, completion: @escaping (TrainStation) -> Void) {
        let searchStationsVC = SearchStationVC()

        searchStationsVC.stations = stations
        searchStationsVC.type = type
        searchStationsVC.completion = completion
        searchStationsVC.modalPresentationStyle = .overCurrentContext
        
        presentingVC.present(searchStationsVC, animated: false, completion: nil)
    }
    
    static func present(from presentingVC: UIViewController, stations: [TrainStation], type: SearchType, delegate: SearchStationVCDelegate) {
        guard let searchStationsVC = StoryboardUtilities.instantiateFromMainStoryboard(identifier: ViewControllerIdentifiers.searchStations) as? SearchStationVC else  {
            return
        }
        
        searchStationsVC.stations = stations
        searchStationsVC.type = type
        searchStationsVC.delegate = delegate
        searchStationsVC.modalPresentationStyle = .overCurrentContext
        
        presentingVC.present(searchStationsVC, animated: false, completion: nil)
    }
    
}

// MARK: - UITableView Data Source Methods

extension  SearchStationVC: UITableViewDataSource {
    var stationResultCellIdentifier: String { return "co.itamarbiton.TravelTest.StationResultCellIdentifier" }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.stationsTableView:
            return self.stations.count
            
        case self.resultTableView:
            return self.filteredStations.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stationResultCellIdentifier, for: indexPath)
        
        if let cell = cell as? StationResultCell {
            var station: TrainStation!
            if tableView == self.stationsTableView {
                station = self.stations[indexPath.row]
            } else {
                station = self.filteredStations[indexPath.row]
            }
            cell.configure(with: station)
        }
        
        return cell
    }
}

// MARK: - UITableView Delegate Methods

extension SearchStationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedStation: TrainStation!
        if tableView == self.resultTableView {
            selectedStation = self.filteredStations[indexPath.row]
        } else {
            selectedStation = self.stations[indexPath.row]
        }
        
        self.completion?(selectedStation)
        self.delegate?.searchStationVC(self, didSelectStation: selectedStation)
        self.performExitAnimation { succeeded in
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
}

extension SearchStationVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.filteredStations = self.stations
        
        self.resultTableView.reloadData()
        self.resultTableView.isHidden = false
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let searchText = textField.text else {
            self.filteredStations = self.stations
            self.resultTableView.reloadData()
            return true
        }
        
        self.filteredStations = self.stations.filter({ $0.heName.contains(searchText) })
        self.resultTableView.reloadData()
        
        return true
    }
}
