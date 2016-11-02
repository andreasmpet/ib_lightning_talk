//
//  IBDudeAnimator.swift
//  IBLightningTalk
//
//  Created by Andreas on 02/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit

class IBDudeAnimator: NSObject {
    private(set) var view: IBDudeView
    var animation: IBDudeAnimation
    private(set) var idleFrameUpdateInterval: TimeInterval
    
    private var startTime: TimeInterval?
    private var elapsedTime: TimeInterval = 0 {
        didSet {
            self.update(withElapsedTime: self.elapsedTime)
        }
    }
    
    private var idleTimer: Timer?
    
    init(view: IBDudeView, animation: IBDudeAnimation, idleFrameUpdateInterval: TimeInterval) {
        self.view = view
        self.animation = animation
        self.idleFrameUpdateInterval = idleFrameUpdateInterval
    }
    
    func start() {
        self.startTime = Date().timeIntervalSinceReferenceDate
        self.resetIdleTimer()
    }
    
    func stop() {
        self.startTime = nil
        self.idleTimer?.invalidate()
    }
    
    func resetIdleTimer() {
        self.idleTimer?.invalidate()
        self.idleTimer = Timer(timeInterval: self.idleFrameUpdateInterval, repeats: true, block: { (t) in
            if let startTime = self.startTime {
                self.elapsedTime = startTime - Date().timeIntervalSinceReferenceDate
            }
        })
        RunLoop.main.add(self.idleTimer!, forMode: RunLoopMode.commonModes)
    }
    
    private func update(withElapsedTime elapsedTime: TimeInterval) {
        self.view.viewModel = animation.model(forPhase: Float(elapsedTime))
    }
}
