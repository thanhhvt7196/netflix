//
//  TextfieldWithIcon.swift
//  netflix
//
//  Created by thanh tien on 7/27/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

@objc protocol TextFieldWithIconDelegate: AnyObject {
    @objc optional func leftButtonDidTapped()
    @objc optional func textFieldShouldReturn(_ textField: UITextField) -> Bool
    
    @objc optional func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    @objc optional func textFieldDidBeginEditing(_ textField: UITextField)
    @objc optional func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    @objc optional func textFieldDidEndEditing(_ textField: UITextField)
    
    @objc optional func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool

    @objc optional func textFieldDidChangeSelection(_ textField: UITextField)

    @objc optional func textFieldShouldClear(_ textField: UITextField) -> Bool
}

@IBDesignable
class TextFieldWithIcon: UITextField {
    weak var textFieldWithIconDelegate: TextFieldWithIconDelegate?
    
    var floatingInputView: FloatingTextfield?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        delegate = self
    }
    
    @objc private func toggleSecureEntry() {
        if isToggleSecureEntryEnable {
            isSecureTextEntry = !isSecureTextEntry
            if isFirstResponder {
                becomeFirstResponder()
            }
//            rightImage = !isSecureTextEntry ? UIImage(asset: Asset.visibility) : UIImage(asset: Asset.visibilityOff)
        }
    }
    
    var languageCode: String? {
        didSet {
            if self.isFirstResponder {
                self.resignFirstResponder()
                self.becomeFirstResponder()
            }
        }
    }
    
    override var textInputMode: UITextInputMode? {
        if let languageCode = self.languageCode {
            for keyboard in UITextInputMode.activeInputModes {
                if let language = keyboard.primaryLanguage {
                    let locale = Locale.init(identifier: language)
                    if locale.languageCode == languageCode {
                        return keyboard
                    }
                }
            }
        }
        return super.textInputMode
    }
    
    var isToggleSecureEntryEnable: Bool = false {
        didSet {
            if isToggleSecureEntryEnable {
//                rightImage = !isSecureTextEntry ? UIImage(asset: Asset.visibility) : UIImage(asset: Asset.visibilityOff)
            }
        }
    }
    
    var newPlaceHolder: NSMutableAttributedString? {
        didSet {
            setPlaceHolder(newPlaceHolder: newPlaceHolder)
        }
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rightRect = super.rightViewRect(forBounds: bounds)
        rightRect.origin.x -= rightPadding
        return rightRect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let placeHolderRect = super.textRect(forBounds: bounds)
        return placeHolderRect
    }
    
    private var rightImage: UIImage? {
        didSet {
            UIView.performWithoutAnimation {
                updateView()
            }
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0
    
    @IBInspectable var clearButtonColor: UIColor = .black {
        didSet {
            setClearButtonColor(color: clearButtonColor)
        }
    }
    @IBInspectable var leftImage: UIImage? {
        didSet {
            UIView.performWithoutAnimation {
                updateView()
            }
        }
    }

    @IBInspectable var imageColor: UIColor = UIColor.gray4 {
        didSet {
            UIView.performWithoutAnimation {
                updateView()
            }
        }
    }

    private(set) var leftButton = UIButton()
    
    @objc private func leftButtonTapped() {
        textFieldWithIconDelegate?.leftButtonDidTapped?()
    }
    
    private(set) var visibilityButton = UIButton()
    var clearButton: UIButton? {
        if let clearButton = self.value(forKey: "clearButton") as? UIButton {
            return clearButton
        } else {
            return nil
        }
    }
    
    override func layoutSubviews() {
        UIView.performWithoutAnimation {
            super.layoutSubviews()
            setClearButtonColor(color: clearButtonColor)
            setPlaceHolder(newPlaceHolder: newPlaceHolder)
        }
    }
    
    private func setClearButtonColor(color: UIColor) {
        clearButton?.tintColor = color
    }
    
    private func setPlaceHolder(newPlaceHolder: NSMutableAttributedString?) {
        attributedPlaceholder = newPlaceHolder
    }
    
    func updateView() {
        leftViewMode = .always
        rightViewMode = .always
        if let image = leftImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.image = image.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = imageColor
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            leftPaddingView.addSubview(imageView)
            imageView.center = CGPoint(x: leftPaddingView.frame.size.width/2, y: leftPaddingView.frame.size.height/2)
            leftButton.frame = leftPaddingView.bounds
            leftButton.backgroundColor = .clear
            leftPaddingView.addSubview(leftButton)
            leftPaddingView.backgroundColor = .clear
            leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
            leftView = leftPaddingView
        } else {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        }
        
        if let rightImage = rightImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.image = rightImage
            imageView.tintColor = imageColor
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            rightPaddingView.addSubview(imageView)
            imageView.center = CGPoint(x: rightPaddingView.frame.size.width/2, y: rightPaddingView.frame.size.height/2)
            visibilityButton = UIButton(frame: rightPaddingView.bounds)
            visibilityButton.setTitle("", for: .normal)
            visibilityButton.backgroundColor = .clear
            rightPaddingView.addSubview(visibilityButton)
            visibilityButton.addTarget(self, action: #selector(toggleSecureEntry), for: .touchUpInside)
            rightView = rightPaddingView
        } else {
            rightView = nil
        }
    }
}

extension TextFieldWithIcon: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textFieldWithIconDelegate?.textFieldShouldReturn?(self) ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldWithIconDelegate?.textFieldDidBeginEditing?(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldWithIconDelegate?.textFieldDidEndEditing?(self)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return textFieldWithIconDelegate?.textFieldShouldBeginEditing?(self) ?? true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textFieldWithIconDelegate?.textFieldShouldEndEditing?(self) ?? true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textFieldWithIconDelegate?.textField?(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textFieldWithIconDelegate?.textFieldDidChangeSelection?(self)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return textFieldWithIconDelegate?.textFieldShouldClear?(self) ?? true
    }
}
