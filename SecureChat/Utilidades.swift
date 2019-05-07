//
//  Utilidades.swift
//  SecureChat
//
//  Created by Luis Luna on 4/27/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Alamofire
import os


final class Utilidades {
    private init(){}
    
    static let labelWidth = 400
    
    static func showMessage(title: String, text: String) -> UIAlertController {
        var alertController: UIAlertController!
        alertController = UIAlertController(title: title, message:
            text, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alertController
        
    }
    
    static func showMessageCompletion(title: String, text: String, block: @escaping () -> Void) -> UIAlertController {
        var alertController: UIAlertController!
        alertController = UIAlertController(title: title, message:
            text, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            
            block()
            
        })
        
        return alertController
        
    }
    
    static func showMessageOkCancel(title: String, text: String, block: @escaping () -> Void) -> UIAlertController {
        var alertController: UIAlertController!
        alertController = UIAlertController(title: title, message:
            text, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            block()
        })
        
        
        return alertController
    }
    
    static func showError(text: String) -> UIAlertController {
        var alertController: UIAlertController!
        alertController = UIAlertController(title: "Error", message:
            text, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        
        return alertController
        
    }
//
//    static func showErrorCustomAlert(text: String) -> CustomAlertControllerViewController {
//        var alert: CustomAlertControllerViewController!
//        alert = CustomAlertControllerViewController(title: "Error", message: text, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//        return alert
//    }
//
//    static func showErrorCustomAlert(title: String, text: String) -> CustomAlertControllerViewController {
//        var alert: CustomAlertControllerViewController!
//        alert = CustomAlertControllerViewController(title: title, message: text, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//        return alert
//    }
    
    static func infoDispositivo() -> (String, String, String, String, String) {
        let device = UIDevice()
        let uuid = device.identifierForVendor?.uuidString   //UUID
        let model = UIDevice.modelName   //modelo
        let os_name = device.systemName  //nombre del SO
        let os_version = device.systemVersion  //versión del SO
        let brand = "Apple"   //marca
        return (uuid!, model, os_name, os_version, brand)
    }
    
    static func imgToBase64String(myImage: UIImage) -> String {
        var base64String: String!
        let imageData = myImage.jpegData(compressionQuality: 1)
        base64String = imageData!.base64EncodedString(options: []) as String?
        
        print("IMAGEN \(myImage) FUE CONVERTIDA A STRING")
        return base64String
    }
    
    static func imgToData(image: UIImage) -> Data? {
        let squareImg = Utilidades.squareImage(image: image)
        let compressedImg = Utilidades.resizeImage(image: squareImg, targetSize: CGSize(width: 200, height: 200))
        let data = compressedImg.jpegData(compressionQuality: 1)
        return data
    }
    
    static func base64StringToImg(base64String: String) -> UIImage? {
        
        guard let dataDecoded = Data(base64Encoded: base64String as String, options: Data.Base64DecodingOptions()) else {
            return nil
        }
        guard let img = UIImage(data: dataDecoded) else {
            return nil
        }
        
        return img
    }
    
    static func dataToImage(data: Data) -> UIImage? {
        if let img = UIImage(data: data){
            return img
        }else{
            return nil
        }
    }
    
    static func escapedParameters(parameters: [String: AnyObject]) -> String { //Hace que unicamente se envien al servidor caracteres permitidos
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                // Make sure that is a string value
                let stringValue = "\(value)"
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func squareImage(image: UIImage) -> UIImage {
        let originalWidth  = image.size.width
        let originalHeight = image.size.height
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var edge: CGFloat = 0.0
        
        if (originalWidth > originalHeight) {
            // landscape
            edge = originalHeight
            x = (originalWidth - edge) / 2.0
            y = 0.0
            
        } else if (originalHeight > originalWidth) {
            // portrait
            edge = originalWidth
            x = 0.0
            y = (originalHeight - originalWidth) / 2.0
        } else {
            // square
            edge = originalWidth
        }
        
        let cropSquare = CGRect(x: x, y: y, width: edge, height: edge)
        let imageRef = image.cgImage!.cropping(to: cropSquare)
        return UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: image.imageOrientation)
    }
    
  
    
    
    static func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    static func displayToastMessage(_ message : String, duration: UInt64) {
        
        let toastView = UILabel()
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastView.textColor = UIColor.white
        toastView.textAlignment = .center
        toastView.font = UIFont.preferredFont(forTextStyle: .caption1)
        toastView.layer.cornerRadius = 25
        toastView.layer.masksToBounds = true
        toastView.text = message
        toastView.numberOfLines = 0
        toastView.alpha = 0
        toastView.translatesAutoresizingMaskIntoConstraints = false
        
        let window = UIApplication.shared.delegate?.window!
        window?.addSubview(toastView)
        
        let horizontalCenterContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
        
        let widthContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 275)
        
        let verticalContraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=200)-[loginView(==50)]-68-|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["loginView": toastView])
        
        NSLayoutConstraint.activate([horizontalCenterContraint, widthContraint])
        NSLayoutConstraint.activate(verticalContraint)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastView.alpha = 1
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(duration * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                toastView.alpha = 0
            }, completion: { finished in
                toastView.removeFromSuperview()
            })
        })
    }
    
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    //(?=.*[a-z]+)(?=.*[A-Z]+)(?=.*\\d)(?=^[A-Za-z0-9]{8}$)
    
    func isValidPassword() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).+$")
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func base64ToImage() -> UIImage? {
        if let url = URL(string: self),let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
}

extension UIButton {
    func setBottomLine(borderColor: UIColor) {
        
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
    func toUIBarButton() -> UIBarButtonItem {
        return UIBarButtonItem.init(customView: self)
        
    }
}

extension UITextField {
    
    func setBottomLine(borderColor: UIColor) {
        
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
    func setBottomLineWithBackground(borderColor: UIColor, background: UIColor) {
        
        self.backgroundColor = background
        self.layer.cornerRadius = 10
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    func registerForKeyboardWillShowNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { notification -> Void in
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: keyboardSize.height, right: scrollView.contentInset.right)
            
            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?(keyboardSize)
        })
    }
    
    func registerForKeyboardWillHideNotification(_ scrollView: UIScrollView, usingBlock block: (() -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { _ -> Void in
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: 0, right: scrollView.contentInset.right)
            
            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?()
        })
    }
}


extension Date {
    func toString(dateFormat format: String)  -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "es_ES")
        return dateFormatter.string(from: self)
    }
    
    func dateStyle(dateStyle style: DateFormatter.Style)  -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        dateFormatter.locale = Locale(identifier: "es_ES")
        return dateFormatter.string(from: self)
    }
    
    func timeAgoDisplay() -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            if diff <= 1 {
                return "Hace \(diff) segundo"
            }
            return "Hace \(diff) segundos"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            if diff <= 1 {
                return "Hace \(diff) minuto"
            }
            return "Hace \(diff) minutos"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            if diff <= 1 {
                return "Hace \(diff) hora"
            }
            return "Hace \(diff) horas"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            if diff <= 1 {
                return "Hace \(diff) día"
            }
            return "Hace \(diff) días"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        if diff <= 1 {
            return "Hace \(diff) semana"
        }
        return "Hace \(diff) semanas"
    }
    
    func remaining() -> DateComponents {
        let calendar = NSCalendar.current
        let fechaIni = self
        let components = calendar.dateComponents([.hour, .minute, .second], from: Date(), to: fechaIni)
        
        return components
    }
    
    func removeTimeStamp() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
}

extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.8, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.8, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion) }
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated() {
            let key  = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func addShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 2)
        self.layer.shadowRadius = self.layer.cornerRadius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
}

extension UITextView {
    func addBottomBorderWithColor(color: UIColor, height: CGFloat) {
        let border = UIView()
        border.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        border.frame = CGRect(x: self.frame.origin.x,
                              y: self.frame.origin.y+self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color
        self.superview!.insertSubview(border, aboveSubview: self)
    }
    
    
    
    func resolveHashTags() -> [String] {
        
        var wordsWithHash = [String]()
        
        // turn string in to NSString
        let nsText = NSString(string: self.text)
        
        let currentAttr = convertFromNSAttributedStringKeyDictionary(self.typingAttributes)
        
        // this needs to be an array of NSString.  String does not work.
        let words = nsText.components(separatedBy: CharacterSet(charactersIn: "#ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_áéíóúÁÉÍÓÚ").inverted)
        
        //print("WORDS \( )")
        
        // you can staple URLs onto attributed strings
        let attrString = NSMutableAttributedString()
        attrString.setAttributedString(self.attributedText)
        
        // tag each word if it has a hashtag
        for word in words {
            if word.count < 2 {
                continue
            }
            
            // found a word that is prepended by a hashtag!
            // homework for you: implement @mentions here too.
            if word.hasPrefix("#") {
                
                
                // a range is the character position, followed by how many characters are in the word.
                // we need this because we staple the "href" to this range.
                let matchRange:NSRange = nsText.range(of: word as String)
                
                // drop the hashtag
                let stringifiedWord = word.dropFirst()
                if let firstChar = stringifiedWord.unicodeScalars.first, NSCharacterSet.decimalDigits.contains(firstChar) {
                    // hashtag contains a number, like "#1"
                    // so don't make it clickable
                } else {
                    
                    print("Word with hashtag +++ \(word)")
                    if !wordsWithHash.contains(word) {
                        wordsWithHash.append(word)
                    }
                    // set a link for when the user clicks on this word.
                    // it's not enough to use the word "hash", but you need the url scheme syntax "hash://"
                    // note:  since it's a URL now, the color is set to the project's tint color
                    attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
                }
                
            }
        }
        
        // we're used to textView.text
        // but here we use textView.attributedText
        // again, this will also wipe out any fonts and colors from the storyboard,
        // so remember to re-add them in the attrs dictionary above
        
        self.attributedText = attrString
        self.typingAttributes = convertToNSAttributedStringKeyDictionary(currentAttr)
        
        return wordsWithHash
    }
    
}

extension UILabel {
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
}

extension UIImageView {
    func circleImage() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}

extension UIButton {
    func round(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

extension UIViewController {
    func scrollToTop() {
        func scrollToTop(view: UIView?) {
            guard let view = view else { return }
            
            switch view {
            case let scrollView as UIScrollView:
                if scrollView.scrollsToTop == true {
                    scrollView.setContentOffset(CGPoint(x: 0.0, y: -scrollView.contentInset.top), animated: true)
                    return
                }
            default:
                break
            }
            
            for subView in view.subviews {
                scrollToTop(view: subView)
            }
        }
        
        scrollToTop(view: view)
    }
    
    // Changed this
    
    var isScrolledToTop: Bool {
        if self is UITableViewController {
            return (self as! UITableViewController).tableView.contentOffset.y == 0
        }
        for subView in view.subviews {
            if let scrollView = subView as? UIScrollView {
                return (scrollView.contentOffset.y == 0)
            }
        }
        return true
    }

}

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    
    func renderResizedImage (newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        let image = renderer.image { (context) in
            self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
        return image
    }
}

//struct MarkerStruct {
//    let idTransmision: Int
//    let idEvento: Int
//    let titulo: String
//    let lat: CLLocationDegrees
//    let lon: CLLocationDegrees
//    let pic: UIImage
//    let tipo: String
//}
extension UIScrollView {
    func setContentInsetAndScrollIndicatorInsets(_ edgeInsets: UIEdgeInsets) {
        self.contentInset = edgeInsets
        self.scrollIndicatorInsets = edgeInsets
    }
}

extension UIViewController {
    var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }
}

extension Date {
    static func from(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }
}

extension Dictionary {
    var queryString: String {
        let query = self.compactMap { (key, value) -> String in
            return "\(key)=\(value)"
            }.joined(separator: "&")
        
        return query
    }
}

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let apiConnection = OSLog(subsystem: subsystem, category: "apiConnection")
    
    static let login = OSLog(subsystem: subsystem, category: "login")
    
    static let reLogin = OSLog(subsystem: subsystem, category: "reLogin")
    
    static let share = OSLog(subsystem: subsystem, category: "share")
    
    static let streaming = OSLog(subsystem: subsystem, category: "streaming")
    
    static let playback = OSLog(subsystem: subsystem, category: "playback")
    
    static let crearEvento = OSLog(subsystem: subsystem, category: "crearEvento")
    
    static let agenda = OSLog(subsystem: subsystem, category: "agenda")
    
    static let eventosProximos = OSLog(subsystem: subsystem, category: "eventosProximos")
    
    static let listingEventos = OSLog(subsystem: subsystem, category: "listingEventos")
    
    static let publicidad = OSLog(subsystem: subsystem, category: "publicidad")
    
    static let compartir = OSLog(subsystem: subsystem, category: "compartir")
    
    static let notificacion = OSLog(subsystem: subsystem, category: "notificacion")
    
    static let objetosID = OSLog(subsystem: subsystem, category: "objetosID")
    
    static let busqueda = OSLog(subsystem: subsystem, category: "busqueda")
    
    static let perfil = OSLog(subsystem: subsystem, category: "perfil")
    
    static let comentarios = OSLog(subsystem: subsystem, category: "comentarios")
    
    static let explorar = OSLog(subsystem: subsystem, category: "explorar")
    
    static let registro = OSLog(subsystem: subsystem, category: "registro")
    
    
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKeyDictionary(_ input: [NSAttributedString.Key: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}


