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
    
    var stations = [TrainStation]()
    
    private var destStation: TrainStation?
    private var origStation: TrainStation?
    private var selectedDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        decodeStations()
        
        fetchRoute()
    }
    
    private func fetchRoute() {
        guard let selectedDate = self.selectedDate, let origStation = self.origStation, let destStation = self.destStation else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "he_IL")
        formatter.dateFormat = "dd/MM/yyyy"
        
        let dateString = formatter.string(from: selectedDate)
        
        let parameters: Parameters = ["date": dateString, "destination": destStation.id, "origin": origStation.id, "hours": 0]
        
        AF.request("https://moblin.rail.co.il/rail/v01/schedulev2", method: .get, parameters: parameters).response { response in
            if let data = try? response.result.get() {
                self.decode(data: data)
            }
        }
    }
    
    private func decode(data: Data) {
        let decoder = JSONDecoder()
        do {
            let routeResultService = try decoder.decode(RouteResultContainerService.self, from: data)
            let routeResult = RouteResult(service: routeResultService)
            
            let routeResultVC = RouteResultVC()
            routeResultVC.routeResult = routeResult
            self.present(routeResultVC, animated: true, completion: nil)
        } catch let error {
            print("failed to decode, \(error.localizedDescription)")
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
            self.origStationLabel.text = station.heName
        }
    }
    
    @IBAction private func didClickedSetDestinationButton(sender: UIButton) {
        SearchStationVC.present(from: self, stations: self.stations) { station in
            self.destStation = station
            self.destStationLabel.text = station.heName
        }
    }
    
    @IBAction private func didClickedSetTimeButton(sender: UIButton) {
        DatePickerVC.present(from: self) { (date) in
            self.selectedDate = date
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "he_IL")
            formatter.dateFormat = "EEEE, d MMMM, HH:mm"
            
            self.dateLabel.text = formatter.string(from: date)
            
            self.fetchRoute()
        }
    }
}
