//
//  ViewController.swift
//  IBLightningTalk
//
//  Created by Andreas on 01/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit

private extension Selector {
    static let didPan = #selector(CompressingViewController.didPan(recognizer:))
}

class CompressingViewController: UIViewController {
    
    @IBOutlet private weak var dudeView: IBDudeView!
    @IBOutlet private weak var compressionResistanceLabel: UILabel!
    @IBOutlet private weak var rightWall: UIView!
    @IBOutlet private weak var leftWall: UIView!
    @IBOutlet private weak var rightWallTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var leftWallLeadingConstraint: NSLayoutConstraint!
    
    private var rightPanRecognizer: UIPanGestureRecognizer!
    private var leftPanRecognizer: UIPanGestureRecognizer!
    
    private var dudeAnimator: IBDudeAnimator!
    
    private var compressionResistance: Float! {
        didSet {
            self.update(fromCompressionResistance: self.compressionResistance)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWalls()
        self.dudeAnimator = IBDudeAnimator(view: self.dudeView,
                                           animation: IBCompressionAnimation(referenceView: self.dudeView),
                                           idleFrameUpdateInterval: 0.1)
        
        self.dudeAnimator.start()
        self.compressionResistance = self.dudeView.horizontalCompressionResistance
    }
    
    private func setupWalls() {
        self.leftPanRecognizer = UIPanGestureRecognizer(target: self, action:.didPan)
        self.leftWall.addGestureRecognizer(self.leftPanRecognizer)
        
        self.rightPanRecognizer = UIPanGestureRecognizer(target: self, action:.didPan)
        self.rightWall.addGestureRecognizer(self.rightPanRecognizer)
    }
    
    
    // MARK: Updates
    
    private func update(fromCompressionResistance resistance: Float) {
        self.dudeView.horizontalCompressionResistance = max(0, min(1000, resistance))
        self.compressionResistanceLabel.text = "\(resistance)"
    }
    
    // MARK: Helpers
    
    @objc fileprivate func didPan(recognizer: UIPanGestureRecognizer) {
        if let constraint = recognizer == self.leftPanRecognizer ? self.leftWallLeadingConstraint : self.rightWallTrailingConstraint {
            let translation = recognizer.translation(in: self.view)
            constraint.constant = constraint.constant + (recognizer == self.leftPanRecognizer ? translation.x : -translation.x)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @IBAction private func decreaseCompressionResistance() {
        self.increaseCompressionResistance(amount: -1)
    }
    
    @IBAction private func increaseCompressionResistance() {
        self.increaseCompressionResistance(amount: 1)
    }
    
    private func increaseCompressionResistance(amount: Float) {
        self.compressionResistance = self.compressionResistance + amount
    }
}

