//
//  SJINPck.swift
//  SJIN
//
//  Created by fengyuan on 2024/5/30.
//

import UIKit
import SnapKit
import QMUIKit



let appArea = AppArea.en

enum AppArea {
    case es, en
}
var ClientLanguage : String {
    switch appArea {
        case .es:
            return "es"
        case .en:
            return "en"
        }
}

var areaCode : String {
    switch appArea {
        case .es:
            return "52"
        case .en:
            return "91"
        }
}

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let bottomSafeHeight = UIApplication.shared.statusBarFrame.height>20 ? -34.0 : 0.0


func FontMedium(_ size:CGFloat) -> UIFont{
    return .init(name: "Ubuntu-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
}

func FontRegular(_ size:CGFloat) -> UIFont{
    return .init(name: "Ubuntu-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
}

func FontLight(_ size:CGFloat) -> UIFont {
    return .init(name: "Ubuntu-Light", size: size) ?? .systemFont(ofSize: size, weight: .light)
}

func FontBold(_ size:CGFloat) -> UIFont{
    return .init(name: "Ubuntu-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
}

func FontBlack(_ size:CGFloat) -> UIFont{
    return .systemFont(ofSize: size, weight: .black)
}

func FontSemibold(_ size:CGFloat) -> UIFont{
    return .init(name: "Ubuntu-Bold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
}

func FontPfNomal(_ size:CGFloat) -> UIFont{
    return .init(name: "PingFangSC-Regular", size: size) ?? .systemFont(ofSize: size, weight: .medium)
}

func FontPfMedium(_ size:CGFloat) -> UIFont{
    return .init(name: "PingFangSC-Medium", size: size) ?? .systemFont(ofSize: size, weight: .black)
}

func FontPfSemibold(_ size:CGFloat) -> UIFont{
    return .init(name: "PingFangSC-Semibold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
}

func getWidthForText(_ text: String, font: UIFont, horizontalPadding: CGFloat) -> CGFloat {
    let label = UILabel()
    label.text = text
    label.font = font
    label.sizeToFit()
    let totalWidth = label.frame.width + 2 * horizontalPadding
    return totalWidth
}

func sjin_setLineSpacing(l:UILabel, t:String, lineSpacing:CGFloat = 5, alignment:NSTextAlignment = .center) {
    let attributedString = NSMutableAttributedString(string: t)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
    l.attributedText = attributedString
    l.numberOfLines = 0
    l.lineBreakMode = .byWordWrapping
    l.textAlignment = alignment
}

func sjin_setAttributedString(t:String,i:String? = nil, size:CGSize = CGSizeMake(9, 6), imageSpacing: Int = 6, lineSpacing:CGFloat = 5, alignment:NSTextAlignment = .center) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: t)
    if i != nil {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: i ?? "")
        let imageBounds = CGRect(origin: .zero, size: size)
        imageAttachment.bounds = imageBounds
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(NSAttributedString(string: " ".padding(toLength: imageSpacing, withPad: " ", startingAt: 0)))
        attributedString.append(imageString)
    }
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
    return attributedString
}

func sjin_setImageLabel(l:UILabel, t:String,i:String? = nil, size:CGSize = CGSizeZero, lineSpacing:CGFloat = 5, alignment:NSTextAlignment = .left, imageSpacing: Int = 2, isChange:Bool = false, feedLine:Bool = false) {
    let attributedString = NSMutableAttributedString(string: t)
    if i != nil {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: i ?? "")
        let imageBounds = CGRect(origin: .zero, size: size)
        imageAttachment.bounds = imageBounds
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(NSAttributedString(string: feedLine ? "\n\n" : " ".padding(toLength: imageSpacing, withPad: " ", startingAt: 0)))
        attributedString.append(imageString)
        if isChange {
            let baselineOffset = (l.font.capHeight - size.height) / 2 - l.font.descender
            imageAttachment.bounds.origin.y = baselineOffset
        }
    }
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
    l.attributedText = attributedString
    l.numberOfLines = 0
    l.lineBreakMode = .byCharWrapping
    l.textAlignment = alignment
}

import Foundation
import CommonCrypto

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    var thousandString: String {
        let numString = "\(self)"
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        formatter.groupingSize = 3
        formatter.minimumFractionDigits = self.hasSuffix(".00") ? 2 : 0
        guard let number = formatter.number(from: numString) else {
            return numString
        }
        return formatter.string(from: number) ?? numString
    }
    
    func checkWith(predicate:String) -> Bool{
        let pre = NSPredicate(format:"SELF MATCHES %@", predicate)
        return pre.evaluate(with: self)
    }

    func boundingRect(for font: UIFont, constrained size: CGSize, lineSpacing: CGFloat = 0) -> CGRect {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.lineSpacing = lineSpacing
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraph
        ]
        return self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: attributes, context: nil)
    }
    
    func view<T: UIView>() -> T {
        return UINib(nibName: self, bundle: nil).nibView()
    }

}

public extension UINib {
    func nibView<T: UIView>() -> T {
        return instantiate(withOwner: T.self).filter({ $0 is T }).first as! T
    }
}


extension UIImage {
    class func imageOriginal(name:String) -> UIImage? {
        return self.init(named: name)?.withRenderingMode(.alwaysOriginal)
    }
}

extension UILabel {
    convenience init(backgroundColor:UIColor? = .clear, borderColor:UIColor = .clear, borderWidth: CGFloat = 0.0, cornerRadius:CGFloat = 0, font: UIFont = UIFont.systemFont(ofSize: 16), color: UIColor = UIColor.black, alignment: NSTextAlignment = .left, titleString: String = "", textSpacing:CGFloat = 0, numberLines:Int = 1, _ lineMode:NSLineBreakMode = .byWordWrapping, tag:Int = 0) {
        self.init()
        self.font = font
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.tag = tag
        text = titleString
        textColor = color
        textAlignment = alignment
        numberOfLines = numberLines
        lineBreakMode = lineMode
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        if textSpacing > 0 { self.textSpacing = textSpacing }
    }

    private struct AssociatedKeys {
        static var textSpacingKey = UnsafeRawPointer(bitPattern: "textSpacingKey".hashValue)
    }
    @IBInspectable var textSpacing: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.textSpacingKey) as? CGFloat ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.textSpacingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            numberOfLines = 0
            lineBreakMode = .byWordWrapping
            self.labelTextSpacing()
        }
    }
    private func labelTextSpacing() {
        let attributedString: NSMutableAttributedString
        if let attributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        } else if let text = text, !text.isEmpty {
            attributedString = NSMutableAttributedString(string: text)
        } else {
            return
        }
        guard textSpacing > 0,let font = self.font, let textColor = self.textColor else { return }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = textSpacing
        style.alignment = textAlignment
        attributedString.addAttributes([ .font: font, .foregroundColor: textColor, .paragraphStyle: style], range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
}

extension UIStackView {
    convenience init(axis:NSLayoutConstraint.Axis = .vertical, distribution:UIStackView.Distribution = .fill, spacing:CGFloat = 0) {
        self.init(arrangedSubviews: [])
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
}


private var placeholderColorKey: UInt8 = 0
private var placeholderFontKey: UInt8 = 0
@IBDesignable
extension UITextField {
    convenience init(backgroundColor:UIColor? = .clear, cornerRadius:CGFloat = 0, borderColor:UIColor = .clear, borderWidth: CGFloat = 0.0, titleFont: UIFont = .systemFont(ofSize: 16), titleColor: UIColor = .black, titleString: String = "", placeFont: UIFont = .systemFont(ofSize: 16), placeColor: UIColor = .gray, placeString: String = "", keyboardType:UIKeyboardType = .default, textAlignment: NSTextAlignment = .left, leftPading:CGFloat = 0.0, rightPading: CGFloat = 0.0) {
        self.init()
        self.borderStyle = .none
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.font = titleFont
        self.keyboardType = keyboardType
        self.textColor = titleColor
        self.attributedPlaceholder = NSAttributedString.init(string: placeString, attributes: [.foregroundColor: placeColor, .font: placeFont])
        self.textAlignment = textAlignment
        self.leftPading = leftPading
        self.rightPading = rightPading
    }
    
    @IBInspectable var leftPading:CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            let leftV = UIView(frame: frame)
            self.leftViewMode = .always
            self.leftView = leftV
        }
        get {
            self.leftPading
        }
    }
    @IBInspectable var rightPading:CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            let rightV = UIView(frame: frame)
            self.rightViewMode = .always
            self.rightView = rightV
        }
        get {
            self.rightPading
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &placeholderColorKey) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &placeholderColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let color = newValue {
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
            }
        }
    }
    @IBInspectable var placeholderFont: CGFloat {
        get {
            return 0
        }
        set {
            if let placeholder = self.placeholder, let font = self.font {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.font: font.withSize(newValue)])
            }
        }
    }
}


import UIKit
import Contacts

@IBDesignable
extension UIView {
    convenience init(backgroundColor: UIColor? = .clear, cornerRadius: CGFloat = 0.0, borderColor:UIColor = .clear, borderWidth: CGFloat = 0.0, isHidden:Bool = false) {
        self.init()
        self.backgroundColor = backgroundColor
        self.cornerRadius =  cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.isHidden = isHidden
    }
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
        get {
            return layer.cornerRadius
        }
    } 
    
    func addShadow(width: CGFloat, height: CGFloat, color: UIColor, opacity: Float, radius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: width, height: height)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    func sjin_setCorners(_ corners:UIRectCorner, _ radius:CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let masLayer = CAShapeLayer()
        masLayer.frame = self.bounds
        masLayer.path = maskPath.cgPath
        self.layer.mask = masLayer
    }
    
    func sjin_setGradientBackground(startColor: UIColor, endColor: UIColor, directionIsHorizontal:Bool = true) {
        let cornerRadius = layer.cornerRadius
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = directionIsHorizontal ? CGPoint(x: 0, y: 0.5) : CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = directionIsHorizontal ? CGPoint(x: 1, y: 0.5) : CGPoint(x: 0.5, y: 1)
        gradientLayer.cornerRadius = cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func sjin_removeGradientBackground(color: UIColor) {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        backgroundColor = color
    }
    
    func sjin_addDashedBorder(_ isBorder: Bool = false, color: UIColor, _ thickness: CGFloat = 1, _ spacing: NSNumber = 4, _ length: NSNumber = 4) {
        self.layer.sublayers?.filter({ $0 is CAShapeLayer }).forEach({ $0.removeFromSuperlayer() })
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = thickness
        shapeLayer.lineDashPattern = [spacing, length]
        if isBorder {
            shapeLayer.fillColor = UIColor.clear.cgColor
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
            shapeLayer.path = path.cgPath
        } else {
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: bounds.height / 2), CGPoint(x: bounds.width, y: bounds.height / 2)])
            shapeLayer.path = path
        }
        layer.insertSublayer(shapeLayer, at: 0)
    }
    
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func drawCircularProgressBar(nomalColor: UIColor, selectColor: UIColor, lineWidth: CGFloat, maxValue: Float, selectValue: Float) {
        self.layer.sublayers = nil
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: (bounds.width - lineWidth) / 2, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true).cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = nomalColor.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 1.0
          
        self.layer.addSublayer(shapeLayer)
          
        if selectValue > 0 {
            let selectLayer = CAShapeLayer()
            selectLayer.frame = self.bounds
            selectLayer.path = shapeLayer.path
            selectLayer.lineWidth = lineWidth
            selectLayer.strokeColor = selectColor.cgColor
            selectLayer.fillColor = nil
            selectLayer.lineCap = .round
              
            let selectRatio = CGFloat(selectValue) / CGFloat(maxValue)
            selectLayer.strokeEnd = selectRatio
              
            self.layer.addSublayer(selectLayer)
        }
    }
    
    func addLabels(labels: [String], labelHeight: CGFloat = 20, padding: CGFloat = 5, backgroundColor:UIColor = .clear, borderColor: UIColor = .clear, borderWidth: CGFloat = 0.0, cornerRadius:CGFloat = 0, font: UIFont = UIFont.systemFont(ofSize: 16), textColor:UIColor = UIColor.black, alignment: NSTextAlignment = .center, textSpacing:CGFloat = 0, labelPadding:CGFloat = 5) {
            var lastLabel: QMUILabel?
            var rowIndex = 0
            var rowWidth: CGFloat = 0
            let maxWidth = bounds.width
            
            for (index, labelText) in labels.enumerated() {
                let label = QMUILabel(backgroundColor: backgroundColor, borderColor: borderColor, borderWidth: borderWidth, cornerRadius: cornerRadius, font: font, color: textColor, alignment: alignment, titleString: labelText, textSpacing:textSpacing)
                label.contentEdgeInsets = UIEdgeInsets(top: 0, left: labelPadding, bottom: 0, right: labelPadding)
                self.addSubview(label)
                
                let labelWidth = getWidthForText(labelText, font: font, horizontalPadding: labelPadding)
                let moreHeight = labelText.boundingRect(for: font, constrained: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), lineSpacing: textSpacing).height
                if labelWidth > maxWidth {
                    label.numberOfLines = 0
                    label.textSpacing = textSpacing
                    label.textAlignment = .left
                }
                label.snp.makeConstraints { make in
                    make.height.greaterThanOrEqualTo(labelHeight)
                    if let last = lastLabel {
                        if rowWidth + labelWidth > maxWidth {
                            rowIndex += 1
                            rowWidth = 0
                            make.top.equalTo(last.snp.bottom).offset(padding).priority(.medium)
                            make.left.equalTo(0)
                            if labelWidth > maxWidth { 
                                make.right.equalToSuperview()
                                make.height.equalTo(moreHeight + labelPadding * 2).priority(.high)
                            }
                        } else {
                            make.top.equalTo(last.snp.top)
                            make.left.equalTo(last.snp.right).offset(padding)
                        }
                        rowWidth += labelWidth + padding
                    } else {
                        make.top.equalTo(0)
                        make.left.equalTo(0)
                        rowWidth += getWidthForText(labelText, font: label.font, horizontalPadding: label.contentEdgeInsets.left + label.contentEdgeInsets.right) + padding
                    }
                    
                    if index == labels.count - 1 {
                        make.bottom.equalTo(0).priority(.high)
                    }
                }
                lastLabel = label
            }
        }
    
    var x:CGFloat {
        set{
            frame.origin.x = newValue
        }
        get{
            return frame.origin.x
        }
    }
    var y:CGFloat{
        set{
            frame.origin.y = newValue
        }
        get{
            return frame.origin.y
        }
    }
    var width:CGFloat{
        set{
            frame.size.width = newValue
        }
        get{
            return frame.size.width
        }
    }
    var height:CGFloat{
        set{
            frame.size.height = newValue
        }
        get{
            return frame.size.height
        }
    }
    var centerX:CGFloat{
        set{
            center.x = newValue
        }
        get{
            return center.x
        }
    }
    var centerY:CGFloat{
        set{
            center.y = newValue
        }
        get{
            return center.y
        }
    }
    var maxX:CGFloat{
        get{
            return frame.maxX
        }
    }
    var maxY:CGFloat{
        get{
            return frame.maxY
        }
    }
    var midX:CGFloat{
        get{
            return frame.midX
        }
    }
    var midY:CGFloat{
        get{
            return frame.midY
        }
    }
    var minX:CGFloat{
        get{
            return frame.minX
        }
    }
    var minY:CGFloat{
        get{
            return frame.minY
        }
    }
}

extension UIColor {
    convenience init(hexStr: String, alpha: CGFloat = 1.0) {
        var hexString = hexStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        hexString = hexString.hasPrefix("0x") || hexString.hasPrefix("0X") ? String(hexString.dropFirst(2)) : hexString
        hexString = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString

        guard hexString.count == 6 || hexString.count == 8 else {
            self.init(red: 0, green: 0, blue: 0, alpha: 1.0)
            return
        }

        var start = hexString.startIndex
        let hexR = String(hexString[start..<hexString.index(start, offsetBy: 2)])
        start = hexString.index(start, offsetBy: 2)
        let hexG = String(hexString[start..<hexString.index(start, offsetBy: 2)])
        start = hexString.index(start, offsetBy: 2)
        let hexB = String(hexString[start..<hexString.index(start, offsetBy: 2)])
        
        var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0

        Scanner(string: hexR).scanHexInt64(&r)
        Scanner(string: hexG).scanHexInt64(&g)
        Scanner(string: hexB).scanHexInt64(&b)

        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0

        if hexString.count == 8 {
            start = hexString.index(start, offsetBy: 2)
            let hexA = String(hexString[start..<hexString.index(start, offsetBy: 2)])
            var a: UInt64 = 0
            Scanner(string: hexA).scanHexInt64(&a)
            let alpha = CGFloat(a) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

private var preventContinuousClickKey: UInt8 = 0
extension UIButton {
    convenience init(title: String = "",
                     titleFont: UIFont = UIFont.systemFont(ofSize: 16),
                     titleColor: UIColor? = .black, image: UIImage? = nil, selectedImage:UIImage? = nil, backgroundImage: UIImage? = nil, cornerRadius:CGFloat = 0, backgroundColor: UIColor? = .clear, tag:Int = 0, isHidden:Bool = false, numberOfLines:Int = 1) {
        self.init(type: .custom)
        titleLabel?.font = titleFont
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.textAlignment = .center
        setImage(image, for: .normal)
        setImage(selectedImage, for: .selected)
        setBackgroundImage(backgroundImage, for: .normal)
        setBackgroundImage(backgroundImage, for: .highlighted)
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.isHidden = isHidden
        self.titleLabel?.numberOfLines = numberOfLines
        self.adjustsImageWhenHighlighted = false
        self.tag = tag
    }
    private var preventContinuousClick: Bool {
        get {
            return objc_getAssociatedObject(self, &preventContinuousClickKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &preventContinuousClickKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        guard NSStringFromSelector(action).contains(actionContainsName) else {
            super.sendAction(action, to: target, for: event)
            return
        }
        if preventContinuousClick {
            return
        }
        preventContinuousClick = true
        super.sendAction(action, to: target, for: event)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.preventContinuousClick = false
        }
    }
}

@IBDesignable
class halfButton:UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = bounds.height / 2
    }
}

@IBDesignable
class GYTextField:UITextField, UITextFieldDelegate{
    var itemModel: kycItemListModel?
    private var _maxLength:Int = 200
    @IBInspectable var maxLength:Int {
        set{
            _maxLength = newValue
        }
        get{
            _maxLength
        }
    }
    @IBInspectable var isPhone:Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setInitialize()
    }
    
    func setInitialize() {
        delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = textField.text! as NSString
        let newText = str.replacingCharacters(in: range, with: string)
        if keyboardType == .numberPad {
            let filteredString = newText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            textField.text = filteredString
            if self.isPhone {
                self.maxLength = str.hasPrefix(areaCode) ? 12 : 10
            }
            if filteredString.count > self.maxLength {
                textField.text = String(filteredString.prefix(self.maxLength))
            }
            return false
        }
        if self.isPhone {
            self.maxLength = str.hasPrefix(areaCode) ? 12 : 10
        }
        if newText.count > self.maxLength {
            textField.text = String(newText.prefix(self.maxLength))
            return false
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let m = itemModel {
            guard ![3,4].contains(m.itemType) else {return}
            m.seleteButtonKey = textField.text
        }
    }
}

@IBDesignable
class GYTextView: UITextView, UITextViewDelegate {
      
    @IBInspectable var topMargin: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    @IBInspectable var bottomMargin: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    @IBInspectable var leftMargin: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    @IBInspectable var rightMargin: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
      
    @IBInspectable var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
      
    @IBInspectable var maxInputLength: Int = 1000 {
        didSet {
            updateInputCountLabel()
        }
    }
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = FontMedium(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let inputCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = FontMedium(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let bottomView:UIView = {
        let v = UIView()
        v.isUserInteractionEnabled = false
        return v
    }()
      
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
      
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
      
    private func setup() {
        delegate = self

        addSubview(placeholderLabel)
        addSubview(bottomView)
        addSubview(inputCountLabel)
    }
      
    override func layoutSubviews() {
        super.layoutSubviews()
          
        contentInset = UIEdgeInsets(top: topMargin, left: leftMargin, bottom: bottomMargin + 20, right: rightMargin)
        placeholderLabel.x += leftMargin/3
        placeholderLabel.y += topMargin/3
        bottomView.backgroundColor = backgroundColor
        bottomView.frame = CGRectMake(self.bounds.origin.x + topMargin, self.bounds.origin.y + self.bounds.size.height - 20 - bottomMargin, self.bounds.size.width - leftMargin - rightMargin, 20 + bottomMargin)
        inputCountLabel.frame = CGRectMake(self.bounds.origin.x + topMargin, self.bounds.origin.y + self.bounds.size.height - 20 - bottomMargin, self.bounds.size.width - leftMargin - rightMargin, 20)
    }
      
    func textViewDidChange(_ textView: UITextView) {
        textView.text = String(text.prefix(maxInputLength))
        placeholderLabel.isHidden = !text.isEmpty
        updateInputCountLabel()
    }
      
    private func updateInputCountLabel() {
        let count = text.count
        let maxLength = maxInputLength > 0 ? "/\(maxInputLength)" : ""
        inputCountLabel.text = "\(count)\(maxLength)"
    }
}

func getWindowVc() -> UIViewController? {
    guard let keyWindow = UIApplication.shared.keyWindow, let vc = keyWindow.rootViewController else { return nil }
    return vc
}

func sjin_underLineString(defaultText: String? = nil, underlinedText: String?, underlineColor: UIColor? = nil) -> NSAttributedString? {
    guard let underlinedStr = underlinedText else { return nil }
    
    let fullText = (defaultText ?? "") + underlinedStr
    let attributedText = NSMutableAttributedString(string: fullText)
    
    if let underlineColor = underlineColor {
        let range = (fullText as NSString).range(of: underlinedStr)
        attributedText.addAttribute(.foregroundColor, value: underlineColor, range: range)
    }
    
    let underlinedRange = (fullText as NSString).range(of: underlinedStr)
    attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: underlinedRange)
    
    return attributedText
}

func sjin_setChangeColorString(defaultText: String, changeText:String, color:UIColor, font:UIFont? = nil, lineSpacing:CGFloat = 5, alignment:NSTextAlignment = .center) -> NSAttributedString? {
    let fullText = defaultText + changeText
    let attributedText = NSMutableAttributedString(string: fullText)
    let range = (fullText as NSString).range(of: changeText)
    attributedText.addAttribute(.foregroundColor, value: color, range: range)
    if (font != nil) {
        attributedText.addAttribute(.font, value: font ?? .systemFont(ofSize: 16), range: range)
    }
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.alignment = alignment
    paragraphStyle.lineSpacing = lineSpacing
    attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
    return attributedText
}

func sjin_goURL(_ urlString:String) {
    if let url = URL(string: urlString) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            QMUITips.show(withText:SnetError)
        }
    }
}

func sjin_calculateEMI(loanAmount: Double, annualInterestRate: Double, loanTermInYears: Int, isMonth:Bool = false) -> (monthlyPayment: Float, totalRepayment: Float, totalInterest: Float, monthlyPaymentStr:String, totalRepaymentStr:String, totalInterestStr:String) {
    let monthlyInterestRate = annualInterestRate / 12 / 100
    let numberOfPayments = isMonth ? loanTermInYears : loanTermInYears * 12
    let numerator = loanAmount * monthlyInterestRate * pow(1 + monthlyInterestRate, Double(numberOfPayments))
    let denominator = pow(1 + monthlyInterestRate, Double(numberOfPayments)) - 1
    let monthlyPayment = numerator / denominator
    let totalRepayment = (isMonth ? monthlyPayment : monthlyPayment * 12) * Double(loanTermInYears)
    let totalInterest = totalRepayment - loanAmount
    return (Float(monthlyPayment), Float(totalRepayment), Float(totalInterest), String(format: "%.2f", monthlyPayment), String(format: "%.2f", totalRepayment), String(format: "%.2f", totalInterest))
}

func sjin_FrontGstCalculator(totalAmount: Int, taxSlab: Int, type:Int = 0) -> (totalGST: String, PostGstAmount: String) {
    let t = type == 0 ? totalAmount * taxSlab : totalAmount * taxSlab / (1 + taxSlab)
    let p = type == 0 ? totalAmount * (1 + taxSlab) : totalAmount - t
    let tStr = String(t)
    let pStr = String(p)
    return (tStr, pStr)
}

func sjin_FrontSipCalculator(type:Int, monthlyAmount:Double, totalInvestment:Double, rate:Double, year:Int) -> (investedAmount:Float, totalValue:Float, estReturns:Float, investedAmountStr:String, totalValueStr:String, estReturnsStr:String) {
    let p:Double = monthlyAmount
    let i:Double = rate / 12.0 / 100
    let n:Double = Double(year * 12)
    let principal = type == 0 ? monthlyAmount * 12 * Double(year) : totalInvestment
    let allValue = type == 0 ? (p * (pow(1 + i, n) - 1) / i * (1 + i)) : (totalInvestment * pow(1 + rate / 100.0, Double(year)))
    let est = Float(allValue - Double(principal))
    return (Float(principal), Float(allValue), Float(est), String(format: "%.2f", principal),String(format: "%.2f", allValue), String(format: "%.2f", est))
}

enum cameraFrom {
    case face, pan, idf, idb
}

func sjin_cameraStatus(_ form:cameraFrom = .face, _ block:@escaping (_ granted:Int) -> Void) {
    getOneTool().isWantLeave = false
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    if status == .notDetermined {
        sjin_buryName(form == .pan ? .taxCameraAlert : (form == .face ? .livenessCameraAlert : (form == .idf ? .idfCameraAlert : .idbCameraAlert)))
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                sjin_buryName(form == .pan ? .taxCameraAlertSucc : (form == .face ? .livenessCameraAlertSucc : (form == .idf ? .idfCameraAlertSucc : .idbCameraAlertSucc)))
                block(1)
            } else {
                sjin_buryName(form == .pan ? .taxCameraAlertFail : (form == .face ? .livenessCameraAlertFail : (form == .idf ? .idfCameraAlertFail : .idbCameraAlertFail)))
                block(0)
            }
        }
    } else if status == .restricted || status == .denied {
        block(2)
    } else {
        block(3)
    }
}

func sjin_isFalseCamera() -> Bool {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    if status == .restricted || status == .denied {
        return true
    } else {
        return false
    }
}

func sjin_contactStatus(_ block:@escaping (_ granted:Int) -> Void) {
    getOneTool().isWantLeave = false
    let contactStore = CNContactStore()
    let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
    switch authorizationStatus {
    case .authorized:
        sjin_buryName(.productAddressUpdateSucc)
        block(1)
    case .denied, .restricted:
        sjin_buryName(.productAddressAlertFail)
        block(2)
    case .notDetermined:
        sjin_buryName(.productAddressAlert)
        contactStore.requestAccess(for: .contacts) { granted, _ in
            if granted {
                sjin_buryName(.productAddressUpdateSucc)
                block(1)
            } else {
                sjin_buryName(.productAddressAlertFail)
                block(0)
            }
        }
    @unknown default:
        break
    }
}


class sjin_locationManager : NSObject, CLLocationManagerDelegate {
    typealias GetLongitudeLatitude = (_ longitude:String,_ latitude:String)->Void
    let location = CLLocationManager()
    static let share = sjin_locationManager()
    var getLoaction:GetLongitudeLatitude?
    private var isSystem = false
    private var locationIsBack = false
    func sjin_addressStatus(_ successResult:@escaping GetLongitudeLatitude) {
        getOneTool().isWantLeave = false
        locationIsBack = false
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse, .authorizedAlways:
                location.delegate = self
                location.requestWhenInUseAuthorization()
                location.desiredAccuracy = kCLLocationAccuracyBest
                location.distanceFilter = kCLDistanceFilterNone
                location.startUpdatingLocation()
                break
            case .denied:
                locationIsBack = true
                location.delegate = nil
                sjin_buryName(.productLcaSetAlt)
                if getOneTool().isFalseBook == false {
                    sjin_alertShow("", locationAlertText, {isCancel in
                        if !isCancel { sjin_buryName(.productLcaSetAltAct) }
                        DispatchQueue.main.async {
                            if let getBlock = self.getLoaction{
                                getBlock("","")
                            }
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        if let getBlock = self.getLoaction{
                            getBlock("","")
                        }
                    }
                }
                break
            case .notDetermined:
                sjin_buryName(.productLocationAlert)
                isSystem = true
                location.delegate = self
                location.requestWhenInUseAuthorization()
                location.desiredAccuracy = kCLLocationAccuracyBest
                location.distanceFilter = kCLDistanceFilterNone
                location.startUpdatingLocation()
                break
            default:
                break
            }
        getLoaction = successResult
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            sjin_buryName(.productLocationSucc)
        } else if status == .denied {
            if isSystem == false {
                locationIsBack = true
                if getOneTool().isFalseBook == false {
                    sjin_alertShow("", locationAlertText, {isCancel in
                        DispatchQueue.main.async {
                            if let getBlock = self.getLoaction{
                                getBlock("","")
                            }
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        if let getBlock = self.getLoaction{
                            getBlock("","")
                        }
                    }
                }
            } else {
                sjin_buryName(.productLcaAlertFail)
                isSystem = false
                locationIsBack = true
                if let getBlock = self.getLoaction{
                    getBlock("","")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locationIsBack == true {
            manager.stopUpdatingLocation()
            return
        }
        let one = getOneTool()
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            if self.getLoaction != nil, (one.latitude == "-360" || one.longitude == "-360") {
                one.latitude = "\(latitude)"
                one.longitude = "\(longitude)"
                manager.stopUpdatingLocation()
                DispatchQueue.main.async {
                    if let getBlock = self.getLoaction{
                        getBlock(one.longitude,one.latitude)
                    }
                }
            }
        }
    }
    
}

func sjin_getBookArr() -> [[Any]] {
    let model = getOneTool().configModel
    let per = model?.pushPerCount ?? 100
    let allMaxCount = model?.pushMaxCount ?? 1000
    let arr = DeviceTool.getContactBookData().count > allMaxCount ? Array(DeviceTool.getContactBookData().prefix(allMaxCount)) : DeviceTool.getContactBookData() as! [Any]
    var bookArr = [[Any]]()

    for i in stride(from: 0, to: arr.count, by: per) {
        var subArr: [Any]
        let endIndex = min(i + per, arr.count)
        subArr = Array(arr[i..<endIndex])
        bookArr.append(subArr)
    }
    return bookArr
}

func sjin_alertShow(_ title:String = "", _ message:String = "", _ cancelBlock:@escaping (_ isCancel:Bool) -> Void) {
    if hudCount > 0 {
        hiddenLoading()
    }
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: appArea == .en ? "Cancle" : "Cancelar", style: .cancel) { (action) in
        cancelBlock(true)
    }
    let goToSetting = UIAlertAction(title: appArea == .en ? "Settings" : "Confirmar", style: .destructive) { (action) in
        getOneTool().isWantLeave = true
        if let url = URL(string: UIApplication.openSettingsURLString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        cancelBlock(false)
    }
    alert.addAction(cancel)
    alert.addAction(goToSetting)
    getOneTool().rootVc?.present(alert, animated: true, completion: nil)
}

func sjin_sheetShow(titleA:String, titleB:String, ABlock:@escaping () -> Void, BBlock:@escaping () -> Void) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let cancel = UIAlertAction(title: appArea == .en ? "Cancle" : "Cancelar", style: .cancel) { (action) in
    }
    let a = UIAlertAction(title: titleA, style: .default) { (action) in
        ABlock()
    }
    let b = UIAlertAction(title: titleB, style: .default) { (action) in
        BBlock()
    }
    alert.addAction(cancel)
    alert.addAction(a)
    alert.addAction(b)
    getOneTool().rootVc?.present(alert, animated: true, completion: nil)
}

func sjin_layerView(bg:UIView, _ corners:UIRectCorner? = nil, _ radius:CGFloat = 0, la:UIView, _ width:CGFloat = 0) {
    var path = UIBezierPath()
    if corners != nil {
        path = UIBezierPath(roundedRect: bg.bounds, byRoundingCorners: corners!, cornerRadii: CGSize(width: radius, height: radius))
    } else {
        path = UIBezierPath(rect: bg.bounds)
    }
    let path1 = UIBezierPath(roundedRect: la.frame, cornerRadius: width)
    path.append(path1)
    let masLayer = CAShapeLayer()
    masLayer.fillRule = .evenOdd
    masLayer.path = path.cgPath
    bg.layer.mask = masLayer
}

func sjin_phoneCheck(str:String) -> String {
    var newStr = str.components(separatedBy: NSCharacterSet(charactersIn: "0123456789").inverted).joined(separator: "") as String
    if newStr.count == 12, newStr.hasPrefix(areaCode) {
        newStr = String(newStr.suffix(10))
    }
    return newStr
}

func getPhoneFormat(_ isTen:Bool = false) -> String {
    switch appArea {
    case .en:
        return isTen ? "^[6-9]\\d{9}$" : "^(91[6-9]\\d{9}|[6-9]\\d{9})$"
    case .es:
        return isTen ? "^[0-9]{10}$" : "^(52[0-9]{10}|[0-9]{10})$"
    }
}

func sjin_copy(text:String, isShowSuc:Bool = true) {
    let pasteboard = UIPasteboard.general
    pasteboard.string = text
    if isShowSuc { QMUITips.show(withText: copySucText) }
}

func goodStar(isBack:Bool, type:Int) {
    if isBack { showVc?.sjin_backHome() }
    guard getOneTool().isShowGoodStar == 0 else { return }
    guard let config = getOneTool().configModel else {
        getOneTool().isShowGoodStar = 1
        return
    }
    let guidance:String = config.feedbackGuidance
    guard guidance != "0" else { return }
    if type == 2 || guidance == "1" { getOneTool().isShowGoodStar = 1 }
}

func starShow() {
    guard getOneTool().isShowGoodStar == 1 else { return }
    getOneTool().isShowGoodStar = 2
    getMainTool().showModal(.goodStar)
}

extension UISlider {
    @IBInspectable var thumbImage: UIImage? {
        get {
            return thumbImage(for: .normal)
        }
        set {
            setThumbImage(newValue, for: .normal)
        }
    }
}

@IBDesignable
class GradientsSlider: UISlider {
    @IBInspectable var trackHeight: CGFloat = 15 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var startColor: UIColor?
    @IBInspectable var endColor: UIColor?
    var startPoint: CGPoint = CGPoint(x: 0, y: 0.5)
    var endPoint: CGPoint = CGPoint(x: 1, y: 0.5)
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.size.height = trackHeight
        guard let _ = startColor, let _ = endColor else { return rect }
        return CGRect(x: bounds.origin.x + bounds.origin.y / 2, y: bounds.origin.y + bounds.height / 2 - trackHeight / 2, width: bounds.width - bounds.origin.y / 2, height: trackHeight)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        guard let startColor = startColor, let endColor = endColor else { return }
        let gradientLayer = CAGradientLayer()
        var gFrame = trackRect(forBounds: bounds)
        gFrame.size.width -= bounds.height / 2
        gradientLayer.frame = gFrame
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = trackHeight / 2
        minimumTrackTintColor = UIColor.clear
        maximumTrackTintColor = UIColor.clear
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

class timeButton: UIButton {
    private var titleString: String = ""
    private var timer: Timer?
    private var countDown: Int = 0
    func getCodeSuccess(second: Int, display: String) {
        guard second > 0 else { return }
        self.countDown = second
        self.titleString = display
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeSecond), userInfo: nil, repeats: true)
    }
    @objc private func changeSecond() {
        if self.countDown <= 1 {
            self.timer?.invalidate()
            self.timer = nil
            self.displayTitle(self.titleString)
            self.isUserInteractionEnabled = true
        } else {
            self.isUserInteractionEnabled = false
            self.countDown = self.countDown - 1
            self.displayTitle("\(self.countDown)s")
        }
    }
    private func displayTitle(_ title: String) {
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
        self.setTitle(title, for: .disabled)
    }
}

func dicToJsonStr(d: [String: Any]) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: d, options: [])
        var jsonString = String(data: jsonData, encoding: .utf8)
        jsonString = jsonString?.replacingOccurrences(of: "\\/", with: "/")
        return jsonString
    } catch {
        print("Error converting to JSON: \(error)")
        return nil
    }
}

func front_share(urlStr: String) {
    guard let url = URL(string: urlStr) else { return }
    let shareController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
    shareController.excludedActivityTypes = []
    if UIDevice.current.model.hasPrefix("iPad") {
        shareController.popoverPresentationController?.sourceView = showVc?.view
        shareController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height, width: 10, height: 10)
    }
    showVc?.present(shareController, animated: true, completion: nil)
}

import StoreKit
func rateApp() {
    SKStoreReviewController.requestReview()
}

@propertyWrapper
struct UserDefaultsWrapper<T> {
    private let key: String
    private let defaultValue: T
    private let defaults = UserDefaults.standard
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    var wrappedValue: T {
        get {
            return (defaults.object(forKey: key) as? T) ?? defaultValue
        }
        set {
            switch newValue as Any {
            case Optional<Any>.some(let value):
                defaults.set(value, forKey: key)
            case Optional<Any>.none:
                defaults.removeObject(forKey: key)
            default:
                defaults.set(newValue, forKey: key)
            }
            defaults.synchronize()
        }
    }
}
