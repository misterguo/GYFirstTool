//
//  SJINUrl.swift
//  SJIN
//
//  Created by fengyuan on 2024/5/30.
//

import UIKit
import KakaJSON

public var AppName:String = ""

public let config_URL = "/app/v3/app/config"//config
public let sendVerifySms_URL = "/app/v3/sms/sendVerifySms"//yanzhengma
public let login_URL = "/app/v3/auth/registerOrLogin"
public let login_DevURL = "/app/v3/mobile/registerDevice"
public let home_URL = "/app/v3/user/home"
public let userInfo_URL = "/app/v3/user/info"
public let kyc_status_URL = "/app/v3/kyc/status"
public let silent_URL = "/app/v3/kyc/liveness/silent"//huotu
public let kyc_init_URL = "/app/v3/kyc/init"//
public let kyc_item_URL = "/app/v3/kyc/item/commit"//item
public let kyc_commit_URL = "/app/v3/kyc/commit"//jieduan
public let kyc_ifsc_URL = "/app/v3/sys/ifsc"//ifsc

public let logout_URL = "/app/v3/auth/logout"//tuichu
public let close_URL = "/app/v3/auth/close"//zhuxiao

public let product_term_URL = "/app/v3/product/term"//huoquedu

public let order_submit_URL = "/app/v3/order/submit"//dingdanshenqing
public let dc_order_submit_URL = "/app/v3/order/userSubmit"//dc
public let product_device_URL = "/app/v3/mobile/device"//zhuaqu shoujixinxi
public let product_contact_URL = "/app/v3/mobile/contact"//zhuaqu tongxunlu

public let order_ready_URL = "/app/v3/order/ready"//jieguo

public let order_list_URL = "/app/v3/order/list"//
public let order_detail_URL = "/app/v3/order/detail"//orderDetail

public let bankcard_modify_URL = "/app/v3/bankcard/modify"//changebank

public let repay_connect_URL = "/app/v3/order/repay/connect"//huankuan
public let repay_extension_URL = "/app/v3/order/repay/extension"//zhanqi
public let repay_withdrawal_URL = "/app/v3/order/apply/withdrawal"//tixian

public let bankcard_list_URL = "/app/v3/bankcard/list"//banklist

public let app_version_URL = "/app/v3/app/version"
public let app_bury_URL = "/app/v3/bury/record"//maidian

public let app_province_URL = "/app/v3/sys/province"//sheng
public let app_city_URL = "/app/v3/sys/city"//city
public let app_bank_URL = "/app/v3/sys/bank"

public let sys_upload = "/app/v3/sys/upload"
public let user_problemFeedback = "/app/v3/user/problemFeedback"
public let user_carouselData = "/app/v3/user/carouselData"
public let app_channel = "/app/v3/app/channel"
public let user_signIn = "/app/v3/user/signIn"
public let user_demand = "/app/v3/user/demand"
public let withdrawn_detail = "/app/v3/order/withdrawn/detail"

public let dc_home = "/app/v3/user/suphome"
public let dc_product = "/app/v3/product/list"
public let ab_setting = "/app/v3/app/settings"

public let front_bank = "/app/v3/bankcard/indiabank"
public let front_ifscForBank = "/app/v3/bankcard/indiabankinfo"
public let front_collection = "/app/v3/bankcard/collection"
public let front_collectionList = "/app/v3/bankcard/myindiabank"

public let phoneErrorText = appArea == .en ? "Please enter correct phone number" : "Ingrese el public número de teléfono correcto por favor"
public let loginXYText = "I have read and accepted privacy policy and service agreement"
public let sqXYText = "l have read and agreed with the Terms of the loans"
public let loginCodeSend = appArea == .en ? "OTP has been sent" : "Se ha enviado el código de public verificación"
public let SnetError = appArea == .en ? "Internet connection failed,please try again later" : "La public conexión a Internet falló, inténtalo de nuevo más tarde."
public let ScodeErrorText = appArea == .en ? "Please enter correct OTP" : "Ingrese el código de public verificación correcto por favor"
public let SloginxyErrorText = appArea == .en ? "Please read and accept Privacy Policy first" : "Por favor, lea y acepte Política de Privacidad"
public let WrongFormatAlertText  = appArea == .en ? " is empty or in an incorrect format." : " public formato incorrecto"//geshi
public let noEeMailText  = appArea == .en ? "Please enter your Email" : "Por favor, introduce tu public correo electrónico."//email
public let eMailAlertText  = appArea == .en ? "Please enter correct email" : "Por favor ingrese el public correo electrónico correcto"
public let BookNameAlertText = appArea == .en ? "You can not leave your name section empty" : "No public puedes dejar la sección de tu nombre vacía"//bookName
public let BookPhoneAlertText  = appArea == .en ? "The contact phone number is invalid, please public check." : "El número de teléfono de este contacto es inválido, revíselo por public favor."//bookphone
public let BookRepeatAlertText  = appArea == .en ? "The contact has been submitted, please enter public another contact." : "El contacto ha sido utilizado, por favor ingrese otro public contacto."//bookchongfu
public let IdCardAlertText  = appArea == .en ? "Please upload your Aadhaar" : "Cargue su documento public de identidad por favor"//shangchuan idcard
public let panAlertText = "Please upload your PAN"
public let TermsLoansAlertText = appArea == .en ? "Please agree to the loan agreement" : "Por public favor, lea y acepte Acuerdo de préstamo"//daikuanxieyi
public let StarErrorText = appArea == .en ? "Please rate the app" : "Por favor califica la public aplicación"
public let RateErrorText = "Please rate before confirming. Thanks!"
public let feedSucText = appArea == .en ? "Thanks for your feedback！" : "Gracias por tus public comentarios"
public let feedbackTextViewErrorText = appArea == .en ? "Please enter 'Your Question'" : "Ingrese public por favor 'Su pregunta'"
public let feedbackPhoneErrorText = appArea == .en ? "'Your Phone Number'\(WrongFormatAlertText)" : "'Tu número de teléfon'\(WrongFormatAlertText)"
public let feedbackwhatsappErrorText = "Please enter the correct whatsapp"
public let loginCodeAgainText = appArea == .en ? "Reacquire" : "Readquirir"
public let emailText = appArea == .en ? "E-Mail" : "correo"
public let guanxiText = appArea == .en ? "Relationship" : "Relación"
public let shengText =  appArea == .en ? "Province" : "Provincia"
public let cityText =  appArea == .en ? "City" : "Ciudad"
public let bankText = appArea == .en ? "Bank" : "Nombre de cuenta"
public let emailPlaceholderText = appArea == .en ? "Enter your E-mail" : "Ingrese por favor correo"
public let bankNoSameText = "Bank Account Numbers do not match"

public let faceTitle = appArea == .en ? "Face identification" : "Reconocimiento facial"
public let idcardTitle = appArea == .en ? "Aadhaar" : "Información de identidad"
public let personalTitle = appArea == .en ? "Personal Information" : "Información personal"
public let workTitle = appArea == .en ? "Work Information" : "Información de trabajo"
public let contactTitle = appArea == .en ? "Emergency Contact" : "Contacto emergente"
public let accountTitle = appArea == .en ? "Bank Information" : "Cuenta Bancaria"
public let changeBankTitle = appArea == .en ? "Change Bank Account" : "Cambiar la tarjeta bancaria"
public let bankTitle =  appArea == .en ? "Bank information" : "Información De Tarjeta Bancaria"
 
public let lianxiwomenTitle = appArea == .en ? "Contact us" : "Mantenga en contacto con nosotros"
public let yinsixieyiTitle = appArea == .en ? "Privacy Policy" : "Política de Privacidad"
public let daikuanxieyiTitle = appArea == .en ? "Terms of the loan" : "Acuerdo de préstamo"
public let panFootINTipText = "अगर जानकारी गलत है तो कृपया पैन की तस्वीर दोबारा लें और अपलोड करें"
public let panfootEnTipText = "If the information is wrong, please re-take and upload the front of public the PAN"
public enum adjustType {
    case Aadhaar, Account, Apply, Contact, Info, Job, Liveness, Loan, Register, Pan, Question, defult

    var str:String {
        switch self {
        case .Aadhaar:
            return "ffed1l"
        case .Account:
            return "yex3g2"
        case .Apply:
            return "ybaips"
        case .Contact:
            return "1vftcu"
        case .Info:
            return "djiueb"
        case .Job:
            return "mpqe0j"
        case .Liveness:
            return "nuigb4"
        case .Loan:
            return "zf7o06"
        case .Register:
            return "64sq23"
        case .Pan:
            return "kagqta"
        case .Question:
            return "ttj27a"
        case .defult:
            return ""
        }
    }
}

public enum kycIdType:String, ConvertibleEnum {
    case liveness = "liveness"
    case identity = "identity"
    case tax = "tax"
    case personal = "personal"
    case work = "work"
    case urgent_contact = "urgent_contact"
    case questionnaire = "questionnaire"
    case pay_account = "pay_account"
    case ifsc = "ifsc"
    case changebank = "changebank"
    case none = ""
    case end = "end"
}

public let HomeUserTipDic = [10:"Por favor, completa la certificación KYC antes de utilizar nuestro préstamo.",20:"Por favor, envía la solicitud y nuestro equipo iniciará rápidamente el proceso de revisión.",30:"Nuestro proceso de envío de datos es rápido y sencillo.",32:"Tiene una orden de retiro pendiente y necesitamos su confirmación. Una vez confirmado, transferiremos los fondos a su cuenta bancaria de inmediato.",41:"La información de tu tarjeta bancaria no puede recibir el préstamo. Por favor, actualízala rápidamente para garantizar un desembolso oportuno.",50:"Tu solicitud de préstamo está siendo revisada. Proporcionaremos retroalimentación oportuna una vez que se complete la revisión.",51:"Su solicitud de préstamo no puede ser aprobada. Vuelva a presentar la solicitud después de ",70:"El préstamo se desembolsará pronto en tu cuenta receptora. Por favor, supervisa el estado del pedido de inmediato.",80:"Por favor, realiza el pago a tiempo según la fecha de pago proporcionada por el sistema. Mantener un buen historial crediticio continuará aumentando tu límite de préstamo.",81:"Esta orden no se ha saldado a tiempo y ahora está acumulando cargos por demora. Por favor, realiza el pago lo antes posible para evitar cargos adicionales."]
public let HomeBtnDic = [10:"Solicitar",20:"Solicitar ahora",30:"Continuar sometiendo", 32:"Retirar", 41:"Cambiar tarjera bancaria",50:"Está en revisión",51:"Rechazado",70:"Está desembolsando",80:"Reembolso",81:"Reembolso"]//only one
public let DdStatusTipDic = appArea == .en ? [10:"Our data submission process is fast and simple.", 30:"In the loan processing, the final approved amount depends on your credit assessment. Maintaining a good credit record can increase the approved loan amount.", 31:"Your loan application can not be approved.", 32:"You have a pending withdrawal order, and we need your confirmation. Once confirmed, we will transfer the funds to your bank account immediately.", 36:"Your bank card information is unable to receive the loan. Please update it promptly to ensure timely disbursement.", 50:"The loan will soon be disbursed to your receiving account. Please monitor the order status promptly.", 60:"Please repay on time according to the repayment date provided by the system. Maintaining good credit will continue to increase your loan limit.", 61:"This order has not been settled on time and is now accruing late fees. Please repay as soon as possible to avoid additional charges.", 70:"This order has been successfully settled. You can now apply for a new loan with a higher amount.", 99:"Your order has been canceled. If you need assistance, please contact customer service."] : [10:"Nuestro proceso de envío de datos es rápido y sencillo.",30:"En proceso de tramitación del préstamo, el monto final aprobado dependerá de su evaluación crediticia. Mantener un buen historial crediticio puede aumentar el monto aprobado del préstamo.",31:"Su solicitud de préstamo no puede ser aprobada.",32:"Tiene una orden de retiro pendiente y necesitamos su confirmación. Una vez confirmado, transferiremos los fondos a su cuenta bancaria de inmediato.",36:"La información de tu tarjeta bancaria no puede recibir el préstamo. Por favor, actualízala rápidamente para garantizar un desembolso oportuno.",50:"El préstamo se desembolsará pronto en tu cuenta receptora. Por favor, supervisa el estado del pedido de inmediato.",60:"Por favor, realiza el pago a tiempo según la fecha de pago proporcionada por el sistema. Mantener un buen historial crediticio continuará aumentando tu límite de préstamo.",61:"Esta orden no se ha saldado a tiempo y ahora está acumulando cargos por demora. Por favor, realiza el pago lo antes posible para evitar cargos adicionales.",70:"Esta orden se ha saldado con éxito. Ahora puedes solicitar un nuevo préstamo con un monto más alto.",99:"Su pedido ha sido cancelado. Si necesita ayuda, por favor contacte con servicio al cliente."]
public let DdStatusUPI15Tip = "UPI is valid for 15 minutes. To  avoid your loss, please use the new link generated by the repayment button to repay."
public let SJINCameraAlertText = appArea == .en ? "Please allow \(AppName) to access camera in the settings so that you can take photos" : "Permita que \(AppName) acceda a la cámara en la configuración para que pueda tomar fotos."
public let locationAlertText = appArea == .en ? "Please allow \(AppName) to access location in the settings so that you can complete the loan application" : "Permita que \(AppName) acceda a la ubicación en la configuración para que pueda completar la solicitud de préstamo."
public let AlocationAlertText = "Please allow \(AppName) to access location in settings."
public let ContactsAlertText = appArea == .en ? "\(AppName) needs to access your contacts to perform fraud detection. This process helps us verify your identity and ensure the security of your account. We attach great importance to your privacy, and your contact information will be uploaded to our server, but will not be stored or shared with third parties. You can change your authorization at any time in the settings." : "\(AppName) necesita acceder a sus contactos para realizar la detección de fraude. Este proceso nos ayuda a verificar su identidad y garantizar la seguridad de su cuenta. Damos gran importancia a su privacidad y su información de contacto se cargará en nuestro servidor, pero no se almacenará ni se compartirá con terceros. Puede cambiar su autorización en cualquier momento en la configuración."
public let AContactsAlertText = "Please allow \(AppName) to access the contacts in the settings."
public let SJINProvinciaAlertText = appArea == .en ? "Please choose Province of residence" : "Elija por favor Provincia donde reside"
public let signOutText = appArea == .en ? "When you have an uncompleted loan order, you cannot cancel the account. After confirming the cancellation, the account will not be restored. Please operate with caution" : "Cuando tiene una orden de préstamo incompleta, no puede cancelar la cuenta.Después de confirmar la cancelación, la cuenta no será restaurada.Por favor opere con precaución"
public let signOutSucText = appArea == .en ? "Account cancelled successfully" : "Cuenta cancelada con éxito"
public let signOutFalText = appArea == .en ? "Account cancellation failed, please check your order" : "Puntas:\nLa cancelación de la cuenta falló, verifique su orden de préstamo"
public let AsignOutFalText = "Account cancellation failed"
public let bankNubFalseText = appArea == .en ? "The bank account is invalid, please check" : "El número de tarjeta bancaria es inválido, revísalo por favor."
public let withdrawText = appArea == .en ? "You have a pending withdrawal order, and we need your confirmation. Once confirmed, we will transfer the funds to your bank account immediately." : "Tienes una orden para ser retirada. Después de ingresar a la página para confirmar, los fondos se transferirán a su cuenta bancaria de inmediato."
public let childrenText = appArea == .en ? "Number of children" : "Número de hijos"
public let nameText = appArea == .en ? "Name" : "nombre"
public let bankAccText = appArea == .en ? "Bank Account" : "Número de"

public let sqsjText = appArea == .en ? "Date of application" : "Fecha de solicitud"
public let fksjText = appArea == .en ? "Payment date" : "Fecha de desembolso"
public let dqsjText = appArea == .en ? "Due date" : "Fecha de vencimiento"
public let jqsjText = appArea == .en ? "Repayment date" : "Fecha de reembolso"
public let sqOneText = appArea == .en ? "Loan amount" : "Monto de préstamo"
public let sqMoreText = appArea == .en ? "Please select loan amount manually" : "Seleccione el monto del préstamo manualmente"

public let orderDetailTenText = appArea == .en ? "Continue submitting" : "Continuar sometiendo"
public let orderDetailchangeBankText = appArea == .en ? "Change Bank Account" : "Cambiar tarjeta bancaria"
public let orderDetailHuankuanText = appArea == .en ? "Repayment" : "Reembolso"
public let yuqifeiText = appArea == .en ? "Late charge" : "Pago de demora"
public let totalRepaymentText = appArea == .en ? "Total repayment" : "Reembolso total"
public let jianmianText = appArea == .en ? "Amount of deduction" : "Monto exento"
public let yihuanText = appArea == .en ? "Amount repaid" : "Monto reembolsado"
public let yinghuanText = appArea == .en ? "Amount due" : "Monto por reembolsar"
public let zhanqiText = appArea == .en ? "Deferment charge" : "Tarifa de reinversión"
public let bankFootText = "Please enter correct, available, unfrozen bank account information for the loan to be credited."

public let copySucText = appArea == .en ? "Copied successfully" : "Copiado exitosamente"

public let typeDic = appArea == .en ? [10:"Unfinished Application", 30:"Under Review", 31:"Reject", 36:"Change Bank Account", 50:"Loan processing", 60:"Repayment", 61:"Overdue", 70:"Pay off", 99:"Cancel"] : [10:"Solicitud Incompleta", 30:"Está en revisión", 31:"Rechazado", 36:"Cambiar la tarjeta bancaria", 50:"Está en desembolso", 60:"Reembolso", 61:"Se ha demorado", 70:"Liquidado", 99:"Cancelado"]//, 32:"To be withdrawn", es 32:"Para ser retirado"
public let notificationCancelApply = Notification.Name("cancelApply")

public let navHeight = UIApplication.shared.statusBarFrame.height + 44

public enum buryName {
    case none,firstOpenApp, openLoginPage, loginCode, loginLoginButtonAction, homebuttonclick, livenessStartBtnAction, livenessCameraAlert, livenessCameraAlertSucc, livenessCameraAlertFail, livenessSetCAlert, livenessSetCAlertAction, livenessCameraShow, livenessCameraTakePhoto, taxSelected, taxSelectedCamera, taxCameraAlert, taxCameraAlertSucc, taxCameraAlertFail, taxCameraSettingAlert, taxCameraSetAlertAction, idfSelected, idfSelectedCamera, idfCameraAlert, idfCameraAlertSucc, idfCameraAlertFail, idfCameraSettingAlert, idfCameraSetAlertAction, idfPhotoPage, idfPhotoPageSelImg, idbSelected, idbSelectedCamera, idbCameraAlert, idbCameraAlertSucc, idbCameraAlertFail, idbCameraSettingAlert, idbCameraSetAlertAction, idbPhotoPage, idbPhotoPageSelImg, baseCameraPage, baseCameraPBackA, baseCameraTakePhoto, baseCameraPhotoSure, baseCameraPhotoAgain, taxPhotoPage, taxPhotoPageSelImg, fullpersonalinfo, personalinfobutton, fullworkinfo, workinfobutton, contactinfo, contactinfobutton, accountinfo, accountinfobutton, qusestioninfo, qusestioninfobutton, autoApply, productAmountChanged, productAmountAdd, productAmountReduce, productermChanged, productApplyAction, productLocationAlert, productLocationSucc, productLcaAlertFail, productLcaSetAlt, productLcaSetAltAct, productLcaUpdateSucc, productLcaUpdateFail, productAddressAlert, productAddressSetAltAct, productAddressSetAlt, productAddressAlertFail, productAddressUpdateSucc
    
    var buryStr:String {
        switch self {
        case .none:
            return ""
        case .firstOpenApp:
            return "firstOpenApp"
        case .openLoginPage:
            return "openLoginPage"
        case .loginCode:
            return "loginCode"
        case .loginLoginButtonAction:
            return "loginLoginButtonAction"
        case .homebuttonclick:
            return "homebuttonclick"
        case .livenessStartBtnAction:
            return "livenessStartBtnAction"
        case .livenessCameraAlert:
            return "livenessCameraAlert"
        case .livenessCameraAlertSucc:
            return "livenessCameraAlertSucc"
        case .livenessCameraAlertFail:
            return "livenessCameraAlertFail"
        case .livenessSetCAlert:
            return "livenessSetCAlert"
        case .livenessSetCAlertAction:
            return "livenessSetCAlertAction"
        case .livenessCameraShow:
            return "livenessCameraShow"
        case .livenessCameraTakePhoto:
            return "livenessCameraTakePhoto"
        case .taxSelected:
            return "taxSelected"
        case .taxSelectedCamera:
            return "taxSelectedCamera"
        case .taxCameraAlert:
            return "taxCameraAlert"
        case .taxCameraAlertSucc:
            return "taxCameraAlertSucc"
        case .taxCameraAlertFail:
            return "taxCameraAlertFail"
        case .taxCameraSettingAlert:
            return "taxCameraSettingAlert"
        case .taxCameraSetAlertAction:
            return "taxCameraSetAlertAction"
        case .idfSelected:
            return "idfSelected"
        case .idfSelectedCamera:
            return "idfSelectedCamera"
        case .idfCameraAlert:
            return "idfCameraAlert"
        case .idfCameraAlertSucc:
            return "idfCameraAlertSucc"
        case .idfCameraAlertFail:
            return "idfCameraAlertFail"
        case .idfCameraSettingAlert:
            return "idfCameraSettingAlert"
        case .idfCameraSetAlertAction:
            return "idfCameraSetAlertAction"
        case .idfPhotoPage:
            return "idfPhotoPage"
        case .idfPhotoPageSelImg:
            return "idfPhotoPageSelImg"
        case .idbSelected:
            return "idbSelected"
        case .idbSelectedCamera:
            return "idbSelectedCamera"
        case .idbCameraAlert:
            return "idbCameraAlert"
        case .idbCameraAlertSucc:
            return "idbCameraAlertSucc"
        case .idbCameraAlertFail:
            return "idbCameraAlertFail"
        case .idbCameraSettingAlert:
            return "idbCameraSettingAlert"
        case .idbCameraSetAlertAction:
            return "idbCameraSetAlertAction"
        case .idbPhotoPage:
            return "idbPhotoPage"
        case .idbPhotoPageSelImg:
            return "idbPhotoPageSelImg"
        case .baseCameraPage:
            return "baseCameraPage"
        case .baseCameraPBackA:
            return "baseCameraPBackA"
        case .baseCameraTakePhoto:
            return "baseCameraTakePhoto"
        case .baseCameraPhotoSure:
            return "baseCameraPhotoSure"
        case .baseCameraPhotoAgain:
            return "baseCameraPhotoAgain"
        case .taxPhotoPage:
            return "taxPhotoPage"
        case .taxPhotoPageSelImg:
            return "taxPhotoPageSelImg"
        case .fullpersonalinfo:
            return "fullpersonalinfo"
        case .personalinfobutton:
            return "personalinfobutton"
        case .fullworkinfo:
            return "fullworkinfo"
        case .workinfobutton:
            return "workinfobutton"
        case .contactinfo:
            return "contactinfo"
        case .contactinfobutton:
            return "contactinfobutton"
        case .accountinfo:
            return "accountinfo"
        case .accountinfobutton:
            return "accountinfobutton"
        case .qusestioninfo:
            return "qusestioninfo"
        case .qusestioninfobutton:
            return "qusestioninfobutton"
        case .autoApply:
            return "autoApply"
        case .productAmountChanged:
            return "productAmountChanged"
        case .productAmountAdd:
            return "productAmountAdd"
        case .productAmountReduce:
            return "productAmountReduce"
        case .productermChanged:
            return "productermChanged"
        case .productApplyAction:
            return "productApplyAction"
        case .productLocationAlert:
            return "productLocationAlert"
        case .productLocationSucc:
            return "productLocationSucc"
        case .productLcaAlertFail:
            return "productLcaAlertFail"
        case .productLcaSetAlt:
            return "productLcaSetAlt"
        case .productLcaSetAltAct:
            return "productLcaSetAltAct"
        case .productLcaUpdateSucc:
            return "productLcaUpdateSucc"
        case .productLcaUpdateFail:
            return "productLcaUpdateFail"
        case .productAddressAlert:
            return "productAddressAlert"
        case .productAddressSetAlt:
            return "productAddressSetAlt"
        case .productAddressSetAltAct:
            return "productAddressSetAltAct"
        case .productAddressAlertFail:
            return "productAddressAlertFail"
        case .productAddressUpdateSucc:
            return "productAddressUpdateSucc"
        }
    }
}

public func getGuanxiAlertText(_ x: Int) -> String {
    return  appArea == .en ? "Contact \(x/10) - 'Relationship' not selected. Please choose before submitting." : "Contacto \(x/10) - 'Relación' no seleccionada. Por favor, elige antes de enviar."
}
public func getBookAlertText(_ x: Int) -> String {
    return appArea == .en ? "Contact \(x/10) - Please add your emergency contacts." : "Contacto \(x/10) - Por favor, añade tus contactos de emergencia."
}

