//
//  WhatsNewVC.swift
//  RakevetPlus
//
//  Created by Itamar Biton on 27/11/2019.
//  Copyright © 2019 Itamar Biton. All rights reserved.
//

import UIKit

class WhatsNewVC: UIViewController {
    
    @IBOutlet weak private var overlayButton: UIButton!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var closeButtonContainer: UIView!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeHeader()
        self.prepareForEnterAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.updateRoundedCorners()
        self.updateInsets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.performEnterAnimation()
    }
    
    // MARK: User Interaction Methods
    
    @IBAction private func didClickCloseButton(sender: UIButton) {
        let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        UserDefaults.standard.set(versionString, forKey: "lastShownVersionString")
        
        self.performExitAnimation() { finished in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: Presentation Methods
    
    static func present(from presentingVC: UIViewController) {
        let whatsNewVC = WhatsNewVC(nibName: "WhatsNewVC", bundle: nil)
        whatsNewVC.modalPresentationStyle = .overCurrentContext
        
        presentingVC.present(whatsNewVC, animated: false, completion: nil)
    }
    
    // MARK: Initialization Methods
    
    private func initializeHeader() {
        self.titleLabel.text = NSLocalizedString("מה חדש", comment: "מה חדש")
        
        let versionString = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "--"
        self.subtitleLabel.text = String(format: "גרסה %@", versionString)
    }
    
    private func updateRoundedCorners() {
        self.closeButtonContainer.layer.cornerRadius = self.closeButtonContainer.bounds.height / 2
        
        let cardPath = UIBezierPath(roundedRect: self.containerView.bounds, cornerRadius: 12)
        let maskLayer = CAShapeLayer()
        maskLayer.path = cardPath.cgPath
        self.containerView.layer.mask = maskLayer
    }
    
    private func updateInsets() {
        let extraPadding: CGFloat = 128
        let bottomInset = self.scrollView.frame.maxY - self.closeButtonContainer.frame.minY + extraPadding
        self.scrollView.contentInset = UIEdgeInsets(top: self.scrollView.adjustedContentInset.top, left: 0, bottom: bottomInset, right: 0)
    }
    
    // MARK: Animation Methods
    
    private func prepareForEnterAnimation() {
        let screenBounds = UIScreen.main.bounds
        
        self.overlayButton.alpha = 0
        self.containerView.transform = .init(translationX: 0, y: screenBounds.height)
    }
    
    private func performEnterAnimation(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.overlayButton.alpha = 1
            self.containerView.transform = .identity
        }, completion: completion)
    }
    
    private func performExitAnimation(completion: ((Bool) -> Void)? = nil) {
        let screenBounds = UIScreen.main.bounds
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            self.overlayButton.alpha = 0
            self.containerView.transform = .init(translationX: 0, y: screenBounds.height)
        }, completion: completion)
    }
    
    static func shouldDisplayWhatNew() -> Bool {
        let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let lastShownVersionString = UserDefaults.standard.string(forKey: "lastShownVersionString")
        
        return (versionString != lastShownVersionString)
    }
}
