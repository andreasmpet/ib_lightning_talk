//
//  IBDudeAnimatedDudeModel.swift
//  IBLightningTalk
//
//  Created by Andreas on 02/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit

typealias IBDudeAnimatedDudeModelAnimationBlock = (_ phase: Float) -> IBDudeModel

// Could definitely have been abstracted in a way that didn't need to couple it to IBDudeModel. This is quick and dirty

class IBDudeAnimatedDudeModel: IBDudeModel {
    var phase: Float = 0 {
        didSet {
            self.update(fromPhase: phase)
        }
    }
    
    private let animationBlock: IBDudeAnimatedDudeModelAnimationBlock
    private var currentFrame: IBDudeModel!
    
    init(animationBlock: @escaping IBDudeAnimatedDudeModelAnimationBlock) {
        self.animationBlock = animationBlock
        defer {
            self.update(fromPhase: self.phase)
        }
    }
    
    // MARK: IBDudeModel

    var mouthTransform: CGAffineTransform {
        return self.currentFrame.mouthTransform
    }

    var leftEyeTransform: CGAffineTransform {
        return self.currentFrame.leftEyeTransform
    }

    var rightEyeTransform: CGAffineTransform {
        return self.currentFrame.rightEyeTransform
    }

    var handIconUp: UIImage? {
        return self.currentFrame.handIconUp
    }

    var handIconDown: UIImage? {
        return self.currentFrame.handIconDown
    }

    var handIconLeft: UIImage? {
        return self.currentFrame.handIconLeft
    }

    var handIconRight: UIImage? {
        return self.currentFrame.handIconRight
    }

    // MARK: Updates
    
    private func update(fromPhase phase: Float) {
        self.currentFrame = self.animationBlock(phase)
    }
}
