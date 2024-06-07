//
//  GYBaseNc.swift
//  GY
//
//  Created by fengyuan on 2024/5/30.
//

import UIKit

open class GYBaseNc: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    

    public override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

}
