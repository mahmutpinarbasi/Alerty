//
//  Alert.swift
//  Alert
//
//  Created by Mahmut Pınarbaşı on 6.10.2018.
//

import UIKit


public class AlertButton: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        self.configureTitleFor(state)
    }
    
    
    
    private func commonInit() {
        self.layer.cornerRadius = 5.0
        self.configureTitleFor(UIControl.State.normal)
    }
    
    private func configureTitleFor(_ state: UIControl.State){
        
        guard let title = self.title(for: state) else { return }
        
        let attrTitle = NSAttributedString.init(string: title, attributes: Alert.Attributes.buttonAttributes)
        self.setAttributedTitle(attrTitle, for: state)
        
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
        
    }
    
    
}


public final class Alert: UIViewController {

    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblDetail: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var btnCancel: AlertButton!
    
    
    public enum Style: Int {
        case success
        case warning
        case error
    }
    
    private let style:Alert.Style /// the style of alert
    private let header:String /// the title of alert
    private let message:String /// the message of alert
    
    public init(style:Alert.Style, title:String, message:String){
        self.style = style
        self.header = title
        self.message = message
        super.init(nibName: "Alert", bundle: Bundle.alertBundle())
        self.commonInit()
    }
    
    /// Sets corresponding title for given style
    public init(style:Alert.Style, message:String){
        self.style = style
        self.header = style.title
        self.message = message
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

    private func commonInit(){
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }

    private func configureComponents(){
        self.imageView.image = self.style.image
        self.lblTitle.attributedText = NSAttributedString(string: self.header, attributes: Alert.Attributes.titleAttributes)
        self.lblDetail.attributedText = NSAttributedString(string: self.message, attributes: Alert.Attributes.messageAttributes)
        self.btnCancel.setAttributedTitle(NSAttributedString(string: "OK", attributes: Alert.Attributes.buttonAttributes), for: .normal)
        
    }
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}





extension Alert.Style {
    
    var image: UIImage {
        switch self {
        case .success:
            return UIImage.image(namedInBundle: "success")!
        case .error:
            return UIImage.image(namedInBundle: "error")!
        case .warning:
            return UIImage.image(namedInBundle: "warning")!
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
        }
    }
    
}



public extension Bundle {
    public static func alertBundle() -> Bundle? {
        guard let path = Bundle.init(for: Alert.classForCoder()).path(forResource: "Alert", ofType: "bundle") else {
            return nil
        }
        return Bundle.init(path: path)
    }
}

extension UIImage {
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


private extension UIColor {
    
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
