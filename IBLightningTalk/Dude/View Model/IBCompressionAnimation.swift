//
//  IBCompressionAnimation.swift
//  IBLightningTalk
//
//  Created by Andreas on 02/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit


class IBCompressionAnimation: NSObject, IBDudeAnimation {
    private static let framePath = "frame"
    private(set) var referenceView: UIView!
    
    private var compressedSize: CGSize!
    
    init(referenceView: UIView) {
        super.init()
        self.referenceView = referenceView
        self.referenceView.addObserver(self, forKeyPath: type(of:self).framePath , options: NSKeyValueObservingOptions(), context: nil)
        self.updateCompressedSize()
    }
    
    deinit {
        self.referenceView.removeObserver(self, forKeyPath: type(of:self).framePath)
    }
    
    // MARK: NSObject
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == type(of:self).framePath) {
            self.updateCompressedSize()
        }
    }
    
    // MARK: IBDudeAnimation
    
    func model(forPhase phase: Float) -> IBDudeModel {
        return IBDudeDefaultModel(eyeStates: self.eyeStates(forPhase: phase),
                                  handStates: [
                                    .resisting(.left),
                                    .resisting(.right),
                                    ],
                                  mouthState: self.mouthState(forPhase: phase))
    }
    
    // MARK: Updates
    
    private func updateCompressedSize() {
        self.compressedSize = self.referenceView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    // MARK: Helpers
    
    private func eyeStates(forPhase phase: Float) -> [IBDudeDefaultModel.EyeState] {
        if (self.isBeingCompressed) {
            return [.squint(.left, phase), .squint(.right, phase)]
        } else {
            return [.open(.left, phase), .open(.right, phase)]
        }
    }
    
    private func mouthState(forPhase phase: Float) -> IBDudeDefaultModel.MouthState {
        if (self.isBeingCompressed) {
            return .frown(phase)
        } else {
            let smileWidthFactor = 1 + (1 - self.mostCompressedFactor)
            return .smile(smileWidthFactor, phase)
        }
    }
    
    private var mostCompressedFactor: Float {
        return max(self.horizontalCompressionFactor, self.verticalCompressionFactor)
    }
    
    private var horizontalCompressionFactor: Float {
        return Float(self.compressedSize.width) / Float(self.referenceView.frame.size.width)
    }
    
    private var verticalCompressionFactor: Float {
        return Float(self.compressedSize.height) / Float(self.referenceView.frame.size.height)
    }
    
    private var isBeingCompressed: Bool {
        return self.horizontalCompressionFactor > 1 || self.verticalCompressionFactor > 1
    }
}
