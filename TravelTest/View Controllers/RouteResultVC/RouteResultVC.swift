//
//  RouteResultVC.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit
import SwiftDate

class RouteResultVC: UIViewController {
    
    var origStation: TrainStation?
    var destStation: TrainStation?
    var date: Date?
    
    @IBOutlet weak private var directRoutesTableView: UITableView!
    @IBOutlet weak private var indirectRoutesTableView: UITableView!
    @IBOutlet weak private var origStationLabel: UILabel!
    @IBOutlet weak private var destStationLabel: UILabel!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var backButton: UIButton!
    
    @IBOutlet weak var routeSliderView: UIView!
    @IBOutlet var routeButtons: [UIButton]!
    
    @IBOutlet weak private var directRoutesButton: UIButton!
    @IBOutlet weak private var indirectRoutesButton: UIButton!
        
    var routeResult: RouteResult? {
        didSet {
            guard let routeResult = self.routeResult else {
                return
            }
            
            if let indirectRoutes = routeResult.indirectRoutes { self.indirectRoutes = indirectRoutes }
            if let directRoutes = routeResult.directRoutes { self.directRoutes = directRoutes }
        }
    }
    
    private var directRoutes = [DirectRoute]()
    private var indirectRoutes = [IndirectRoute]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
       
        configureStrings()
        configureTabButtons()
        configureTableViews()
        
        if self.routeResult != nil {
            self.indirectRoutesTableView.reloadData()
            self.directRoutesTableView.reloadData()
        }
        
        if let origStation = self.origStation, let destStation = self.destStation, let date = self.date {
            self.origStationLabel.text = origStation.name
            self.destStationLabel.text = destStation.name
            
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateFormat = "EEEE, d MMMM, HH:mm"
            
            self.dateLabel.text = formatter.string(from: date)
        }
        
        if UIView.userInterfaceLayoutDirection(for: self.scrollView.semanticContentAttribute) == .rightToLeft {
            self.scrollView.transform = .init(rotationAngle: .pi)
            self.contentView.transform = .init(rotationAngle: .pi)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var activeDirectRouteIndex = -1
        for (index, route) in directRoutes.enumerated() {
            if route.routeTrain.departureTime.isBeforeDate(self.date!, granularity: .minute) {
                continue
            } else {
                activeDirectRouteIndex = index
                break
            }
        }
        
        if activeDirectRouteIndex != -1 {
            self.directRoutesTableView.scrollToRow(at: IndexPath(row: activeDirectRouteIndex, section: 0), at: .top, animated: true)
        }
        
        var activeIndirectRouteIndex = -1
        for (index, route) in indirectRoutes.enumerated() {
            
            if route.routeTrains.first?.departureTime.isBeforeDate(self.date!, granularity: .minute) ?? false {
                continue
            } else {
                activeIndirectRouteIndex = index
                break
            }
        }
        
        if activeIndirectRouteIndex != -1 {
            self.indirectRoutesTableView.scrollToRow(at: IndexPath(row: activeIndirectRouteIndex, section: 0), at: .top, animated: true)
        }
        
        // if there's no direct routes, move straight to the exchange tab
        if self.directRoutes.count == 0 {
            self.moveToTab(atIndex: 1)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func configureStrings() {
        self.backButton.setTitle(NSLocalizedString("חזור", comment: "חזור"), for: .normal)
    }
    
    private func configureTabButtons() {
        self.routeButtons[0].setTitle(String(format: NSLocalizedString("%d ישיר", comment: "%d ישיר"), self.directRoutes.count), for: .normal)
        self.routeButtons[1].setTitle(String(format: NSLocalizedString("%d עם החלפות", comment: "%d עם החלפות"), self.indirectRoutes.count), for: .normal)
    }
    
    private func configureTableViews() {
        self.indirectRoutesTableView.dataSource = self
        self.indirectRoutesTableView.delegate = self
        
        let indirectCellNib = UINib(nibName: "IndirectRouteCell", bundle: nil)
        self.indirectRoutesTableView.register(indirectCellNib, forCellReuseIdentifier: indirectRouteCellIdentifier)
        
        self.directRoutesTableView.dataSource = self
        self.directRoutesTableView.delegate = self
        
        let cellNib = UINib(nibName: "DirectRouteCell", bundle: nil)
        self.directRoutesTableView.register(cellNib, forCellReuseIdentifier: directRouteCellIdentifier)
    }
    
    // MARK: User Interaction Methods
    
    @IBAction private func didClickedCloseButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didClickedRouteButton(sender: UIButton) {
        var buttonIndex = -1
        switch sender {
        case self.directRoutesButton:
            buttonIndex = 0
            
        case self.indirectRoutesButton:
            buttonIndex = 1
            
        default:
            return
        }
        
        guard buttonIndex != -1 else {
            return
        }

        self.moveToTab(atIndex: buttonIndex)
    }

    private func moveToTab(atIndex index: Int) {
        let sender = self.routeButtons[index]

        self.routeSliderView.removeAllConstraints()
        self.routeSliderView.leadingAnchor.constraint(equalTo: sender.leadingAnchor, constant: -12).isActive = true
        self.routeSliderView.topAnchor.constraint(equalTo: sender.topAnchor).isActive = true
        self.routeSliderView.trailingAnchor.constraint(equalTo: sender.trailingAnchor, constant: 12).isActive = true
        self.routeSliderView.bottomAnchor.constraint(equalTo: sender.bottomAnchor).isActive = true

        let targetContentOffset: CGFloat = CGFloat(index) * self.scrollView.bounds.width

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.scrollView.setContentOffset(CGPoint(x: targetContentOffset, y: 0), animated: false)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: nil)

        for button in self.routeButtons {
            let textColor: UIColor = button == sender ? .white : .lightGray
            button.setTitleColor(textColor, for: .normal)
        }
    }
}

// MARK: UITableView Data Source Methods

extension RouteResultVC: UITableViewDataSource {
    var directRouteCellIdentifier: String { return "co.itamarbiton.TravelTest.DirectRouteCellIdentifier" }
    var indirectRouteCellIdentifier: String { return "co.itamarbiton.TravelTest.IndirectRouteCellIdentifier" }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.indirectRoutesTableView:
            return self.indirectRoutes.count
            
        case self.directRoutesTableView:
            return self.directRoutes.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch tableView {
        case self.directRoutesTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: directRouteCellIdentifier, for: indexPath)
            if let cell = cell as? DirectRouteCell {
                let route = self.directRoutes[indexPath.row]
                cell.configure(with: route)
            }
        case self.indirectRoutesTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: indirectRouteCellIdentifier, for: indexPath)
            if let cell = cell as? IndirectRouteCell {
                let route = self.indirectRoutes[indexPath.row]
                cell.configure(with: route)
            }
            
        default:
            break
        }
        
        return cell
    }
}

extension RouteResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var routeTrains: [RouteTrain]!
        
        switch tableView {
        case self.directRoutesTableView:
            let train = self.directRoutes[indexPath.row].routeTrain
            routeTrains = [train]
            
        case self.indirectRoutesTableView:
            let trains = self.indirectRoutes[indexPath.row].routeTrains
            routeTrains = trains
            
        default:
            break
        }
        
        RouteDetailsVC.present(from: self, routeTrains: routeTrains)
    }
}
