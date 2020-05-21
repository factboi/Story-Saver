//
//  AlertController.swift
//  Story Saver
//
//  Created by factboii on 20.02.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit

enum State {
    case success
    case accessDenied
    case unknown
}

class AlertViewController: UIViewController {

    var state: State?
    
    @IBOutlet var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 12
        }
    }
    @IBOutlet var emojiStatusLabel: UILabel!
    @IBOutlet var statusTitleLabel: UILabel! {
        didSet {
            statusTitleLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet var statusMessageLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var settingsButton: UIButton! {
        didSet {
            settingsButton.layer.cornerRadius = 8
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        switch state {
        case .accessDenied:
            emojiStatusLabel.text = "😞"
            statusTitleLabel.text = "Access to Photos denied"
            statusMessageLabel.text = "App requires access to the photo library to save photo and video. You can allow access in settings and try again."
            cancelButton.setTitle("Cancel", for: UIControl.State.normal)
            settingsButton.isHidden = false
        case .success:
            emojiStatusLabel.text = "🥳"
            statusTitleLabel.text = "Success!"
            statusMessageLabel.text = "Story is in the photo gallery now"
            settingsButton.isHidden = true
            cancelButton.setTitle("OK", for: UIControl.State.normal)
        case .unknown:
            emojiStatusLabel.text = "😞"
            statusTitleLabel.text = "Error"
            statusMessageLabel.text = "An error occured. Please, try again"
            settingsButton.isHidden = true
            cancelButton.setTitle("OK", for: UIControl.State.normal)
        case .none:
            break
        }
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonClicked(_ sender: UIButton) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
