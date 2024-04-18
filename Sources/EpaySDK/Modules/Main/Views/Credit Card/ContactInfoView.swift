//
//  ContactInfoView.swift
//  EpaySDK
//
//  Created by a1pamys on 2/11/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

class ContactInfoView: UIView {
    
    private let phoneInputListener = MaskedTextInputListener()
    
    var publicProfile: PublicProfileResponseBody.Assets? {
        didSet {
            setVisibility()
        }
    }
    
    // MARK: - UI Elements
    
    public lazy var emailTextField: SkyFloatingLabelTextField = {
        let v = SkyFloatingLabelTextField()
        v.autocapitalizationType = .none
        v.font = UIFont.systemFont(ofSize: 14)
        v.placeholder = String(Constants.Localizable.emailRequiredHint).localized()
        v.title = String(Constants.Localizable.emailRequiredHint).localized()
        v.keyboardType = UIKeyboardType.emailAddress
        v.isHidden = true
        v.delegate = self
        return v
    }()
    
    public lazy var phoneTextField: SkyFloatingLabelTextField = {
        let v = SkyFloatingLabelTextField()
        
        v.textColor = .black
        v.keyboardType = .asciiCapableNumberPad
        v.font = UIFont.systemFont(ofSize: 14)
        v.placeholder = String(
            Constants.Localizable.phoneHint
        ).localized()
        v.title = String(
            Constants.Localizable.phoneHint
        ).localized()
        v.selectedLineColor = UIColor.mainColor
        v.selectedTitleColor = UIColor.mainColor
        v.isHidden = true
        phoneInputListener.primaryMaskFormat = "+7 [000] [000] [0000]"
        v.delegate = phoneInputListener
        return v
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods

    func setCustom(textColor: UIColor) {
        emailTextField.textColor = textColor
        emailTextField.placeholderColor = textColor
        emailTextField.lineColor = textColor
        emailTextField.selectedLineColor = textColor
        emailTextField.titleColor = textColor
        emailTextField.selectedTitleColor = textColor
        emailTextField.titleFormatter = { (text: String) -> String in return text }
        phoneTextField.textColor = textColor
        phoneTextField.placeholderColor = textColor
        phoneTextField.lineColor = textColor
        phoneTextField.selectedLineColor = textColor
        phoneTextField.titleColor = textColor
        phoneTextField.selectedTitleColor = textColor
        phoneTextField.titleFormatter = { (text: String) -> String in return text }
    }
    
    func validate() {
        if (!isValidEmail(emailTextField.text!)) {
            emailTextField.lineColor = .red
        } else {
            emailTextField.lineColor = UIColor(hexString: "#DFE3E6")
        }
        
        if (!isValidPhone(phoneTextField.text!)) {
            phoneTextField.lineColor = .red
        } else {
            phoneTextField.lineColor = UIColor(hexString: "#DFE3E6")
        }
    }
    
    func isValid() -> Bool {
        return isValidEmail(emailTextField.text!) && isValidPhone(phoneTextField.text!)
    }
    
    // MARK: - Private methods

    private func setupViews() {
        addSubview(emailTextField)
        addSubview(phoneTextField)
    }
    
    private func setVisibility() {
        if publicProfile?.payment_view_settings?.userContactsByEmail == true {
            emailTextField.isHidden = false
        }
        
        if publicProfile?.payment_view_settings?.userContactsAll == true {
            emailTextField.isHidden = false
            phoneTextField.isHidden = false
        }
    }
    
    private func setupConstraints() {
        emailTextField.anchor(top: topAnchor, right: rightAnchor, left: leftAnchor, bottom: phoneTextField.topAnchor, paddingTop: 24,paddingBottom: 12, height: 42)
        phoneTextField.anchor(top: emailTextField.bottomAnchor, right: rightAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 24, height: 42)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        if publicProfile?.payment_view_settings?.userContactsByEmail == false && publicProfile?.payment_view_settings?.userContactsAll == false  {
            return true
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPhone(_ phone: String) -> Bool {
        if publicProfile?.payment_view_settings?.userContactsAll == false  {
            return true
        }
        
        return !phone.isEmpty
    }
}

// MARK: - Extensions

extension ContactInfoView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField as! SkyFloatingLabelTextField).lineColor = UIColor(hexString: "#DFE3E6")
//        textField.layer.sublayers![0].backgroundColor = UIColor.mainColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.layer.sublayers![0].backgroundColor = UIColor(hexString: "#DFE3E6").cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
