//
//  PemissionContainerVC.swift
//  RakevetPlus
//
//  Created by Itamar Biton on 24/11/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit

protocol PermissionInteractionControllerDataSource: class {
    func numberOfPermissionInteractionControllerForPermissionContainer(permissonContainerVC: PermissionContainerVC) -> Int
    func permissonContainer(permissionContainerVC: PermissionContainerVC, permissionInteractionControllerForIndex index: Int) -> PermissionInteractionController
}

class PermissionContainerVC: UIViewController {
    
    var dataSource: PermissionInteractionControllerDataSource?
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private var permissionInteractionControllers: [PermissionInteractionController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureScrollView()
    }
    
    func permissionInterfaceControllerDidFinish(permissionIC: PermissionInteractionController) {
        guard let index = self.children.firstIndex(of: permissionIC) else {
            return
        }
        
        if index == self.children.count - 1 {
            self.dismiss(animated: true, completion: nil)
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                self.scrollView.setContentOffset(CGPoint(x: CGFloat(index + 1) * self.scrollView.bounds.width, y: 0), animated: false)
            }, completion: nil)
        }
    }
    
    static func presentPermissionContainer(on presentingVC: UIViewController, dataSource: PermissionInteractionControllerDataSource) {
        let permissionContainerVC = PermissionContainerVC(nibName: "PermissionContainerVC", bundle: nil)
        
        permissionContainerVC.dataSource = dataSource
        presentingVC.present(permissionContainerVC, animated: true, completion: nil)
    }
    
    private func configureScrollView() {
        guard let dataSource = self.dataSource else {
            return
        }
        
        let containerView = UIView()
        
        self.scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraint it to the scroll view
        containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        
        let permissionControllersCount = dataSource.numberOfPermissionInteractionControllerForPermissionContainer(permissonContainerVC: self)
        
        var previousPIC: PermissionInteractionController?
        for i in 0..<permissionControllersCount {
            // get a permission interaction controller
            let permissionIC = dataSource.permissonContainer(permissionContainerVC: self, permissionInteractionControllerForIndex: i)
            
            // add the new permission interaction controller to the container view
            containerView.addSubview(permissionIC.view)
            self.addChild(permissionIC)
            permissionIC.parentPermissionContainerVC = self
            permissionIC.didMove(toParent: self)
            permissionIC.view.translatesAutoresizingMaskIntoConstraints = false
            
            // constraint it's height and width
            permissionIC.view.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
            permissionIC.view.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true
            
            // constraint to the container view
            permissionIC.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            permissionIC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            
            // constraint it's sides
            if let previousPIC = previousPIC {
                permissionIC.view.leadingAnchor.constraint(equalTo: previousPIC.view.trailingAnchor).isActive = true
            } else {
                permissionIC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            }
            
            // if it's the last one, tie it down back to the container view
            if i == permissionControllersCount - 1 {
                permissionIC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            }
            
            previousPIC = permissionIC
        }
    }
}
