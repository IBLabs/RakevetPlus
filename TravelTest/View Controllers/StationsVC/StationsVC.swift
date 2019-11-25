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
import Firebase

class StationsVC: UIViewController {

    @IBOutlet weak private var origStationContainerView: UIView!
    @IBOutlet weak private var destStationContainerView: UIView!
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
    var isFetchActive = false
    
    private var destStation: TrainStation? {
        didSet {
            guard let station = self.destStation else { return }
            self.animateReplaceText(label: self.destStationLabel, text: station.heName)
        }
    }
    private var origStation: TrainStation? {
        didSet {
            guard let station = self.origStation else { return }
            self.animateReplaceText(label: self.origStationLabel, text: station.heName)
        }
    }
    private var selectedDate: Date? = Date()
    
    private func animateReplaceText(label: UILabel, text: String) {
        let replacementLabel = UILabel(frame: .zero)
        replacementLabel.font = label.font
        replacementLabel.textColor = .black
        replacementLabel.alpha = 0
        replacementLabel.text = text
        replacementLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let superview = label.superview!
        superview.addSubview(replacementLabel)
        
        replacementLabel.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        replacementLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0).isActive = true
        superview.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            label.transform = .init(translationX: 0, y: -(replacementLabel.center.y - label.center.y))
            label.alpha = 0
            replacementLabel.transform = .init(translationX: 0, y: -(replacementLabel.center.y - label.center.y))
            replacementLabel.alpha = 1
        }) { (succeeded) in
            label.text = text
            label.transform = .identity
            label.alpha = 1
            replacementLabel.alpha = 0
            replacementLabel.removeFromSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableViews()
        self.configureDate()
        self.initializeSearchButtonAnimation()
        self.configureRemoteConfig()
        
        self.decodeStations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshRecentsTableView()
        refreshFavouritesTableView()
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
        let emptyFavouriteRouteCellNib = UINib(nibName: "EmptyFavouriteRouteCell", bundle: nil)
        self.favouritesTableView.register(emptyFavouriteRouteCellNib, forCellReuseIdentifier: "co.itamarbiton.TravelTest.EmptyFavouriteRouteCellIdentifier")
        let favouriteRouteCellNib = UINib(nibName: "FavouriteRouteCell", bundle: nil)
        self.favouritesTableView.register(favouriteRouteCellNib, forCellReuseIdentifier: "co.itamarbiton.TravelTest.FavouriteRouteCellIdentifier")
        
        self.favouritesTableView.dataSource = self
        self.favouritesTableView.delegate = self

        let emptyRecentRouteCellNib = UINib(nibName: "EmptyRecentRouteCell", bundle: nil)
        self.recentsTableView.register(emptyRecentRouteCellNib, forCellReuseIdentifier: "co.itamarbiton.TravelTest.EmptyRecentRouteCellIdentifier")
        let recentRouteCellNib = UINib(nibName: "RecentRouteCell", bundle: nil)
        self.recentsTableView.register(recentRouteCellNib, forCellReuseIdentifier: "co.itamarbiton.TravelTest.RecentRouteCellIdentifier")
        
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
    
    private func addRecentRoute(origStation: TrainStation, destStation: TrainStation, date: Date) {
        let recentRoute = RecentRoute(origStation: origStation, destStation: destStation, date: date)
        DataStore.shared.add(recentRoute: recentRoute)
    }
    
    private func refreshRecentsTableView() {
        self.recentRoutes = DataStore.shared.getRecentRoutes()
        self.recentsTableView.reloadData()
    }
    
    private func refreshFavouritesTableView() {
        self.favouriteRoutes = DataStore.shared.getFavouriteRoutes()
        self.favouritesTableView.reloadData()
    }
    
    private func fetchRoute() {
        guard let selectedDate = self.selectedDate,
            let origStation = self.origStation,
            let destStation = self.destStation
            else {
                return
        }
        
        let dateString = formatDateAsParameter(date: selectedDate)
        let parameters: Parameters = ["date": dateString, "destination": destStation.id, "origin": origStation.id, "hours": 0]
        
        self.isFetchActive = true
        
        AF.request("https://moblin.rail.co.il/rail/v01/schedulev2", method: .get, parameters: parameters).response { response in
            self.isFetchActive = false
            
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
                    
                    if let keywordsDict = RemoteConfigService.shared.additionalKeywords {
                        for station in stations {
                            station.keywords = keywordsDict[station.id]
                        }
                    }
                    
                    DataStore.shared.set(stations: stations)
                    self.stations = DataStore.shared.stations
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
        SearchStationVC.present(from: self, stations: self.stations, type: .origin) { station in
            self.origStation = station
        }
    }
    
    @IBAction private func didClickedSetDestinationButton(sender: UIButton) {
        SearchStationVC.present(from: self, stations: self.stations, type: .destination) { station in
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
    
    @IBAction private func didClickedAddFavouriteButton(sender: UIButton) {
        Analytics.logEvent(RPEventNames.createFavouriteButtonClicked, parameters: nil)
        FavouriteDetailsVC.present(from: self) {
            self.refreshFavouritesTableView()
        }
    }
    
    @IBAction private func didClickedSearchButton(sender: UIButton) {
        if origStation == nil {
            self.origStationContainerView.shake()
        }

        if destStation == nil {
            self.destStationContainerView.shake()
        }

        if let origStation = self.origStation, let destStation = self.destStation, self.selectedDate != nil, !self.isFetchActive {
            Analytics.logEvent(RPEventNames.searchButtonClicked, parameters: [RPEventParameters.isValid: true])
            
            self.addRecentRoute(origStation: origStation, destStation: destStation, date: Date())
            self.setSearchButton(loading: true)
            self.fetchRoute()
        } else {
            Analytics.logEvent(RPEventNames.searchButtonClicked, parameters: [RPEventParameters.isValid: false])
            return
        }
    }
    
    @IBAction func didClickedEditFavouritesButton(sender: UIButton) {
        let editFavouritesVC = EditFavouritesVC()
        
        self.navigationController?.pushViewController(editFavouritesVC, animated: true)
    }
    
    // MARK: Remote Config Methods
    
    private func configureRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        // set the defaults
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        // fetch config values
        remoteConfig.fetchAndActivate { (status, error) in
            switch status {
            case .successFetchedFromRemote:
                print("successfully fetched remote config values from remote!")
            case .successUsingPreFetchedData:
                print("successfully fetched remote config values from the cache!")
            case .error:
                if let error = error {
                    print("failed to get remote config values: \(error.localizedDescription)")
                }
            default:
                print("remote config unhandled status received")
                break
            }
        }
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
            tableView.deselectRow(at: indexPath, animated: true)

            if self.favouriteRoutes.count == 0 {
                FavouriteDetailsVC.present(from: self) {
                    self.refreshFavouritesTableView()
                }
            } else {
                let favouriteRoute = self.favouriteRoutes[indexPath.row]
                self.destStation = favouriteRoute.destStation
                self.origStation = favouriteRoute.origStation
            }
            
            
        case self.recentsTableView:
            tableView.deselectRow(at: indexPath, animated: true)

            if self.recentRoutes.isEmpty {
                SearchStationVC.present(from: self, stations: self.stations, type: .origin) { (station) in
                    self.origStation = station
                }
            } else {
                if let cell = tableView.cellForRow(at: indexPath) as? RecentRouteCell {
                    tableView.deselectRow(at: indexPath, animated: true)
                    cell.performNudgeAnimation()
                }

                let recentRoute = self.recentRoutes[(self.recentRoutes.count - 1) - indexPath.row]
                self.origStation = recentRoute.origStation
                self.destStation = recentRoute.destStation
            }
            
        default:
            break
        }
    }
}
