//
//  ViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-03.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import UIKit
import Reachability

class RootViewController: UIViewController, Theme {
    
    @IBOutlet weak var containerView: UIView!
    
    // MARK: ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentNext()
    }
   
}
