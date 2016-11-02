//
//  IBCompressionAnimation.swift
//  IBLightningTalk
//
//  Created by Andreas on 02/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit

class IBCompressionAnimation: IBDudeAnimation {
    private(set) var referenceView: UIView
    init(referenceView: UIView) {
        self.referenceView = referenceView
    }
    
    func model(forPhase phase: Float) -> IBDudeModel {
        return IBDudeDefaultModel(leftEyeState: .squint(.left, phase),
                                  rightEyeState: .squint(.right, phase),
                                  handStates: [
                                    .resisting(.left),
                                    .resisting(.right),
                                    ],
                                  mouthState: .frown(phase))
    }
}
