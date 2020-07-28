//
//  FloatingTextField.swift
//  netflix
//
//  Created by thanh tien on 7/27/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit

class FloatingTextfieldSettingBuilder {
    fileprivate var _backgroundColor = UIColor.darkGray
    fileprivate var _textColor = UIColor.white
    fileprivate var _placeholderColor = UIColor.gray4
    fileprivate var _textFieldTintColor = UIColor.white
    fileprivate var _hintColor = UIColor.gray4
    fileprivate var _errorColor = UIColor.red
    fileprivate var _placeholder: String?
    fileprivate var _secure: Bool = false
    fileprivate var _inputType: InputValidateType?
    fileprivate var _leftPadding: CGFloat = 10
    fileprivate var _leftImage: UIImage?
    fileprivate var _clearButtonColor = UIColor.gray4
    fileprivate var _clearButtonMode = UITextField.ViewMode.never
    fileprivate var _cornerRadius: CGFloat = 6
    fileprivate var _keyboardType: UIKeyboardType = UIKeyboardType.default
    fileprivate var _rightPadding: CGFloat = 10
    fileprivate var _toggleSecureEntryEnabled = false

    static func shared() -> FloatingTextfieldSettingBuilder {
        return FloatingTextfieldSettingBuilder()
    }

    func backgroundColor(_ color: UIColor) -> FloatingTextfieldSettingBuilder {
        _backgroundColor = color
        return self
    }

    func textColor(_ color: UIColor) -> FloatingTextfieldSettingBuilder {
        _textColor = color
        return self
    }

     func placeholderColor(_ color: UIColor) -> FloatingTextfieldSettingBuilder {
        _placeholderColor = color
        return self
    }

     func tintColor(_ color: UIColor) -> FloatingTextfieldSettingBuilder {
        _textFieldTintColor = color
        return self
    }

     func hintColor(_ color: UIColor) -> FloatingTextfieldSettingBuilder {
        _hintColor = color
        return self
    }

     func errorColor(_ color: UIColor) -> FloatingTextfieldSettingBuilder {
        _errorColor = color
        return self
    }

     func placeholer(_ placeholder: String) -> FloatingTextfieldSettingBuilder {
        _placeholder = placeholder
        return self
    }

     func isSecureEntry(_ isSecure: Bool) -> FloatingTextfieldSettingBuilder {
        _secure = isSecure
        return self
    }
    
     func inputType(_ type: InputValidateType) -> FloatingTextfieldSettingBuilder {
        _inputType = type
        return self
    }
    
    func leftPadding(_ padding: CGFloat) -> FloatingTextfieldSettingBuilder {
        _leftPadding = padding
        return self
    }
    
    func leftImage(_ image: UIImage) -> FloatingTextfieldSettingBuilder {
        _leftImage = image
        return self
    }
    
    func clearButtonColor(_ color: UIColor) -> FloatingTextfieldSettingBuilder {
        _clearButtonColor = color
        return self
    }
    
    func clearButtonMode(_ mode: UITextField.ViewMode) -> FloatingTextfieldSettingBuilder {
        _clearButtonMode = mode
        return self
    }
    
    func cornerRadius(_ radius: CGFloat) -> FloatingTextfieldSettingBuilder {
        _cornerRadius = radius
        return self
    }
    
    func keyboardType(_ keyboardType: UIKeyboardType) -> FloatingTextfieldSettingBuilder {
        _keyboardType = keyboardType
        return self
    }
    
    func rightPadding(_ padding: CGFloat) -> FloatingTextfieldSettingBuilder {
        _rightPadding = padding
        return self
    }
    
    func toggleSecureEntryEnabled(_ enabled: Bool) -> FloatingTextfieldSettingBuilder {
        _toggleSecureEntryEnabled = enabled
        return self
    }

    func build() -> FloatingTextfieldSetting {
        return FloatingTextfieldSetting(builder: self)
    }
}

class FloatingTextfieldSetting {
    let backgroundColor: UIColor
    let textColor: UIColor
    let placeholderColor: UIColor
    let textFieldTintColorColor: UIColor
    let hintColor: UIColor
    let errorColor: UIColor
    let placeholder: String?
    let isSecure: Bool?
    let inputType: InputValidateType?
    let leftPadding: CGFloat
    let leftImage: UIImage?
    let clearButtonColor: UIColor
    let clearButtonMode: UITextField.ViewMode
    let cornerRadius: CGFloat
    let keyboardType: UIKeyboardType
    let rightPadding: CGFloat
    let toggleSecureEntryEnabled: Bool

    fileprivate init(builder: FloatingTextfieldSettingBuilder) {
        self.backgroundColor = builder._backgroundColor
        self.textColor = builder._textColor
        self.placeholderColor = builder._placeholderColor
        self.textFieldTintColorColor = builder._textFieldTintColor
        self.hintColor = builder._hintColor
        self.errorColor = builder._errorColor
        self.placeholder = builder._placeholder
        self.isSecure = builder._secure
        self.inputType = builder._inputType
        self.leftPadding = builder._leftPadding
        self.leftImage = builder._leftImage
        self.clearButtonColor = builder._clearButtonColor
        self.clearButtonMode = builder._clearButtonMode
        self.cornerRadius = builder._cornerRadius
        self.keyboardType = builder._keyboardType
        self.rightPadding = builder._rightPadding
        self.toggleSecureEntryEnabled = builder._toggleSecureEntryEnabled
    }
}
