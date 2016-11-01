//
//  ViewInjector.swift
//  CardGenerator
//
//  Created by Andreas on 24/09/16.
//  Copyright © 2016 Andreas Petrov. All rights reserved.
//

import UIKit

class ViewInjector {
    static func inject(view: UIView, intoContainer container: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
    }
}
