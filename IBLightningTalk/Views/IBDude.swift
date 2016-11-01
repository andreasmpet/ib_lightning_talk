//
//  IBDude.swift
//  IBLightningTalk
//
//  Created by Andreas on 01/11/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit
import ImageFilters
import DynamicColor

@IBDesignable
class IBDude: UIView {

    // MARK: Public Properties
    
//    @IBInspectable var colorizeAmount: Float = 0 {
//        didSet {
//            self.update(fromColorizeAmount:self.colorizeAmount)
//        }
//    }
    
    var viewModel: IBDudeModel! {
        didSet {
            self.update(fromViewModel: self.viewModel, animated: true)
        }
    }
    
    // MARK: Private Properties
    @IBOutlet private weak var bodyImageView: UIImageView!
    @IBOutlet private weak var mouthImageView: UIImageView!
    
    // MARK: Init
    
    convenience init(viewModel: IBDudeModel) {
        self.init(frame: CGRect(x: 0, y: 0, width: 32, height: 32)) // Rect is arbitrary size. Content will determine final size
    }
    
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
        
        if let model = self.viewModel {
            self.update(fromViewModel: model, animated: false)
        }
        
        
        
//        self.update(fromColorizeAmount: self.colorizeAmount)
    }
    
    
    private func update(fromViewModel model: IBDudeModel, animated: Bool) {
        if (animated) {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.update(fromViewModel: model)
            }, completion: nil)
        } else {
            self.update(fromViewModel: model)
        }
    }
    
    private func update(fromViewModel model: IBDudeModel) {
        
    }
    
    private func update(fromColorizeAmount amount: Float) {
//        let image: UIImage = UIImage(named: "dude_body", in: Bundle(for: type(of:self)), compatibleWith: nil)!
//        self.bodyImageView.image = image.filter
    }

}
