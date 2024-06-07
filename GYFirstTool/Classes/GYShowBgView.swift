//
//  GYShowBgView.swift
//  GY
//
//  Created by fengyuan on 2024/5/30.
//

import UIKit

open class GYShowBgView: GYBaseView {
    
    public enum showType {
    case center
    case left
    case bottom
    }
    
    var animateTime = 0.3
    private var _tapHidden:Bool = false
    public var tapHidden:Bool {
        set {
            _tapHidden = newValue
            bgBtn.isEnabled = newValue
        }
        get {
            return _tapHidden
        }
    }
    
    lazy var bgBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.addTarget(self, action: #selector(btnHidden), for: .touchUpInside)
        return btn
    }()
    var contentView:UIView!
    private var _contentType:showType?
    public var contentType:showType? {
        set {
            _contentType = newValue
        }
        get {
            return _contentType
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(white: 0, alpha: 0.5)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func btnHidden() {
        hiddenView {
        }
    }
    
    public func showView(_ v:UIView) {
        let window = UIApplication.shared.keyWindow
        self.frame = UIScreen.main.bounds
        window?.addSubview(self)
        bgBtn.frame = self.bounds
        addSubview(bgBtn)
        contentView = v
        if contentType == .center {
            contentView.frame = CGRectMake((self.width - contentView.width)/2, (self.height-contentView.height)/2, contentView.width, contentView.height)
        } else if contentType == .left {
            contentView.frame = CGRectMake(self.x, (self.height-contentView.height)/2, contentView.width, contentView.height)
        } else {
            contentView.frame = CGRectMake((self.width - contentView.width)/2, self.height-contentView.height, contentView.width, contentView.height)
        }
        addSubview(contentView)
        self.alpha = 1
        if contentType == .center {
            self.alpha = 0
            self.contentView.alpha = 0
            UIView.animate(withDuration: animateTime) {
                self.alpha = 1
                self.contentView.alpha = 1
            }
        } else if contentType == .left {
            var rect = contentView.frame
            rect.origin.x = -rect.width
            contentView.frame = rect
            UIView.animate(withDuration: animateTime) {
                var rect = self.contentView.frame
                rect.origin.x += rect.size.width
                self.contentView.frame = rect
            }
        } else {
            var rect = contentView.frame
            rect.origin.y = self.height
            contentView.frame = rect
            UIView.animate(withDuration: animateTime) {
                var rect = self.contentView.frame
                rect.origin.y -= rect.size.height
                self.contentView.frame = rect
            }
        }
    }
    
    public func hiddenView(_ hiddenBlock:@escaping () -> Void) {
        UIView.animate(withDuration: animateTime) {
            if self.contentType == .center {
                self.contentView.alpha = 0
            } else if self.contentType == .left {
                var rect = self.contentView.frame
                rect.origin.x -= rect.size.width
                self.contentView.frame = rect
            } else {
                var rect = self.contentView.frame
                rect.origin.y += rect.size.height
                self.contentView.frame = rect
            }
            self.alpha = 0
        } completion: { finished in
            self.removeFromSuperview()
            hiddenBlock()
        }
    }

}
