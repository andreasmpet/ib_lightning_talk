//
//  IBCompressionAnimation.swift
//  IBLightningTalk
//
//  Created by Andreas on 02/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit


class IBHuggingAnimation: NSObject, IBDudeAnimation {
    private static let framePath = "frame"
    private(set) var referenceView: UIView!
    
    private var compressedSize: CGSize!
    
    //TODO: Reduce duplication between this file and IBCompressionAnimation. In a hurry.
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
                                    .hugging(.left),
                                    .hugging(.right),
                                    ],
                                  mouthState: self.mouthState(forPhase: phase))
    }
    
    // MARK: Updates
    
    private func updateCompressedSize() {
        self.compressedSize = self.referenceView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    // MARK: Helpers
    
    private func eyeStates(forPhase phase: Float) -> [IBDudeDefaultModel.EyeState] {
        if (self.isHuggingPerfectly) {
            return [.open(.left, phase), .open(.right, phase)]
        } else {
            return [.worried(.left, phase), .worried(.right, phase)]
        }
    }
    
    private func mouthState(forPhase phase: Float) -> IBDudeDefaultModel.MouthState {
        if (self.isHuggingPerfectly) {
            return .smile(1, phase)
        } else {
            return .open(phase)
        }
    }
    
    private var horizontalCompressionFactor: Float {
        return Float(self.compressedSize.width) / Float(self.referenceView.frame.size.width)
    }
    
    private var isHuggingPerfectly: Bool {
        return self.horizontalCompressionFactor == 1
    }
}
