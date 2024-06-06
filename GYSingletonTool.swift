//
//  GYSingletonTool.swift
//  GY
//
//  Created by fengyuan on 2024/5/30.
//

import UIKit

class GYSingletonTool: NSObject {
    static let o = GYSingletonTool()
    
    var versionVC : UIViewController?
    var configModel : GYConfigModel?
    var userModel : MineUserModel?
    var versionModel:GYVersionModel?
    var homeNo : String?
    var isKycSuc = false
    var isFalseBook = false
    var contactStatus = 0
    var isLogin = false
    var window: UIWindow!
    var abStatus: Bool = false
    
    var isWantLeave = true
    var orderType = 10
    
    var longitude: String = "-360"
    var latitude: String = "-360"
    var tabBar : UITabBarController!
    var tabBarBtn : [UIButton]!
    var rootVc:UIViewController? {
        get{
            UIApplication.shared.keyWindow?.rootViewController
        }
    }
    @UserDefaultsWrapper(key: "showGoodStar", defaultValue: 0)
    var isShowGoodStar:Int
    @UserDefaultsWrapper(key: "FirstOpenApp", defaultValue: false)
    var firstOpenApp:Bool
    @UserDefaultsWrapper(key: "token", defaultValue: "")
    var token:String
    @UserDefaultsWrapper(key: "userId", defaultValue: "")
    var userId:String
    @UserDefaultsWrapper(key: "phone", defaultValue: "")
    var phone:String
    
    func clearUserDefault() {
        let one = GYSingletonTool.o
        one.token = ""
        one.userId = ""
        one.isKycSuc = false
        one.isLogin = false
    }
    
    func clearLacation() {
        let one = GYSingletonTool.o
        one.latitude = "-360"
        one.longitude = "-360"
    }
}
