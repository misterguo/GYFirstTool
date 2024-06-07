//
//  GYBaseVc.swift
//  GY
//
//  Created by fengyuan on 2024/5/30.
//

import UIKit

open class GYBaseVc: UIViewController {
    
    public var pram : [String : Any]?
    
    @objc open func vc_back() {
        if (presentingViewController != nil) {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc public func vc_backHome() {
        navigationController?.popToRootViewController(animated: true)
        gy_tarIndex(0)
        NotificationCenter.default.post(name: notificationCancelApply, object: nil)
    }
    
    @objc public func sjin_popToVcWithName(VcName: String) {
        guard let ctrs = navigationController?.viewControllers else { return }
        for c in ctrs {
            let vcName = String(describing: type(of: c))
            if vcName == VcName {
                navigationController?.popToViewController(c, animated: true)
                return
            }
        }
        print("Controller with name \(VcName) not found in the navigation stack.")
        vc_backHome()
    }
    
}
