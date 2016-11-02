//
//  ViewController.swift
//  IBLightningTalk
//
//  Created by Andreas on 01/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var dudeView: IBDudeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dudeModel = IBDudeDefaultModel(leftEyeState: .squint(.left, 0),
                                           rightEyeState: .squint(.right, 0),
                                           handStates: [
                                                .resisting(.left),
                                                .resisting(.right),
                                           ],
                                           mouthState: .frown(0))
        
        self.dudeView.viewModel = dudeModel
    }
}

