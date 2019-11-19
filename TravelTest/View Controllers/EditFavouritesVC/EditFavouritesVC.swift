//
//  EditFavouritesVC.swift
//  TravelTest
//
//  Created by Itamar Biton on 26/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit

class EditFavouritesVC: UIViewController {
    
    private var favouriteRoutes = DataStore.shared.getFavouriteRoutes()
    
    @IBOutlet weak private var favouritesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        let cellNib = UINib(nibName: "FavouriteRouteCell", bundle: nil)
        self.favouritesTableView.register(cellNib, forCellReuseIdentifier: favouriteCellIdentifier)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func refreshTableView() {
        self.favouriteRoutes = DataStore.shared.getFavouriteRoutes()
        self.favouritesTableView.reloadData()
    }
    
    @IBAction private func didClickedBackButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension EditFavouritesVC: UITableViewDataSource {
    var favouriteCellIdentifier: String { return "co.itamarbiton.TravelTest.FavouriteRouteCellIdentifier" }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favouriteRoutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favouriteCellIdentifier, for: indexPath)
        
        if let cell = cell as? FavouriteRouteCell {
            let favouriteRoute = self.favouriteRoutes[indexPath.row]
            cell.configure(with: favouriteRoute)
        }
        
        return cell
    }
}

extension EditFavouritesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedRoute = self.favouriteRoutes[indexPath.row]
        FavouriteDetailsVC.present(from: self, favouriteRoute: selectedRoute) {
            self.refreshTableView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
