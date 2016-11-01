//
//  NibInjector.swift
//  CardGenerator
//
//  Created by Andreas on 24/09/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit

class NibInjector {
    
    static func inject(fristViewInNibNamed name: String, inBundle bundle: Bundle?, intoContainer container: UIView, withOwner owner: Any?) -> UIView {
        return self.inject(firstViewInNib: UINib(nibName: name, bundle: bundle), intoContainer: container, withOwner: owner)
    }
    
    static func inject(firstViewInNib nib: UINib, intoContainer container: UIView, withOwner owner: Any?) -> UIView {
        let view = nib.instantiate(withOwner: owner, options: nil).first as! UIView
        ViewInjector.inject(view: view, intoContainer: container)
        return view
    }
}
