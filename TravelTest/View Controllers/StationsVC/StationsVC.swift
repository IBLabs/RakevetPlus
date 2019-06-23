//
//  ViewController.swift
//  TravelTest
//
//  Created by Itamar Biton on 14/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class StationsVC: UIViewController {
    
    @IBOutlet weak private var destStationLabel: UILabel!
    @IBOutlet weak private var origStationLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var favouritesTableView: RigidTableView!
    @IBOutlet weak private var recentsTableView: RigidTableView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var searchButtonLabel: UILabel!
    
    var stations = [TrainStation]()
    var favouriteRoutes = [FavouriteRoute]()
    var recentRoutes = DataStore.shared.getRecentRoutes()
    
    private var destStation: TrainStation? {
        didSet {
            guard let station = self.destStation else { return }
            self.destStationLabel.text = station.heName
        }
    }
    private var origStation: TrainStation? {
        didSet {
            guard let station = self.origStation else { return }
            self.origStationLabel.text = station.heName
        }
    }
    private var selectedDate: Date? = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableViews()
        configureDate()
        initializeSearchButtonAnimation()
        
        decodeStations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recentRoutes = DataStore.shared.getRecentRoutes()
        self.recentsTableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    // MARK: Animation Methods
    
    private func initializeSearchButtonAnimation() {
        self.activityIndicator.transform = .init(translationX: 0, y: -64)
        self.activityIndicator.alpha = 0
    }
    
    private func setSearchButton(loading: Bool) {
        let visualChanges = {
            if loading {
                self.activityIndicator.transform = .identity
                self.activityIndicator.alpha = 1
                
                self.searchButtonLabel.transform = .init(translationX: 0, y: 64)
                self.searchButtonLabel.alpha = 0
            } else {
                self.activityIndicator.transform = .init(translationX: 0, y: -64)
                self.activityIndicator.alpha = 0
                
                self.searchButtonLabel.transform = .identity
                self.searchButtonLabel.alpha = 1
            }
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: visualChanges, completion: nil)
    }
    
    // MARK: Configuration Methods
    
    private func configureTableViews() {
        self.favouritesTableView.dataSource = self
        self.favouritesTableView.delegate = self
        
        self.recentsTableView.dataSource = self
        self.recentsTableView.delegate = self
    }
    
    private func configureDate() {
        guard let selectedDate = self.selectedDate else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "he_IL")
        formatter.dateFormat = "EEEE, d MMMM, HH:mm"
        
        self.dateLabel.text = formatter.string(from: selectedDate)
    }
    
    // MARK: Utility Methods
    
    private func fetchRoute() {
        guard let selectedDate = self.selectedDate,
            let origStation = self.origStation,
            let destStation = self.destStation
            else {
                return
        }
        
        let dateString = formatDateAsParameter(date: selectedDate)
        let parameters: Parameters = ["date": dateString, "destination": destStation.id, "origin": origStation.id, "hours": 0]
        
        AF.request("https://moblin.rail.co.il/rail/v01/schedulev2", method: .get, parameters: parameters).response { response in
            self.setSearchButton(loading: false)
            
            if let data = try? response.result.get(), let routeResult = self.decodeRouteResult(data: data) {
                let routeResultVC = RouteResultVC()
                routeResultVC.routeResult = routeResult
                routeResultVC.origStation = self.origStation
                routeResultVC.destStation = self.destStation
                routeResultVC.date = self.selectedDate
                self.navigationController?.pushViewController(routeResultVC, animated: true)
            }
        }
    }
    
    private func formatDateAsParameter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "he_IL")
        formatter.dateFormat = "dd/MM/yyyy"
        
        return formatter.string(from: date)
    }
    
    private func decodeRouteResult(data: Data) -> RouteResult? {
        let decoder = JSONDecoder()
        do {
            let routeResultService = try decoder.decode(RouteResultContainerService.self, from: data)
            return RouteResult(service: routeResultService)
        } catch let error {
            print("failed to decode, \(error.localizedDescription)")
            return nil
        }
    }
    
    private func decodeStations() {
        if let stationsFilePath = Bundle.main.path(forResource: "train_stations", ofType: "json") {
            let stationsFileUrl = URL(fileURLWithPath: stationsFilePath)
            let stationsData = try? Data(contentsOf: stationsFileUrl)
            
            let decoder = JSONDecoder()
            if let stationsData = stationsData {
                do {
                    let container = try decoder.decode(TrainStationContainer.self, from: stationsData)
                    let stations = container.stationsContainer.stations
                    DataStore.shared.set(stations: stations)
                    self.stations = stations
                } catch let error {
                    print("error decoding stations JSON, \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: User Intreaction Methods
    
    @IBAction private func didClickedMapButton(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let stationsMapVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.stationsMap) as? StationsMapVC {
            stationsMapVC.stations = self.stations
            self.present(stationsMapVC, animated: true, completion: nil)
        }
    }
    
    @IBAction private func didClickedSetOriginButton(sender: UIButton) {
        SearchStationVC.present(from: self, stations: self.stations) { station in
            self.origStation = station
            
        }
    }
    
    @IBAction private func didClickedSetDestinationButton(sender: UIButton) {
        SearchStationVC.present(from: self, stations: self.stations) { station in
            self.destStation = station
        }
    }
    
    @IBAction private func didClickedSetTimeButton(sender: UIButton) {
        DatePickerVC.present(from: self) { (date) in
            self.selectedDate = date
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "he_IL")
            formatter.dateFormat = "EEEE, d MMMM, HH:mm"
            
            self.dateLabel.text = formatter.string(from: date)
        }
    }
    
    @IBAction private func didClickedSearchButton(sender: UIButton) {
        guard let origStation = self.origStation, let destStation = self.destStation, self.selectedDate != nil else {
            return
        }
        
        let recentRoute = RecentRoute(origStation: origStation, destStation: destStation, date: Date())
        DataStore.shared.add(recentRoute: recentRoute)
        
        self.setSearchButton(loading: true)
        self.fetchRoute()
    }
}

extension StationsVC: UITableViewDataSource {
    var emptyFavouriteCellIdentifier: String { return "co.itamarbiton.TravelTest.EmptyFavouriteRouteCellIdentifier" }
    var favouriteCellIdentifier: String { return "co.itamarbiton.TravelTest.FavouriteRouteCellIdentifier" }
    var emptyRecentCellIdentifier: String { return "co.itamarbiton.TravelTest.EmptyRecentRouteCellIdentifier" }
    var recentCellIdentifier: String { return "co.itamarbiton.TravelTest.RecentRouteCellIdentifier" }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.favouritesTableView:
            return (self.favouriteRoutes.count > 0 ? self.favouriteRoutes.count : 1)
            
        case self.recentsTableView:
            return (self.recentRoutes.count > 0 ? self.recentRoutes.count : 1)
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch tableView {
        case self.favouritesTableView:
            let identifier = self.favouriteRoutes.count > 0 ? favouriteCellIdentifier : emptyFavouriteCellIdentifier
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            if let cell = cell as? FavouriteRouteCell {
                let favouriteRoute = self.favouriteRoutes[indexPath.row]
                cell.configure(with: favouriteRoute)
            }
            
        case self.recentsTableView:
            let identifier = self.recentRoutes.count > 0 ? recentCellIdentifier : emptyRecentCellIdentifier
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            if let cell = cell as? RecentRouteCell {
                let recentRoute = self.recentRoutes[(recentRoutes.count - 1) - indexPath.row]
                cell.configure(with: recentRoute)
            }
            
        default:
            break
        }
        
        return cell
    }
}

extension StationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.favouritesTableView:
            break
            
        case self.recentsTableView:
            if let cell = tableView.cellForRow(at: indexPath) as? RecentRouteCell {
                tableView.deselectRow(at: indexPath, animated: true)
                cell.performNudgeAnimation()
            }
            
            let recentRoute = self.recentRoutes[(self.recentRoutes.count - 1) - indexPath.row]
            self.origStation = recentRoute.origStation
            self.destStation = recentRoute.destStation
            
        default:
            break
        }
    }
}
