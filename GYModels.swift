//
//  SJINModels.swift
//  SJIN
//
//  Created by fengyuan on 2024/5/30.
//

import UIKit
import KakaJSON

func getOneTool() -> SJINSingletonTool {
    return SJINSingletonTool.o
}

class SJINNomalNetModel: Convertible {
    var appId = AppID
    var channel = "app_store"
    var clientLanguage = ClientLanguage
    var clientTime: Int64 = NetNomalTool.sjin_getClientTime()
    var clientVersion: String = DeviceTool.getApplicationVersion()
    var data: NSDictionary = NSDictionary()
    var deviceId: String = FCUUID.uuidForDevice()
    var nonce: String = NetNomalTool.sjin_getNonce()
    var os = 2
    var sign = ""
    var token: String = getOneTool().token
    var userId: String = getOneTool().userId
    var version = "2.0"
    required init() {}
}

class NetNomalTool: NSObject {
    class func sjin_getClientTime() -> Int64 {
        let date = Date()
        let timeStamp = Int64(date.timeIntervalSince1970 * 1000)
        return timeStamp
    }
    class func sjin_getNonce() -> String {
        return sjin_randomStringWithNumber(number: 16)
    }
    private class func sjin_randomStringWithNumber(number: Int) -> String {
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
    class func sjin_getSignStr(_ d:[String:Any],_ m:SJINNomalNetModel) -> String {
        let dic = sjin_getSignDic(m)
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
    
    class func sjin_getSignDic(_ m:SJINNomalNetModel) -> NSMutableDictionary {
        let dic = NSMutableDictionary(dictionaryLiteral: ("appId", m.appId), ("deviceId", m.deviceId), ("os", m.os), ("channel", m.channel), ("version", m.version), ("clientTime", m.clientTime), ("nonce", m.nonce))
        return dic
    }
}

class SJINNetBackModel : Convertible {
    var data: [String: Any]!
    var resultCode: Int!
    var resultMsg: String = ""
    var timestamp: Int!
    required init() {}
}


class SJINConfigModel : Convertible {
    var aboutHref: String?
    var agreementHref: String?
    var attributionTimeout: Int?
    var authHref: String?
    var buryChannel: String?
    var conditionsHref: String?
    var contactHref: String?
    var hotline: String?
    var livenessDetectionMethod: String?
    var livenessDetectionProvider: String?
    var policyHref: String?
    var pushMaxCount: Int?
    var pushPerCount: Int?
    var qaHref: String?
    var reloanSelfCheckType: String?
    var isThirdAthena: Int?
    var retrieveMobileContact: Int!
    var appStatus: Int = 1//0zaixian 1 shenhe 2 xiajia 3feiqi
    var kycLink: String?
    var updateBankLink: String?
    var officialWebsiteUrl: String?
    var appEmail: String?
    var feedbackGuidance: String = "1"//0 off 1 all 2 old
    required init() {}
}

class SJINAmountModel : Convertible {
    var amountDetailList: [SJINAmountDetailList]?
    var bankCardList: [SJINBankCardList]?
    var productHotline: String?
    var productId: String = ""
    var productName: String = ""
    var productLogo: String?
    var productTerm: Int!
    var productTermUnit: Int!
    func kj_didConvertToModel(from json: [String : Any]) {
        amountDetailList?.sort(by: { Int($0.loanAmount) ?? 0 < Int($1.loanAmount) ?? 0 })
    }
    required init() {}
}

class SJINAmountDetailList: Convertible {
    var loanAmount:String = ""
    var termDetailList:[SJINTermDetailListModel]?
    func kj_didConvertToModel(from json: [String : Any]) {
        termDetailList?.sort(by: { $0.showTerm < $1.showTerm })
    }
    required init() {}
}

class SJINTermDetailListModel: Convertible {
    var productTermItemList:[SJINPuctTermItemModel]?
    var arrivalAmount: String = ""
    var borrowingDate: String?
    var feeAmount: String = ""
    var interestAmount: String = ""
    var loanTerm: Int?
    var productTermUnit: Int!
    var repaymentAmount: String = ""
    var repaymentDate: String?
    var showTerm: Int!
    var taxAmount: String = ""
    
    required init() {}
}

class SJINPuctTermItemModel: Convertible {
    var expirationDate: String = ""
    var interestAmountDue: String = ""
    var principalAmountDue: String = ""
    var repaymentAmount: String = ""
    required init() {}
}

class SJINBankCardList: Convertible {
    var accountName: String = ""
    var accountNo: String = ""
    var accountPhone: String = ""
    var accountType: String = ""
    var bankCode: String = ""
    var bankName: String = ""
    var bindId: String = ""
    var currency: String?
    required init() {}
}

class SJINHomeModel : Convertible {
    var userStatus: Int!
    var productId : String = ""
    var productAmount : String = ""
    var currentOrderId:String = ""
    var currentPeriodNo: String = ""
    var nextApplyDate : String?
    var appUserType: Int!
    var firstLoanOptionLine: String = ""
    required init() {}
}

class DCHomeModel : Convertible {
    var userStatus: Int!
    var appUserType: Int!
    var hasOrder : Int!
    var firstLoanOptionLine : String = ""
    var loanSuccessRecordList : [String]?
    var appProductBanner : [DCHomeBannerModel]?
    var appLabelBanner : [DCHomeBannerModel]?
    var promptCopy : String = ""
    var downloadUrl : String?
    required init() {}
}

class DCHomeBannerModel: Convertible {
    var bannerHref : String?
    var relationId : String?
    required init() {}
}

class DCProductModel: Convertible {
    var productInfoList: [DCProductInfoListModel]?
    var productLabelList: [DCProductLabelListModel]?
    required init() {}
}

class DCProductInfoListModel: Convertible {
    var productLogo: String?
    var productId: String = ""
    var productName: String = ""
    var productLabel: String = ""
    var lowAmount: String = ""
    var highAmount: String = ""
    var lowestLoanInterestRate: String?
    var productApplicantsNumber: String?
    required init() {}
}

class DCProductLabelListModel: Convertible {
    var labelId: String = ""
    var labelName: String = ""
    required init() {}
}

class KycInfoModel : Convertible {
    required init() {}
    var kycType: Int!
    var kycId: String = ""
    var kycItemList: [kycItemListModel]?
    func kj_didConvertToModel(from json: [String : Any]) {
        kycItemList?.sort(by: { $0.itemSort < $1.itemSort })
    }
}

class kycItemListModel: Convertible {
    required init() {}
    var buttonList: [buttonList]?
    var frontPrompts: [String]?
    var isRequired: Int?
    var itemCode: String = ""
    var itemName: String = ""
    var itemSort: Int!
    var itemStatus: Int!
    var itemType: Int!
    var rearPrompts: [String]?
    var regularExpression: String?
    var seleteButtonKey:String?
    func kj_didConvertToModel(from json: [String : Any]) {
        buttonList?.sort(by: { $0.buttonSort < $1.buttonSort })
    }
}

class buttonList: Convertible {
    var buttonKey: String?
    var buttonLabel: String?
    var buttonSort: Int = 0
    required init() {}
}

class KycListModel: Convertible {
    var kycList: [KycStatusModel]?
    func kj_didConvertToModel(from json: [String : Any]) {
        kycList?.removeAll(where: { $0.kycStatus != "0" })
        kycList?.sort(by: { $0.kycSort < $1.kycSort })
    }
    required init() {}
}

class KycStatusModel: Convertible {
    var kycId: String = ""
    var kycSort: Int!
    var kycStatus: String = ""
    var kycType: Int!
    required init() {}
}

class KycAreaModel : Convertible {
    var key: String = ""
    var sort: Int!
    var label: String = ""
    var logo: String?
    required init() {}
}

class MineBankModel: Convertible {
    var accountName: String = ""
    var accountNo: String = ""
    var accountPhone: String = ""
    var accountType: String = ""
    var bankCode: String = ""
    var bankName: String = ""
    var bindId: String = ""
    var currency: String?
    var creditCard: String?
    required init() {}
}

class MineUserModel: Convertible {
    var appUserType: Int!
    var phone: String = ""
    var name: String?
    var userStatus: Int!
    var payAccountModifySwitch: String = ""
    required init() {}
}


class SJINOrderDetailModel: Convertible {
    var bankCard: SJINBankCard?
    var orderDetail: SJINOrderDetail?
    var product: SJINProduct?
    required init() {}
}
class SJINProduct: Convertible {
    var productId: String = ""
    var productName: String = ""
    var productLogo: String = ""
    required init() {}
}

class SJINBankCard: Convertible {
    var accountName: String = ""
    var accountNo: String = ""
    var bankCode: String = ""
    var bankName: String = ""
    var bindId: String = ""
    required init() {}
}


class SJINOrderDetail: Convertible {
    var alreadyRepaymentAmount: String = ""
    var applyDate: String = ""
    var dueDate: String?
    var feeAmount: String = ""
    var interestAmount: String = ""
    var loanAmount: String = ""
    var loanTerm: Int?
    var loanTermUnit: Int = 0
    var orderId: String = ""
    var orderStatus: Int = 0
    var payoutDate: String?
    var penaltyAmount: String = ""
    var penaltyDays: Int = 0
    var receiptAmount: String = ""
    var reductionAmount: String = ""
    var repaymentDate: String?
    var riskDate: String?
    var shouldRepaymentAmount: String = ""
    var taxAmount: String = ""
    var totalRepaymentAmount: String = ""
    /// Whether it can be extended, 1: yes 2: no
    var ifExtension: String = ""
    /// Actual payment of extension fees
    var repayExtensionFeeAmount: String?
    var showTerm: Int = 0
    var productTermItemList:[SJINPuctTermItemModel]?
    required init() {}
}

class SJINOrderListModel: Convertible {
    var applyDate: String = ""
    var dueDate: String?
    var loanAmount: String = ""
    var loanDate: String?
    var orderId: String = ""
    var orderStatus: Int = 0
    var productId: String = ""
    var productName: String = ""
    var repayDate: String?
    required init() {}
}

class SJINVersionModel: Convertible {
    var latestForceVersion: String?
    var latestForceVersionContent: String?
    var latestForceVersionUrl: String?
    var latestVersion: String?
    var latestVersionContent: String?
    var latestVersionUrl: String?
    required init(){}
}

class SJINKycPersonModel:Convertible {
    var bookArr:[kycItemListModel]?
    var idx:Int?
    var other:kycItemListModel?
    var emailTag:Int?
    required init(){}
}

class SJINFrontBankModel: Convertible {
    var bankName: String = ""
    var bankLogo: String = ""
    var balanceCheck: String = ""
    var customerCare: String = ""
    var bankUrl: String = ""
    required init() {}
}

class SJINFrontBankInfoModel: Convertible {
    var bankName: String = ""
    var branchName: String = ""
    var ifscCode: String = ""
    var micrCode: String = ""
    var bankAddress: String = ""
    var contactNo: String = ""
    var cityName: String = ""
    var districtName: String = ""
    var stateName: String = ""
    var isCollection: String = "0"
    required init() {}
}
