//
//  HuggingViewController.swift
//  IBLightningTalk
//
//  Created by Andreas on 03/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit

class HuggingViewController: UIViewController {
    
    // NOTE: THIS CLASS DOES NOT FOLLOW MANY OF THE BEST PRACTICES MENTIONED IN MY TALK
    @IBOutlet private weak var leftDisplayLabel: UILabel!
    @IBOutlet private weak var rightDisplayLabel: UILabel!
    
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var rightLabel: UILabel!
    
    @IBOutlet private weak var decreaseLeftButton: UIButton!
    @IBOutlet private weak var increaseLeftButton: UIButton!
    
    @IBOutlet private weak var decreaseRightButton: UIButton!
    @IBOutlet private weak var increaseRightButton: UIButton!
    
    
    @IBOutlet private weak var leftDude: IBDudeView!
    @IBOutlet private weak var rightDude: IBDudeView!
    
    private var leftDudeAnimator: IBDudeAnimator!
    private var rightDudeAnimator: IBDudeAnimator!
    
    private static let adjustmentSteps = 1
    
    private var rightHuggingPriority: Float = 0 {
        didSet {
            self.rightLabel.setContentHuggingPriority(self.rightHuggingPriority, for: .horizontal)
            self.rightDisplayLabel.text = "\(self.rightHuggingPriority)"
        }
    }
    
    private var leftHuggingPriority: Float = 0 {
        didSet {
            self.leftLabel.setContentHuggingPriority(self.leftHuggingPriority, for: .horizontal)
            self.leftDisplayLabel.text = "\(self.leftHuggingPriority)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftHuggingPriority = self.leftLabel.contentHuggingPriority(for: .horizontal)
        self.rightHuggingPriority = self.rightLabel.contentHuggingPriority(for: .horizontal)
        
        
        self.leftDudeAnimator = IBDudeAnimator(view: self.leftDude,
                                           animation: IBHuggingAnimation(referenceView: self.leftLabel.superview!),
                                           idleFrameUpdateInterval: 0.1)
        
        self.leftDudeAnimator.start()
        
        self.rightDudeAnimator = IBDudeAnimator(view: self.rightDude,
                                               animation: IBHuggingAnimation(referenceView: self.rightLabel.superview!),
                                               idleFrameUpdateInterval: 0.1)
        
        self.rightDudeAnimator.start()
    }
    
    @IBAction func pressed(button: UIButton) {
        let adjustment = (button == decreaseLeftButton || button == decreaseRightButton) ? -type(of:self).adjustmentSteps : type(of:self).adjustmentSteps
        
        let isLeftButton = (button == decreaseLeftButton || button == increaseLeftButton)
        guard let label = isLeftButton ? leftLabel : rightLabel else {
            return
        }
        
        let oldPriority = label.contentHuggingPriority(for: .horizontal)
        let newPriority = oldPriority + Float(adjustment)
        
        if (isLeftButton) {
            self.leftHuggingPriority = newPriority
        } else {
            self.rightHuggingPriority = newPriority
        }
    }
}
