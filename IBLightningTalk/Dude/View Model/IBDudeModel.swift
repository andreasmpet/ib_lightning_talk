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
    var leftEyeIcon: UIImage { get }
    var rightEyeIcon: UIImage { get }
    var leftEyeTransform: CGAffineTransform { get }
    var rightEyeTransform: CGAffineTransform { get }
    var handIconLeft: UIImage? { get }
    var handIconRight: UIImage? { get }
}

class IBDudeDefaultModel: IBDudeModel {
    
    typealias Phase = Float
    typealias SmileWidth = Float

    enum HandPosition: String {
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
        
        case smile(SmileWidth, Phase)
        case frown(Phase)
        case open(Phase)
        
        var rotationAngle: Float {
            switch(self) {
            case .smile(_, let phase):
                return Float.pi + sin(phase) * type(of:self).frownVibrateFactor
            case .frown(let phase):
                return sin(phase * type(of:self).speed) * type(of:self).frownVibrateFactor
            default:
                return 0
            }
        }
        
        var scale: CGPoint {
            switch(self) {
            case .smile(let smileWidth, _):
                return CGPoint(x: CGFloat(smileWidth), y: 1)
            case.open(let phase):
                return CGPoint(x: CGFloat(1 + 0.1 * sin(phase)), y: 1)
            default:
                return CGPoint(x: 1, y: 1)
            }
        }
        
        var mouthIcon: UIImage {
            switch self {
            case .open(_):
                return UIImage(named: "mouth_open")!
            default:
                return UIImage(named: "mouth_frown")!
            }
        }
    }
    
    enum Eye {
        case left
        case right
    }
    
    enum EyeState {
        static let eyeOffsetFactor: Float = 0.2
        static let eyeScaleFactor: Float = 0.1
        static let eyeRotationAngle: Float = (Float.pi / 6)
        static let speed: Float = 3
        
        case squint(Eye, Phase)
        case open(Eye, Phase)
        case worried(Eye, Phase)
        
        var rotationAngle: Float {
            switch(self) {
            case .open(_):
                return 0
            case .squint(let eye, _):
                return type(of:self).eyeRotationAngle * (eye == .left ? 1 : -1)
            case .worried(let eye, _):
                return  -type(of:self).eyeRotationAngle * (eye == .left ? 1 : -1)
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
        
        var icon: UIImage {
            switch (self) {
            case .open(_), .worried(_):
                return UIImage(named: "eye_open")!
            case .squint(let eye, _):
                return UIImage(named: eye == .left ? "eye_left_squint" : "eye_right_squint")!
            }
        }
    }

    
    private(set) var eyeStates: [EyeState]
    private(set) var handStates: [HandState]
    private(set) var mouthState: MouthState
    
    init(eyeStates: [EyeState], handStates: [HandState], mouthState: MouthState) {
        self.eyeStates = eyeStates
        self.handStates = handStates
        self.mouthState = mouthState
    }
    
    lazy private var leftEyeState: EyeState = {
        return self.findEyeState(forEyePosition: .left)
    }()
    
    lazy private var rightEyeState: EyeState = {
        return self.findEyeState(forEyePosition: .right)
    }()
    
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
    
    lazy var leftEyeIcon: UIImage = {
        return self.leftEyeState.icon
    }()
    
    lazy var rightEyeIcon: UIImage = {
        return self.rightEyeState.icon
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
    
    private func findEyeState(forEyePosition position: Eye) -> EyeState {
        return self.eyeStates.filter({ state in
            switch(state) {
            case .squint(let pos, _), .open(let pos, _), .worried(let pos, _):
                return pos == position
            }
        }).first!
    }
}
