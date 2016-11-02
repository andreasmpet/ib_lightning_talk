//
//  IBDudeModel.swift
//  IBLightningTalk
//
//  Created by Andreas on 01/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit

protocol IBDudeModel {
    var mouthTransform: CGAffineTransform { get }
    var leftEyeTransform: CGAffineTransform { get }
    var rightEyeTransform: CGAffineTransform { get }
    var handIconUp: UIImage? { get }
    var handIconDown: UIImage? { get }
    var handIconLeft: UIImage? { get }
    var handIconRight: UIImage? { get }
}

class IBDudeDefaultModel: IBDudeModel {
    
    typealias Phase = Float
    typealias SmileWidth = Float

    enum HandPosition: String {
        case up = "up"
        case down = "down"
        case left = "left"
        case right = "right"
    }
    
    enum HandState {
        case resisting(HandPosition)
        case hugging(HandPosition)
        
        var icon: UIImage? {
            var name: String = "hand_"
            switch self {
            case .resisting(let handPosition):
                name.append("resisting_\(handPosition)")
                break
            case .hugging(let handPosition):
                name.append("hugging_\(handPosition)")
                break
            }
            
            return UIImage(named: name)
        }
    }
    
    enum MouthState {
        static let frownVibrateFactor: Float = 0.1
        static let speed: Float = 20
        
        case smile(SmileWidth)
        case frown(Phase)
        
        var rotationAngle: Float {
            switch(self) {
            case .smile(_):
                return Float.pi
            case .frown(let phase):
                return sin(phase * type(of:self).speed) * type(of:self).frownVibrateFactor
            }
        }
        
        var scale: CGPoint {
            switch(self) {
            case .smile(let smileWidth):
                return CGPoint(x: CGFloat(smileWidth), y: 1)
            default:
                return CGPoint(x: 1, y: 1)
            }
        }
    }
    
    enum Eye {
        case left
        case right
    }
    
    enum EyeState {
        static let eyeOffsetFactor: Float = 0.1
        static let speed: Float = 3
        static let eyeScaleFactor: Float = 0.1
        
        case squint(Eye, Phase)
        case open(Eye, Phase)
        
        var rotationAngle: Float {
            switch(self) {
            case .open(let eye, _):
                return (Float.pi / 6) * (eye == .left ? 1 : -1)
            case .squint(_):
                return 0
            }
        }
        
        var scale: Float {
            switch(self) {
            case .squint(let eye, let phase):
                let phaseOffset = type(of:self).eyeOffsetFactor * (eye == .left ? 1 : -1) // Don't want the eyes to scale at the same time, so let's offset them a bit
                return 1 + (sin((phase * type(of:self).speed) + phaseOffset) * type(of:self).eyeScaleFactor)
            default:
                return 1
            }
        }
    }
    
    private(set) var leftEyeState: EyeState
    private(set) var rightEyeState: EyeState
    private(set) var handStates: [HandState]
    private(set) var mouthState: MouthState
    
    init(leftEyeState: EyeState, rightEyeState: EyeState, handStates: [HandState], mouthState: MouthState) {
        self.leftEyeState = leftEyeState
        self.rightEyeState = rightEyeState
        self.handStates = handStates
        self.mouthState = mouthState
    }
    
    // MARK: IBDudeModel
    
    lazy var mouthTransform: CGAffineTransform = {
        let scale = self.mouthState.scale
        return CGAffineTransform(rotationAngle: CGFloat(self.mouthState.rotationAngle)).concatenating(CGAffineTransform(scaleX:scale.x, y: scale.y))
    }()
    
    lazy var leftEyeTransform: CGAffineTransform = {
        return self.transform(forEyeState: self.leftEyeState)
    }()
    
    lazy var rightEyeTransform: CGAffineTransform = {
        return self.transform(forEyeState: self.rightEyeState)
    }()
    
    lazy var handIconUp: UIImage? = {
        return self.image(forHandPosition: .up)
    }()
    
    lazy var handIconDown: UIImage? = {
        return self.image(forHandPosition: .down)
    }()
    
    lazy var handIconLeft: UIImage? = {
        return self.image(forHandPosition: .left)
    }()
    
    lazy var handIconRight: UIImage? = {
        return self.image(forHandPosition: .right)
    }()
    
    // MARK: Helpers
    
    private func transform(forEyeState eyeState: EyeState) -> CGAffineTransform {
        return CGAffineTransform(rotationAngle: CGFloat(eyeState.rotationAngle)).concatenating(CGAffineTransform(scaleX: CGFloat(eyeState.scale), y: CGFloat(eyeState.scale)))
    }
    
    private func image(forHandPosition handPosition: HandPosition) -> UIImage? {
        // Holy cumbersome batman
        let handState: HandState? = self.handStates.filter({ state in
            switch(state) {
            case .resisting(let pos):
                return pos == handPosition
            case .hugging(let pos):
                return pos == handPosition
            }
        }).first
        
        return handState?.icon
    }
}
