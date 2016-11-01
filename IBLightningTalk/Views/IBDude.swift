//
//  IBDude.swift
//  IBLightningTalk
//
//  Created by Andreas on 01/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit

@IBDesignable
class IBDude: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of:self))
        _ = NibInjector.inject(fristViewInNibNamed: "IBDude", inBundle: bundle, intoContainer: self, withOwner: self)
    }
}
