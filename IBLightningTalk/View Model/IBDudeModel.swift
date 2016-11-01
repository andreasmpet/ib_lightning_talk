//
//  IBDudeModel.swift
//  IBLightningTalk
//
//  Created by Andreas on 01/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit

class IBDudeModel {
    
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
            var name: String = ""
            switch self {
            case .resisting(let handPosition):
                name = "resisting_\(handPosition)"
                break
            case .hugging(let handPosition):
                name = "hugging_\(handPosition)"
                break
            }
            
            return UIImage(named: name)
        }
    }
    
    enum MouthState {
        static let frownVibrateFactor: Float = 0.2
        
        case smile(SmileWidth)
        case frown(Phase)
        
        var rotationAngle: Float {
            switch(self) {
            case .smile(_):
                return 0
            case .frown(let phase):
                return Float.pi + sin(phase) * type(of:self).frownVibrateFactor
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
        static let eyeScaleFactor: Float = 0.2
        
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
                return 1 + (sin(phase + phaseOffset) * type(of:self).eyeScaleFactor)
            default:
                return 1
            }
        }
    }
    
    private(set) var eyeStates: [EyeState]
    private(set) var handStates: [HandState]
    private(set) var mouthState: MouthState
    
    var mouthTransform: CGAffineTransform {
        let scale = self.mouthState.scale
        return CGAffineTransform(rotationAngle: CGFloat(self.mouthState.rotationAngle)).concatenating(CGAffineTransform(scaleX:scale.x, y: scale.y))
    }
    
    init(eyeStates: [EyeState], handStates: [HandState], mouthState: MouthState) {
        self.eyeStates = eyeStates
        self.handStates = handStates
        self.mouthState = mouthState
    }
    
}
