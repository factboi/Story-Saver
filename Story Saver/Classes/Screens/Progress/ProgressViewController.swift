//
//  ProgressController.swift
//  Story Saver
//
//  Created by factboii on 12.02.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {

    @IBOutlet  weak var roundedView: UIView! {
        didSet {
            roundedView.layer.cornerRadius = 8
            roundedView.clipsToBounds = true
        }
    }
    var progress: CGFloat = 0 {
        didSet {
            downloadProgressLabel.text = "\(Int(progress*100))%"
            shapeLayer.strokeEnd = progress
        }
    }
    
    var didFinished: Bool = false {
        didSet {
            statusLabel.text = didFinished ? "Finished!" : "Hold On!"
        }
    }
    
    @IBOutlet private weak var downloadProgressLabel: UILabel! {
        didSet {
            downloadProgressLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    private let shapeLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    private let gradient = CAGradientLayer()
    
    fileprivate func setupLayers() {
        
        let circularPath = UIBezierPath(arcCenter: containerView.center,
        radius: containerView.bounds.width/2 - 25,
        startAngle: -.pi / 2,
        endAngle: CGFloat.pi * 3/2, clockwise: true).cgPath
        
        trackLayer.path = circularPath
        trackLayer.strokeColor = #colorLiteral(red: 0.1215504929, green: 0.1215790585, blue: 0.1215486899, alpha: 1).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        trackLayer.lineWidth = 10
        trackLayer.strokeEnd = 1
        containerView.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0
        containerView.layer.addSublayer(shapeLayer)
        
        gradient.frame = containerView.bounds
        gradient.colors = [
            UIColor(red:0.51, green:0.23, blue:0.71, alpha:1.0).cgColor,
            UIColor(red:0.99, green:0.11, blue:0.11, alpha:1.0).cgColor,
            UIColor(red:0.99, green:0.69, blue:0.27, alpha:1.0).cgColor
            
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.mask = shapeLayer
        containerView.layer.addSublayer(gradient)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.didFinished = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayers()
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
