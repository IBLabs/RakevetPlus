//
//  DatePickerVC.swift
//  TravelTest
//
//  Created by Itamar Biton on 17/06/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit

class DatePickerVC: UIViewController {
    
    @IBOutlet weak private var datePicker: UIDatePicker!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var overlayButton: UIButton!
    @IBOutlet weak private var doneButton: UIButton!
    
    var completion: ((Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForEnterAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performEnterAnimation()
    }
    
    private func initializeStrings() {
        self.doneButton.setTitle(NSLocalizedString("אישור", comment: "אישור."), for: .normal)
    }
    
    @IBAction private func didClickedOverlayButton(sender: UIButton) {
        self.performExitAnimation { succeeded in
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction private func didClickedConfirmButton(sender: UIButton) {
        completion?(self.datePicker.date)
        performExitAnimation { (succeeded) in
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: Animation Methods
    
    private func prepareForEnterAnimation() {
        let screenHeight = UIScreen.main.bounds.height
        
        self.overlayButton.alpha = 0
        self.containerView.transform = .init(translationX: 0, y: screenHeight)
    }
    
    private func performEnterAnimation(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            self.overlayButton.alpha = 1
            self.containerView.transform = .identity
        }, completion: completion)
    }
    
    private func performExitAnimation(completion: ((Bool) -> Void)? = nil) {
        let screenHeight = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            self.overlayButton.alpha = 0
            self.containerView.transform = .init(translationX: 0, y: screenHeight)
        }, completion: completion)
    }
    
    // MARK: - Presentation Methods
    
    static func present(from presentingVC: UIViewController, completion: @escaping ((Date) -> Void)) {
        let datePickerVC = DatePickerVC(nibName: "DatePickerVC", bundle: nil)
        
        datePickerVC.completion = completion
        datePickerVC.modalPresentationStyle = .overCurrentContext
        
        presentingVC.present(datePickerVC, animated: false, completion: nil)
    }
}
