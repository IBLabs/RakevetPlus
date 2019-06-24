//
//  RouteResultVC.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit

class RouteResultVC: UIViewController {
    
    var origStation: TrainStation?
    var destStation: TrainStation?
    var date: Date?
    
    @IBOutlet weak private var directRoutesTableView: UITableView!
    @IBOutlet weak private var indirectRoutesTableView: UITableView!
    @IBOutlet weak private var origStationLabel: UILabel!
    @IBOutlet weak private var destStationLabel: UILabel!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var dateLabel: UILabel!
    
    @IBOutlet weak var routeSliderView: UIView!
    @IBOutlet var routeButtons: [UIButton]!
    
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
        

        
        configureTabButtons()
        configureTableViews()
        
        if self.routeResult != nil {
            self.indirectRoutesTableView.reloadData()
            self.directRoutesTableView.reloadData()
        }
        
        if let origStation = self.origStation, let destStation = self.destStation, let date = self.date {
            self.origStationLabel.text = origStation.heName
            self.destStationLabel.text = destStation.heName
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "he_IL")
            formatter.dateFormat = "EEEE, d MMMM, HH:mm"
            
            self.dateLabel.text = formatter.string(from: date)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func configureTabButtons() {
        self.routeButtons[0].setTitle("\(self.directRoutes.count) ישיר", for: .normal)
        self.routeButtons[1].setTitle("\(self.indirectRoutes.count) עם החלפות", for: .normal)
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
        let buttonIndex = self.routeButtons.firstIndex { $0 == sender }
        guard let index = buttonIndex else {
            return
        }
        
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
        return 64
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
