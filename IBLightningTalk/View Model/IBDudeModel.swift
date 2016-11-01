//
//  IBDudeModel.swift
//  IBLightningTalk
//
//  Created by Andreas on 01/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit

class IBDudeModel {
    enum HandPosition {
        case strainingHorizontally
        case strainingVertically
        case huggingHorizontally
    }
    
    enum MouthPosition {
        case upward
        case downward
        
        var rotationAngle: Float {
            switch(self) {
            case .upward:
                return 0
            case .downward:
                return Float.pi
            }
        }
    }
    
}
