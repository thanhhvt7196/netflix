//
//  FloatingTextfield.swift
//  netflix
//
//  Created by thanh tien on 7/27/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Reusable

enum ViolationStatus {
    case valid
    case violated
}

class FloatingTextfield: UIView, NibOwnerLoadable {
    @IBOutlet fileprivate weak var placeHolderLabel: UILabel!
    @IBOutlet fileprivate weak var inputTextField: TextFieldWithIcon!
    @IBOutlet fileprivate weak var errorLabel: UILabel!
    
    var attributedPlaceholder: NSMutableAttributedString?
    
    var toggleButton: UIButton {
        return inputTextField.visibilityButton
    }
    
    var clearButton: UIButton? {
        return inputTextField.clearButton
    }
    
    var isValid = BehaviorRelay<Bool>(value: false)
    
    fileprivate var setting: FloatingTextfieldSetting?
    fileprivate let disposeBag = DisposeBag()

     override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        loadNibContent()
        inputTextField.borderStyle = .none
        inputTextField.floatingInputView = self
        placeHolderLabel.isHidden = true
        errorLabel.isHidden = true
    }

    fileprivate func bind() {
        inputTextField.rx
            .controlEvent([.editingDidBegin])
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.inputTextField.newPlaceHolder = nil
                self.validateSucceed()
            })
            .disposed(by: disposeBag)
        
        inputTextField.rx
            .controlEvent([.editingDidEnd])
            .withLatestFrom(inputTextField.rx.text)
            .map { [weak self] text -> (String?, ViolationStatus) in
                guard let self = self,
                    let inputType = self.setting?.inputType,
                    let validatedText = text
                else {
                    return (text, .valid)
                }
                return (validatedText, InputValidate.shared.validate(type: inputType, text: validatedText) ? .valid : .violated)
            }
            .map { [weak self] text, status -> String? in
                guard let self = self,
                    let inputType = self.setting?.inputType,
                    let text = text
                else {
                    return nil
                }
                switch status {
                case .valid:
                    return nil
                case .violated:
                    return InputValidate.shared.validate(type: inputType, text: text)
                }
            }
            .subscribe(onNext: { [weak self] violation in
                guard let self = self, let text = self.text() else { return }
                self.inputTextField.newPlaceHolder = text.count > 0 ? nil : self.attributedPlaceholder
                guard let violation = violation else {
                    if text.count == 0 {
                        self.placeHolderLabel.isHidden = true
                    } else {
                        self.validateSucceed()
                    }
                    return
                }
                self.validateFailed(violation: violation)
            })
            .disposed(by: disposeBag)
        
        let inputText = inputTextField.rx.text.orEmpty
        
        inputText
            .distinctUntilChanged()
            .map { [weak self] text -> Bool in
                guard let self = self,
                    let inputType = self.setting?.inputType
                else {
                    return true
                }
                return InputValidate.shared.validate(type: inputType, text: text)
            }
            .bind(to: isValid)
            .disposed(by: disposeBag)
    }
}

extension FloatingTextfield {
    func setup(setting: FloatingTextfieldSetting) {
        self.setting = setting
        inputTextField.backgroundColor = setting.backgroundColor
        inputTextField.textColor = setting.textColor
        inputTextField.tintColor = setting.textFieldTintColorColor
        placeHolderLabel.textColor = setting.hintColor
        placeHolderLabel.text = setting.placeholder
        inputTextField.placeholder = setting.placeholder
        inputTextField.isSecureTextEntry = setting.isSecure ?? false
        attributedPlaceholder = NSMutableAttributedString(
            string: setting.placeholder ?? "",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                         NSAttributedString.Key.foregroundColor: setting.placeholderColor]
        )
        inputTextField.newPlaceHolder = attributedPlaceholder
        errorLabel.textColor = setting.errorColor
        inputTextField.leftImage = setting.leftImage
        inputTextField.clearButtonMode = setting.clearButtonMode
        inputTextField.clearButtonColor = setting.clearButtonColor
        inputTextField.keyboardType = setting.keyboardType
        inputTextField.rightPadding = setting.rightPadding
        inputTextField.isToggleSecureEntryEnable = setting.toggleSecureEntryEnabled
        inputTextField.layer.cornerRadius = setting.cornerRadius
        bind()
    }
    
    func text() -> String? {
        return inputTextField.text
    }

    func setEnabled(_ isEnable: Bool? = true) {
        inputTextField.isUserInteractionEnabled = isEnable!
    }
    
    func setText(text: String?) {
        inputTextField.text = text
        guard let text = text, text.count > 0 else {
            placeHolderLabel.isHidden = true
            inputTextField.newPlaceHolder = attributedPlaceholder
            errorLabel.isHidden = true
            return
        }
        validateSucceed()
        isValid.accept(true)
    }

    override func resignFirstResponder() -> Bool {
        return inputTextField.resignFirstResponder()
    }
    
    func validateFailed(violation: String) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.placeHolderLabel.isHidden = true
            self.errorLabel.isHidden = false
            self.errorLabel.text = violation
            self.errorLabel.textColor = self.setting?.errorColor
        })
    }
    
    func validateSucceed() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.placeHolderLabel.isHidden = false
            self.errorLabel.isHidden = true
            self.placeHolderLabel.textColor = self.setting?.hintColor
            self.errorLabel.text = nil
        })
    }
}

extension Reactive where Base: FloatingTextfield {
    var stringViolation: Binder<String?> {
        return Binder(base, binding: { floatingInputView, violation in
            guard let violation = violation else {
                floatingInputView.isValid.accept(true)
                if let text = floatingInputView.text(), text.count > 0 {
                    floatingInputView.placeHolderLabel.isHidden = false
                } else {
                    floatingInputView.placeHolderLabel.isHidden = !floatingInputView.inputTextField.isEditing
                }
                floatingInputView.errorLabel.isHidden = true
                floatingInputView.placeHolderLabel.textColor = floatingInputView.setting?.hintColor
                floatingInputView.errorLabel.text = nil
                return
            }
            floatingInputView.isValid.accept(false)
            floatingInputView.validateFailed(violation: violation)
        })
    }
    
    var text: ControlProperty<String?> {
        return base.inputTextField.rx.text
    }
}
