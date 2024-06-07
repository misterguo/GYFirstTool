//
//  GYBaseView.swift
//  GY
//
//  Created by fengyuan on 2024/5/30.
//

import UIKit

open class GYBaseView: UIView {

    public var viewBlock:((_ isClose:Bool) -> Void)?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        KJAdaptiveTools.kj_adaptiveViewLayout(withViewXib: self)
    }

}
