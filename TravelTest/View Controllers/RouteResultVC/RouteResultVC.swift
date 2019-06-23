//
//  RouteResultVC.swift
//  TravelTest
//
//  Created by Itamar Biton on 20/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit

class RouteResultVC: UIViewController {
    
    @IBOutlet weak private var directRoutesTableView: UITableView!
    @IBOutlet weak private var indirectRoutesTableView: UITableView!
    
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
        
        configureTableViews()
        
        if routeResult != nil {
            self.indirectRoutesTableView.reloadData()
            self.directRoutesTableView.reloadData()
        }
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
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
}
