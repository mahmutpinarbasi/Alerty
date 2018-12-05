//
//  AlertButton.swift
//  Alerty
//
//  Created by Mahmut Pınarbaşı on 5.12.2018.
//

import UIKit


public typealias OnTapClosure = (_ button: AlertButton?) -> Void

public final class AlertButton: UIButton {
    
    public var onTapped: OnTapClosure?
    
    // MARK: - Lifecycle -
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    /**
     Convenience initialiser for `AlertButton`
     Use this initialiser & pass a closre to `onTapped` parameter to detect .touchUpInside control events.
     */
    convenience public init(title: String, onTapped: OnTapClosure? = nil){
        self.init(frame: CGRect.zero)
        self.onTapped = onTapped
        self.setTitle(title, for: .normal)
        self.addTarget(self, action: #selector(AlertButton.didTapped), for: .touchUpInside)
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        self.configureTitleFor(state)
    }
    
    public override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        return CGSize.init(width: superSize.width, height: Alert.Attributes.buttonHeight)
    }
    
    // MARK: - Private -
    @objc private func didTapped(){
        guard let tapClosure = self.onTapped else { return }
        tapClosure(self)
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
