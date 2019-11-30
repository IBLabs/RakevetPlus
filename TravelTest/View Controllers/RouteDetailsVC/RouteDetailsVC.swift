//
//  RouteDetailsVC.swift
//  TravelTest
//
//  Created by Itamar Biton on 22/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit
import SwiftDate

class RouteDetailsVC: UIViewController {
    
    var routeTrains = [RouteTrain]()

    @IBOutlet weak private var routeTableView: UITableView!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var overlayButton: UIButton!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var origStationLabel: UILabel!
    @IBOutlet weak private var destStationLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    
    @IBOutlet weak private var remindButtonContainer: UIView!
    @IBOutlet weak private var remindButtonLabel: UILabel!
    @IBOutlet weak private var remindButton: UIButton!
    
    private var routeDetails = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setRemimdButton(visible: false, animated: false)
        
        self.initializeRouteDetails()
        self.configureRouteDetails()
        self.configureTableView()
        self.configureScrollView()
        self.configureContainerView()
        self.configureShadows()
        
        self.prepareForEnterAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.performEnterAnimation { finished in
            self.showRemindButtonIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.updateInsets()
        self.updateRoundedCorners()
        self.updateShadows()
    }
    
    private func initializeRouteDetails() {
        var routeDetails = [Any]()
        
        for (index, train) in self.routeTrains.enumerated() {
            routeDetails.append(train.origRouteStation)
            if let stopStations = train.stopStations { routeDetails.append(contentsOf: stopStations) }
            routeDetails.append(train.destRouteStation)
            
            if index + 1 < self.routeTrains.count {
                let nextTrain = self.routeTrains[index + 1]
                let trainSwitch = TrainSwitch(arrivalTime: train.arrivalTime, departureTime: nextTrain.departureTime, arrivalPlatform: train.destPlatform, departurePlatform: nextTrain.origPlatform)
                routeDetails.append(trainSwitch)
            }
        }
        
        self.routeDetails = routeDetails
    }
    
    private func configureRouteDetails() {
        self.origStationLabel.text = self.routeTrains.first?.origStation.heName ?? "--"
        self.destStationLabel.text = self.routeTrains.last?.destStation.heName ?? "--"
        self.dateLabel.text = self.routeTrains.first?.departureTime.toFormat("EEEE, d MMMM, HH:mm")
    }
    
    private func configureContainerView() {
        self.containerView.layer.cornerRadius = 16
        self.containerView.layer.masksToBounds = true
    }
    
    private func configureScrollView() {
        self.scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    }
    
    private func configureTableView() {
        self.routeTableView.dataSource = self
        self.routeTableView.delegate = self
        
        let routeDetailCellNib = UINib(nibName: "RouteDetailCell", bundle: nil)
        self.routeTableView.register(routeDetailCellNib, forCellReuseIdentifier: detailCellIdentifier)
        
        let trainSwitchCellNib = UINib(nibName: "TrainSwitchCell", bundle: nil)
        self.routeTableView.register(trainSwitchCellNib, forCellReuseIdentifier: trainSwitchCellIdentifier)
    }
    
    private func configureShadows() {
        self.remindButtonContainer.layer.shadowColor = UIColor.black.cgColor
        self.remindButtonContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.remindButtonContainer.layer.shadowRadius = 10
        self.remindButtonContainer.layer.shadowOpacity = 0.2
    }
    
    private func updateInsets() {
        let bottomInset = self.view.frame.maxY - self.remindButtonContainer.frame.minY
        self.scrollView.contentInset = UIEdgeInsets(top: self.scrollView.adjustedContentInset.top, left: 0, bottom: bottomInset, right: 0)
    }
    
    private func updateShadows() {
        self.remindButtonContainer.layer.shadowPath = UIBezierPath(roundedRect: self.remindButtonContainer.bounds, cornerRadius: self.remindButtonContainer.bounds.height / 2).cgPath
    }
    
    private func updateRoundedCorners() {
        self.remindButtonContainer.layer.cornerRadius = self.remindButtonContainer.bounds.height / 2
    }
    
    // MARK: Utility Methods
    
    private func showRemindButtonIfNeeded() {
        let isTrainInPast = self.routeTrains.first!.departureTime.isInPast
        let isReminderRelevant =  self.routeTrains.first!.departureTime.timeIntervalSinceNow > 31.minutes.timeInterval
        
        if !isTrainInPast && isReminderRelevant {
            self.setRemimdButton(visible: true, animated: true)
        }
    }
    
    // MARK: User Interaction Methods
    
    @IBAction private func didClickRemindButton(sender: UIButton) {
        UserNotificationsService.shared.hasNotificationsPermission { (authorized) in
            if authorized {
                self.setRemimdButton(visible: false, animated: true)
                
                let alertController = UIAlertController(title: NSLocalizedString("בחר/י זמן תזכורת", comment: "בחר/י זמן תזכורת"), message: NSLocalizedString("כמה זמן לפני צאת הרכבת תרצה/י לקבל תזכורת?", comment: "כמה זמן לפני צאת הרכבת תרצה/י לקבל תזכורת?"), preferredStyle: .actionSheet)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("15 דקות", comment: "15 דקות"), style: .default, handler: { action in LocalNotificationsService.shared.addTrainReminder(targetDate: self.routeTrains.first!.departureTime, minutesBefore: 15) }))
                alertController.addAction(UIAlertAction(title: NSLocalizedString("30 דקות", comment: "30 דקות"), style: .default, handler: { action in LocalNotificationsService.shared.addTrainReminder(targetDate: self.routeTrains.first!.departureTime, minutesBefore: 30) }))
                alertController.addAction(UIAlertAction(title: NSLocalizedString("ביטול", comment: "ביטול"), style: .cancel, handler: { action in self.setRemimdButton(visible: true, animated: true) }))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: NSLocalizedString("שימוש בהתראות", comment: "שימוש בהתראות"), message: NSLocalizedString("טרם אישרת שימוש בהתראות, רכבת+ צריכה אישור שימוש בהתראות כדי להזכיר לך מתי לצאת, אפשר שימוש בהתראות דרך הגדרות המכשיר ונסה שנית", comment: "טרם אישרת שימוש בהתראות, רכבת+ צריכה אישור שימוש בהתראות כדי להזכיר לך מתי לצאת, אפשר שימוש בהתראות דרך הגדרות המכשיר ונסה שנית"), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("אישור", comment: "אישור"), style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction private func didClickedCloseButton(sender: UIButton) {
        self.performExitAnimation { succeeded in
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: Animation Methods
    
    private func setRemimdButton(visible: Bool, animated: Bool) {
        let screenBounds = UIScreen.main.bounds
        let targetTransform: CGAffineTransform = visible ? .identity : .init(translationX: 0, y: screenBounds.height)
        
        if animated {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                self.remindButtonContainer.transform = targetTransform
            }, completion: nil)
        } else {
            self.remindButtonContainer.transform = targetTransform
        }
    }
    
    private func prepareForEnterAnimation() {
        self.overlayButton.alpha = 0
        
        let screenHeight = UIScreen.main.bounds.height
        self.scrollView.transform = .init(translationX: 0, y: screenHeight)
    }
    
    private func performEnterAnimation(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            self.overlayButton.alpha = 1
            self.scrollView.transform = .identity
        }, completion: completion)
    }
    
    private func performExitAnimation(completion: ((Bool) -> Void)? = nil) {
        let screenHeight = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            self.overlayButton.alpha = 0
            self.scrollView.transform = .init(translationX: 0, y: screenHeight)
        }, completion: completion)
    }
    
    // MARK: Presentation Methods
    
    static func present(from presentingVC: UIViewController, routeTrains: [RouteTrain]) {
        let routeDetailsVC = RouteDetailsVC()
        routeDetailsVC.routeTrains = routeTrains
        routeDetailsVC.modalPresentationStyle = .overCurrentContext
        
        presentingVC.present(routeDetailsVC, animated: false, completion: nil)
    }
}

struct TrainSwitch {
    let arrivalTime: Date
    let departureTime: Date
    let arrivalPlatform: String
    let departurePlatform: String
    
    var waitingTime: TimeInterval {
        return self.departureTime.timeIntervalSince(self.arrivalTime)
    }
}

extension RouteDetailsVC: UITableViewDataSource {
    var detailCellIdentifier: String { return "co.itamarbiton.TravelTest.DetailCellIdentifier" }
    var trainSwitchCellIdentifier: String { return "co.itamarbiton.TravelTest.TrainSwitchCellIdentifier" }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        let object = self.routeDetails[indexPath.row]
        if let station = object as? RouteStation {
            let detailCell = tableView.dequeueReusableCell(withIdentifier: detailCellIdentifier) as! RouteDetailCell
            detailCell.configure(with: station, type: typeForCell(atIndexPath: indexPath))
            cell = detailCell
        } else if let trainSwitch = object as? TrainSwitch {
            let trainSwitchCell = tableView.dequeueReusableCell(withIdentifier: trainSwitchCellIdentifier) as! TrainSwitchCell
            trainSwitchCell.configure(with: trainSwitch)
            cell = trainSwitchCell
        }
        
        return cell
    }
    
    private func typeForCell(atIndexPath indexPath: IndexPath) -> RouteDetailCell.DetailType {
        if indexPath.row == 0 {
            return .initial
        } else if indexPath.row == self.routeDetails.count - 1 {
            return .last
        }
        
        let nextItem = self.routeDetails[indexPath.row + 1]
        let previousItem = self.routeDetails[indexPath.row - 1]
        
        if previousItem is TrainSwitch {
            return .initial
        } else if nextItem is TrainSwitch {
            return .last
        }
        
        return .middle
    }
}

extension RouteDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let object = self.routeDetails[indexPath.row]
        
        if object is RouteStation {
            return 72
        } else if object is TrainSwitch {
            return 149
        }
        
        return 0
    }
}
