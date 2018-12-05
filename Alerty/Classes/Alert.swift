//
//  Alert.swift
//  Alert
//
//  Created by Mahmut Pınarbaşı on 6.10.2018.
//

import UIKit


public protocol StyleAdaptable {
    var color: UIColor { get }
}

public final class Alert: UIViewController {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblDetail: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var visualEffectView: UIVisualEffectView!
    @IBOutlet private weak var buttonStack: UIStackView!
    
    /// The closure that's called on alert dismiss completion.
    public var onDismiss: (() -> Void)? = nil
    
    public enum Style: Int {
        case success
        case warning
        case error
        case info
    }
    
    private let style:Alert.Style /// the style of alert
    private let header:String /// the title of alert. by defaul it uses the corresponding header for given `style`
    private let message:String /// the message of alert
    private let image: UIImage /// the image of the alert. by defaul it uses the corresponding UIImage for given `style`
    private var buttons: [AlertButton] /// an array that keeps `AlertButton`s to add on `buttonStack` when ready.
    private let addDefaultCancel: Bool /// a boolean flag that keeps whether Alerty should add a default cancel button. default value is true
    
    /// Sets corresponding title & image for given style if `title` or `image` nil.
    public init(style:Alert.Style, title:String? = nil, message:String, image: UIImage? = nil, addDefaultCancel: Bool = true){
        self.style = style
        self.header = title ?? style.title
        self.image = image ?? style.image
        self.message = message
        self.buttons = [AlertButton]()
        self.addDefaultCancel = addDefaultCancel
        super.init(nibName: "Alert", bundle: Bundle.alertBundle())
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configureComponents()
    }
    
    public func add(buttonWith title: String, backgroundColor: UIColor? = UIColor.lightGray, onTapped: OnTapClosure? = nil){
        let alertButton = AlertButton(title: title) { [weak self] button in
            guard let strongButton = button else { return }
            onTapped?(strongButton)
            self?.completeDismiss()
        }
        alertButton.backgroundColor = backgroundColor
        self.buttons.append(alertButton)
    }
    
    
    // MARK: - Private -
    private func commonInit(){
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        if self.addDefaultCancel {
            self.addDefaultButton()
        }
    }

    private func configureComponents(){
        self.imageView.image = self.style.image
        self.lblTitle.attributedText = NSAttributedString(string: self.header, attributes: Alert.Attributes.titleAttributes)
        self.lblDetail.attributedText = NSAttributedString(string: self.message, attributes: Alert.Attributes.messageAttributes)
        self.visualEffectView.effect = UIBlurEffect(style: Alert.Attributes.blurStyle)
        self.buttonStack.axis = Alert.Attributes.buttonAxis
        self.buttons.forEach( self.buttonStack.addArrangedSubview(_:) )
    }
    
    @objc private func completeDismiss(){
        self.dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.onDismiss?()
        }
    }
    
    private func addDefaultButton(){
        let button = AlertButton.init(title: Localized.localize("button_title_cancel"))
        button.addTarget(self, action: #selector(Alert.completeDismiss), for: .touchUpInside)
        button.backgroundColor = self.style.color
        self.buttons.append(button)
    }
}





public extension Alert.Style {
    
    var image: UIImage {
        switch self {
        case .success:
            return UIImage.image(namedInBundle: "success")!
        case .error:
            return UIImage.image(namedInBundle: "error")!
        case .warning:
            return UIImage.image(namedInBundle: "warning")!
        case .info:
            return UIImage.image(namedInBundle: "info")!
        }
    }
    
    var title:String {
        switch self {
        case .success:
            return Localized.localize("title_success")
        case .error:
            return Localized.localize("title_error")
        case .warning:
            return Localized.localize("title_warning")
        case .info:
            return Localized.localize("title_info")
        }
    }
    
    var color: UIColor {
        switch self {
        case .success, .info:
            return UIColor(hex: "29D093")
        case .error, .warning:
            return UIColor(hex: "FF9B2B")
        }
    }
}



public extension Bundle {
    public static func alertBundle() -> Bundle? {
        guard let path = Bundle.init(for: Alert.classForCoder()).path(forResource: "Alerty", ofType: "bundle") else {
            return nil
        }
        return Bundle.init(path: path)
    }
}

// MARK: - UIImage Extensions -
internal extension UIImage {
    convenience init?(namedInBundle name:String){
        self.init(named: name, in: Bundle.alertBundle(), compatibleWith: nil)
    }
    
    class func image(namedInBundle name:String, renderingMode: UIImage.RenderingMode = UIImage.RenderingMode.alwaysOriginal) -> UIImage? {
        if let image = UIImage.init(namedInBundle: name) {
            return image.withRenderingMode(renderingMode)
        }
        return nil
    }
}

// MARK: - Localizations
internal struct Localized {
    static func localize(_ key:String) -> String {
        
        if let bundle = Bundle.alertBundle() {
            let value = NSLocalizedString(key, bundle: bundle, value:"", comment:"")
            if value.count > 0 {
                return value
            }else {
                return key
            }
        }
        return key
    }
}

// MARK: - UIColor Extensions -
internal extension UIColor {
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    convenience init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init()
        }else{
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
        }
    }
}


public extension Alert {
    
    /// Attributes for `Alert` Compoents
    public struct Attributes {
        
        struct Kern {
            static let title:CGFloat = 1.0
            static let message:CGFloat = 0.5
            static let button:CGFloat = 2.1
        }
        
        struct Foreground {
            static let title:UIColor = UIColor.black
            static let message:UIColor = UIColor(hex: "9B9B9B")
            static let button:UIColor = UIColor.white
        }
        
        struct Font {
            static let title:UIFont = UIFont(name: "Avenir-Medium", size: 16.0)!
            static let message:UIFont = UIFont(name: "Avenir-Light", size: 15.0)!
            static let button:UIFont = UIFont(name: "Avenir-Medium", size: 17.0)!
        }
        
        
        
        /// NSAttributedString.Key values for title.
        public static var titleAttributes:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font:Alert.Attributes.Font.title,
                                                                            NSAttributedString.Key.foregroundColor:Alert.Attributes.Foreground.title,
                                                                            NSAttributedString.Key.kern:Alert.Attributes.Kern.title
        ]
        
        /// NSAttributedString.Key values for message.
        public static var messageAttributes:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font:Alert.Attributes.Font.message,
                                                                              NSAttributedString.Key.foregroundColor:Alert.Attributes.Foreground.message,
                                                                              NSAttributedString.Key.kern:Alert.Attributes.Kern.message
        ]
        
        /// NSAttributedString.Key values for AlertButton.
        public static var buttonAttributes:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font:Alert.Attributes.Font.button,
                                                                             NSAttributedString.Key.foregroundColor:Alert.Attributes.Foreground.button,
                                                                             NSAttributedString.Key.kern:Alert.Attributes.Kern.button
        ]
        
        /// Blur style of the Alert
        public static var blurStyle:UIBlurEffect.Style = UIBlurEffect.Style.light
        
        /// the axis of buttons on alert. default value is NSLayoutConstraint.Axis.horizontal
        public static var buttonAxis: NSLayoutConstraint.Axis = NSLayoutConstraint.Axis.horizontal
        
        /// desired height of the `AlertButton`. default value is 56.0
        public static var buttonHeight: CGFloat = 56.0
    }
    
    
}
