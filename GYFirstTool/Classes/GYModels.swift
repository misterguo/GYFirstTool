//
//  GYModels.swift
//  GY
//
//  Created by fengyuan on 2024/5/30.
//

import UIKit
import KakaJSON
import FCUUID

public func getOneTool() -> GYSingletonTool {
    return GYSingletonTool.o
}

public var AppID:String = ""
public var salt:String = ""

public class GYNomalNetModel: Convertible {
    public var appId = AppID
    public var channel = "app_store"
    public var clientLanguage = ClientLanguage
    public var clientTime: Int64 = NetNomalTool.gy_getClientTime()
    public var clientVersion: String = DeviceTool.getApplicationVersion()
    public var data: NSDictionary = NSDictionary()
    public var deviceId: String = FCUUID.uuidForDevice()
    public var nonce: String = NetNomalTool.gy_getNonce()
    public var os = 2
    public var sign = ""
    public var token: String = getOneTool().token
    public var userId: String = getOneTool().userId
    public var version = "2.0"
    required public init() {}
}

public class NetNomalTool: NSObject {
    class public func gy_getClientTime() -> Int64 {
        let date = Date()
        let timeStamp = Int64(date.timeIntervalSince1970 * 1000)
        return timeStamp
    }
    class public func gy_getNonce() -> String {
        return gy_randomStringWithNumber(number: 16)
    }
    private class func gy_randomStringWithNumber(number: Int) -> String {
        var randomString = ""
        var array = [String]()
        while array.count < number {
            let a = arc4random_uniform(123)
            if a > 96 {
                let c = Character(UnicodeScalar(a)!)
                array.append(String(c))
            }
        }
        randomString = array.joined()
        return randomString
    }
    class public func gy_getSignStr(_ d:[String:Any],_ m:GYNomalNetModel) -> String {
        let dic = gy_getSignDic(m)
        dic.addEntries(from: d)
        var array: [String] = []
        dic.forEach { key, value in
            let keyAndValue = "\(key)=\(value)"
            array.append(keyAndValue)
        }
        array.sort { $0 < $1 }
        let s1 = array.joined(separator: "&")
        let s2 = s1.md5.uppercased()
        let s3 = "\(s2)\(salt)"
        let sign = s3.md5.uppercased()
        return sign
    }
    
    class public func gy_getSignDic(_ m:GYNomalNetModel) -> NSMutableDictionary {
        let dic = NSMutableDictionary(dictionaryLiteral: ("appId", m.appId), ("deviceId", m.deviceId), ("os", m.os), ("channel", m.channel), ("version", m.version), ("clientTime", m.clientTime), ("nonce", m.nonce))
        return dic
    }
}

public class GYNetBackModel : Convertible {
    public var data: [String: Any]!
    public var resultCode: Int!
    public var resultMsg: String = ""
    public var timestamp: Int!
    required public init() {}
}


public class GYConfigModel : Convertible {
    public var aboutHref: String?
    public var agreementHref: String?
    public var attributionTimeout: Int?
    public var authHref: String?
    public var buryChannel: String?
    public var conditionsHref: String?
    public var contactHref: String?
    public var hotline: String?
    public var livenessDetectionMethod: String?
    public var livenessDetectionProvider: String?
    public var policyHref: String?
    public var pushMaxCount: Int?
    public var pushPerCount: Int?
    public var qaHref: String?
    public var reloanSelfCheckType: String?
    public var isThirdAthena: Int?
    public var retrieveMobileContact: Int!
    public var appStatus: Int = 1//0zaixian 1 shenhe 2 xiajia 3feiqi
    public var kycLink: String?
    public var updateBankLink: String?
    public var officialWebsiteUrl: String?
    public var appEmail: String?
    public var feedbackGuidance: String = "1"//0 off 1 all 2 old
    required public init() {}
}

public class GYAmountModel : Convertible {
    public var amountDetailList: [GYAmountDetailList]?
    public var bankCardList: [GYBankCardList]?
    public var productHotline: String = ""
    public var productId: String = ""
    public var productName: String = ""
    public var productLogo: String = ""
    public var productTerm: Int = 0
    public var productTermUnit: Int = 0
    public func kj_didConvertToModel(from json: [String : Any]) {
        amountDetailList?.sort(by: { Int($0.loanAmount) ?? 0 < Int($1.loanAmount) ?? 0 })
    }
    required public init() {}
}

public class GYAmountDetailList: Convertible {
    public var loanAmount:String = ""
    public var termDetailList:[GYTermDetailListModel]?
    public func kj_didConvertToModel(from json: [String : Any]) {
        termDetailList?.sort(by: { $0.showTerm < $1.showTerm })
    }
    required public init() {}
}

public class GYTermDetailListModel: Convertible {
    public var productTermItemList:[GYPuctTermItemModel]?
    public var arrivalAmount: String = ""
    public var borrowingDate: String = ""
    public var feeAmount: String = ""
    public var interestAmount: String = ""
    public var loanTerm: Int = 0
    public var productTermUnit: Int = 0
    public var repaymentAmount: String = ""
    public var repaymentDate: String = ""
    public var showTerm: Int = 0
    public var taxAmount: String = ""
    
    required public init() {}
}

public class GYPuctTermItemModel: Convertible {
    public var expirationDate: String = ""
    public var interestAmountDue: String = ""
    public var principalAmountDue: String = ""
    public var repaymentAmount: String = ""
    required public init() {}
}

public class GYBankCardList: Convertible {
    public var accountName: String = ""
    public var accountNo: String = ""
    public var accountPhone: String = ""
    public var accountType: String = ""
    public var bankCode: String = ""
    public var bankName: String = ""
    public var bindId: String = ""
    public var currency: String?
    required public init() {}
}

public class GYHomeModel : Convertible {
    public var userStatus: Int = 0
    public var productId : String = ""
    public var productAmount : String = ""
    public var currentOrderId:String = ""
    public var currentPeriodNo: String = ""
    public var nextApplyDate : String = ""
    public var appUserType: Int = 0
    public var firstLoanOptionLine: String = ""
    required public init() {}
}

public class DCHomeModel : Convertible {
    public var userStatus: Int = 0
    public var appUserType: Int = 0
    public var hasOrder : Int = 0
    public var firstLoanOptionLine : String = ""
    public var loanSuccessRecordList : [String]?
    public var appProductBanner : [DCHomeBannerModel]?
    public var appLabelBanner : [DCHomeBannerModel]?
    public var promptCopy : String = ""
    public var downloadUrl : String = ""
    required public init() {}
}

public class DCHomeBannerModel: Convertible {
    public var bannerHref : String = ""
    public var relationId : String = ""
    required public init() {}
}

public class DCProductModel: Convertible {
    public var productInfoList: [DCProductInfoListModel]?
    public var productLabelList: [DCProductLabelListModel]?
    required public init() {}
}

public class DCProductInfoListModel: Convertible {
    public var productLogo: String?
    public var productId: String = ""
    public var productName: String = ""
    public var productLabel: String = ""
    public var lowAmount: String = ""
    public var highAmount: String = ""
    public var lowestLoanInterestRate: String?
    public var productApplicantsNumber: String?
    required public init() {}
}

public class DCProductLabelListModel: Convertible {
    public var labelId: String = ""
    public var labelName: String = ""
    required public init() {}
}

public class KycInfoModel : Convertible {
    required public init() {}
    public var kycType: Int = 0
    public var kycId: String = ""
    public var kycItemList: [kycItemListModel]?
    public func kj_didConvertToModel(from json: [String : Any]) {
        kycItemList?.sort(by: { $0.itemSort < $1.itemSort })
    }
}

public class kycItemListModel: Convertible {
    required public init() {}
    public var buttonList: [buttonList]?
    public var frontPrompts: [String]?
    public var isRequired: Int = 0
    public var itemCode: String = ""
    public var itemName: String = ""
    public var itemSort: Int = 0
    public var itemStatus: Int = 0
    public var itemType: Int = 0
    public var rearPrompts: [String]?
    public var regularExpression: String?
    public var seleteButtonKey:String?
    public func kj_didConvertToModel(from json: [String : Any]) {
        buttonList?.sort(by: { $0.buttonSort < $1.buttonSort })
    }
}

public class buttonList: Convertible {
    public var buttonKey: String = ""
    public var buttonLabel: String = ""
    public var buttonSort: Int = 0
    required public init() {}
}

public class KycListModel: Convertible {
    public var kycList: [KycStatusModel]?
    public func kj_didConvertToModel(from json: [String : Any]) {
        kycList?.removeAll(where: { $0.kycStatus != "0" })
        kycList?.sort(by: { $0.kycSort < $1.kycSort })
    }
    required public init() {}
}

public class KycStatusModel: Convertible {
    public var kycId: String = ""
    public var kycSort: Int = 0
    public var kycStatus: String = ""
    public var kycType: Int = 0
    required public init() {}
}

public class KycAreaModel : Convertible {
    public var key: String = ""
    public var sort: Int = 0
    public var label: String = ""
    public var logo: String?
    required public init() {}
}

public class MineBankModel: Convertible {
    public var accountName: String = ""
    public var accountNo: String = ""
    public var accountPhone: String = ""
    public var accountType: String = ""
    public var bankCode: String = ""
    public var bankName: String = ""
    public var bindId: String = ""
    public var currency: String?
    public var creditCard: String?
    required public init() {}
}

public class MineUserModel: Convertible {
    public var appUserType: Int = 0
    public var phone: String = ""
    public var name: String = ""
    public var userStatus: Int = 0
    public var payAccountModifySwitch: String = ""
    required public init() {}
}


public class GYOrderDetailModel: Convertible {
    public var bankCard: GYBankCard?
    public var orderDetail: GYOrderDetail?
    public var product: GYProduct?
    required public init() {}
}
public class GYProduct: Convertible {
    public var productId: String = ""
    public var productName: String = ""
    public var productLogo: String = ""
    required public init() {}
}

public class GYBankCard: Convertible {
    public var accountName: String = ""
    public var accountNo: String = ""
    public var bankCode: String = ""
    public var bankName: String = ""
    public var bindId: String = ""
    required public init() {}
}


public class GYOrderDetail: Convertible {
    public var alreadyRepaymentAmount: String = ""
    public var applyDate: String = ""
    public var dueDate: String?
    public var feeAmount: String = ""
    public var interestAmount: String = ""
    public var loanAmount: String = ""
    public var loanTerm: Int?
    public var loanTermUnit: Int = 0
    public var orderId: String = ""
    public var orderStatus: Int = 0
    public var payoutDate: String?
    public var penaltyAmount: String = ""
    public var penaltyDays: Int = 0
    public var receiptAmount: String = ""
    public var reductionAmount: String = ""
    public var repaymentDate: String?
    public var riskDate: String?
    public var shouldRepaymentAmount: String = ""
    public var taxAmount: String = ""
    public var totalRepaymentAmount: String = ""
        /// Whether it can be extended, 1: yes 2: no
    public var ifExtension: String = ""
        /// Actual payment of extension fees
    public var repayExtensionFeeAmount: String?
    public var showTerm: Int = 0
    public var productTermItemList:[GYPuctTermItemModel]?
    required public init() {}
}

public class GYOrderListModel: Convertible {
    public var applyDate: String = ""
    public var dueDate: String?
    public var loanAmount: String = ""
    public var loanDate: String?
    public var orderId: String = ""
    public var orderStatus: Int = 0
    public var productId: String = ""
    public var productName: String = ""
    public var repayDate: String?
    required public init() {}
}

public class GYVersionModel: Convertible {
    public var latestForceVersion: String?
    public var latestForceVersionContent: String?
    public var latestForceVersionUrl: String?
    public var latestVersion: String?
    public var latestVersionContent: String?
    public var latestVersionUrl: String?
    required public init(){}
}

public class GYKycPersonModel:Convertible {
    public var bookArr:[kycItemListModel]?
    public var idx:Int = 0
    public var other:kycItemListModel?
    public var emailTag:Int = 0
    required public init(){}
}

public class GYFrontBankModel: Convertible {
    public var bankName: String = ""
    public var bankLogo: String = ""
    public var balanceCheck: String = ""
    public var customerCare: String = ""
    public var bankUrl: String = ""
    required public init() {}
}

public class GYFrontBankInfoModel: Convertible {
    public var bankName: String = ""
    public var branchName: String = ""
    public var ifscCode: String = ""
    public var micrCode: String = ""
    public var bankAddress: String = ""
    public var contactNo: String = ""
    public var cityName: String = ""
    public var districtName: String = ""
    public var stateName: String = ""
    public var isCollection: String = "0"
    required public init() {}
}
