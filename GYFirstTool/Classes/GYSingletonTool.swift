//
//  GYSingletonTool.swift
//  GY
//
//  Created by fengyuan on 2024/5/30.
//

import UIKit

public class GYSingletonTool: NSObject {
    static let o = GYSingletonTool()
    
    public var versionVC : UIViewController?
    public var configModel : GYConfigModel?
    public var userModel : MineUserModel?
    public var versionModel:GYVersionModel?
    public var homeNo : String = ""
    public var isKycSuc = false
    public var isFalseBook = false
    public var contactStatus = 0
    public var isLogin = false
    public var window: UIWindow!
    public var abStatus: Bool = false
    
    public var isWantLeave = true
    public var orderType = 10
     
    public var longitude: String = "-360"
    public var latitude: String = "-360"
    public var tabBar : UITabBarController!
    public var tabBarBtn : [UIButton]!
    public var rootVc:UIViewController? {
        get{
            UIApplication.shared.keyWindow?.rootViewController
        }
    }
    @UserDefaultsWrapper(key: "showGoodStar", defaultValue: 0)
    public var isShowGoodStar:Int
    @UserDefaultsWrapper(key: "FirstOpenApp", defaultValue: false)
    public var firstOpenApp:Bool
    @UserDefaultsWrapper(key: "token", defaultValue: "")
    public var token:String
    @UserDefaultsWrapper(key: "userId", defaultValue: "")
    public var userId:String
    @UserDefaultsWrapper(key: "phone", defaultValue: "")
    public var phone:String
    
    public func clearUserDefault() {
        let one = GYSingletonTool.o
        one.token = ""
        one.userId = ""
        one.isKycSuc = false
        one.isLogin = false
    }
    
    public func clearLacation() {
        let one = GYSingletonTool.o
        one.latitude = "-360"
        one.longitude = "-360"
    }
}
