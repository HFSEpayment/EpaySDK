//
//  CreditCardView.swift
//  EpaySDK
//
//  Created by a1pamys on 2/11/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

class CreditCardView: UIView {
    
    // MARK: - Public properties
    
    var cardNumber: String? {
        didSet {
            if let number = cardNumber {
                cardNumMaxLength = getCardNumMaxLength(number)
                cardNumberTextField.text = modifyCreditCardString(creditCardString: number, length: cardNumMaxLength)
            }
        }
    }
    
    var publicProfile: PublicProfileResponseBody.Assets? {
        didSet {
            if publicProfile?.payment_view_settings?.payerName == true {
                nameTextField.isHidden = false
            }
        }
    }

    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet { setCustomStyles() }
    }
    
    public var delegate: CreditCardViewDelegate?
    public lazy var cardNumMaxLength = getCardNumMaxLength()
    public lazy var cvvMaxLength = 3 // default

    public var forReceiver: Bool = false {
        didSet {
            monthTextField.isHidden = forReceiver
            yearTextField.isHidden = forReceiver
            cvvTextField.isHidden = forReceiver
        }
    }
    
    // MARK: - Private properties
    
    private var textFields: [BackspaceTextField] {
        return [cardNumberTextField, monthTextField, yearTextField, cvvTextField, nameTextField]
    }
    
    public lazy var nameTextField: BackspaceTextField = {
        let v = BackspaceTextField()
        v.keyboardType = .asciiCapable
        v.backspaceTextFieldDelegate = self
        v.autocapitalizationType = .allCharacters
        v.font = UIFont.systemFont(ofSize: 16)
        v.placeholder = String(
            Constants.Localizable.cardClientNameHint
        ).localized()
        v.title = String(
            Constants.Localizable.cardClientNameHint
        ).localized()
        v.delegate = self
        v.isHidden = true
        return v
    }()
    
    // MARK: - UI Elements

    private lazy var mastercardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Images.mcTranslucent, in: Bundle.module, compatibleWith: nil)
        imageView.alpha = 0.5
        return imageView
    }()

    private lazy var visaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Images.visaTranslucent, in: Bundle.module, compatibleWith: nil)
        imageView.alpha = 0.5
        return imageView
    }()
    
    public lazy var cardNumberTextField: BackspaceTextField = {
        let v = BackspaceTextField()
        v.backspaceTextFieldDelegate = self
        v.font = UIFont.systemFont(ofSize: 16)
        v.placeholder = String(
            Constants.Localizable.cardNumberHint
        ).localized()
        v.title = String(
            Constants.Localizable.cardNumberHint
        ).localized()
        v.delegate = self
        v.keyboardType = .asciiCapableNumberPad
        return v
    }()
    
    public lazy var monthTextField: BackspaceTextField = {
        let v = BackspaceTextField()
        v.backspaceTextFieldDelegate = self
        v.font = UIFont.systemFont(ofSize: 16)
        v.placeholder = String(
            Constants.Localizable.cardMonthHint
        ).localized()
        v.title = String(
            Constants.Localizable.cardMonthHint
        ).localized()
        v.delegate = self
        v.keyboardType = .asciiCapableNumberPad
        return v
    }()
    
    public lazy var yearTextField: BackspaceTextField = {
        let v = BackspaceTextField()
        v.backspaceTextFieldDelegate = self
        v.textColor = .black
        v.font = UIFont.systemFont(ofSize: 16)
        v.placeholder = String(
            Constants.Localizable.cardYearHint
        ).localized()
        v.title = String(
            Constants.Localizable.cardYearHint
        ).localized()
        v.delegate = self
        v.keyboardType = .asciiCapableNumberPad
        return v
    }()
    
    public lazy var cvvTextField: BackspaceTextField = {
        let v = BackspaceTextField()
        v.backspaceTextFieldDelegate = self
        v.isSecureTextEntry = true
        v.font = UIFont.systemFont(ofSize: 16)
        v.placeholder = String(
            Constants.Localizable.cardCvvHint
        ).localized()
        v.title = String(
            Constants.Localizable.cardCvvHint
        ).localized()
        v.delegate = self
        v.keyboardType = .asciiCapableNumberPad
        let button = UIButton(type: .contactAdd)
        button.setImage(UIImage(named: Constants.Images.cvv, in: Bundle.module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(hexString: "#DFE3E6")
        button.addTarget(self, action: #selector(cvvButtonDidPressed), for: .touchUpInside)
        v.rightView = button
        v.rightViewMode = .always
        return v
    }()
    
    private lazy var scanButton: UIButton = {
        let b = UIButton(type: .contactAdd)
        b.setImage(UIImage(named: Constants.Images.scan, in: Bundle.module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 4, right: 2)
        b.addTarget(self, action: #selector(scanButtonDidPressed), for: .touchUpInside)
        return b
    }()
    
    // MARK: - Initializers
    
    init(delegate: CreditCardViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        setupLayer()
        setupViews()
        setupConstraints()
        
        cardNumberTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        monthTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        yearTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        cvvTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public methods
    
    public func isCardLunaValid() -> Bool {
        guard let number = cardNumberTextField.text else { return false }
        return lunaValidation(number)
    }

    func setCustomStyles() {
        guard let params = colorScheme?.cardBgGradientParams,
              let color1 = params.color1,
              let color2 = params.color2,
              let textColor = colorScheme?.cardTextColor else { return }

        DispatchQueue.main.async {
            self.setGradientBackground(angle: params.angle, colors: color1.cgColor, color2.cgColor)
        }
        textFields.forEach { textField in
            textField.textColor = textColor
            textField.placeholderColor = textColor
            textField.lineColor = textColor
            textField.selectedLineColor = textColor            
            textField.titleColor = textColor
            textField.selectedTitleColor = textColor
            textField.titleFormatter = { (text: String) -> String in return text }
        }
        scanButton.tintColor = textColor
    }

    // MARK: - Private methods
    
    private func setupLayer() {
        layer.cornerRadius = 5
    }
    
    private func setupViews() {
        addSubview(mastercardImageView)
        addSubview(visaImageView)
        addSubview(cardNumberTextField)
        addSubview(scanButton)
        addSubview(monthTextField)
        addSubview(yearTextField)
        addSubview(cvvTextField)
        addSubview(nameTextField)
    }
    
    private func setupConstraints() {
        mastercardImageView.anchor(top: topAnchor, right: centerXAnchor, paddingTop: 16, paddingRight: 4)
        visaImageView.anchor(left: centerXAnchor, paddingLeft: 4, centerY: mastercardImageView.centerYAnchor)
        cardNumberTextField.anchor(top: mastercardImageView.bottomAnchor, right: scanButton.leftAnchor, left: leftAnchor, paddingTop: 32, paddingRight: 16, paddingLeft: 16)
        scanButton.anchor(right: rightAnchor, bottom: cardNumberTextField.bottomAnchor, paddingTop: 16, paddingRight: 16, width: 32, height: 32)
        monthTextField.anchor(top: cardNumberTextField.bottomAnchor, left: leftAnchor, paddingTop: 24, paddingLeft: 16)
        yearTextField.anchor(top: cardNumberTextField.bottomAnchor, left: monthTextField.rightAnchor, paddingTop: 24, paddingLeft: 16)
        let monthTFWidthAnchor = monthTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 104)
        monthTFWidthAnchor.priority = UILayoutPriority(750)
        monthTFWidthAnchor.isActive = true
        let yearTFWidthAnchor = monthTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 88)
        yearTFWidthAnchor.priority = UILayoutPriority(750)
        yearTFWidthAnchor.isActive = true
        let cvvTFWidthAnchor = monthTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 112)
        cvvTFWidthAnchor.priority = UILayoutPriority(750)
        cvvTFWidthAnchor.isActive = true
        monthTextField.widthAnchor.constraint(equalToConstant: 80).isActive = true
        yearTextField.widthAnchor.constraint(equalToConstant: 72).isActive = true
        cvvTextField.widthAnchor.constraint(equalToConstant: 104).isActive = true
        yearTextField.rightAnchor.constraint(lessThanOrEqualTo: cvvTextField.leftAnchor, constant: -16).isActive = true
        cvvTextField.anchor(top: cardNumberTextField.bottomAnchor, right: rightAnchor, paddingTop: 24, paddingRight: 16)
        nameTextField.anchor(top: cvvTextField.bottomAnchor, right: rightAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 24, paddingRight: 16, paddingLeft: 16, paddingBottom: 16)
    }
    
    @objc private func scanButtonDidPressed() {
        delegate?.scanCard()
    }
    
    @objc private func cvvButtonDidPressed() {
        delegate?.showAlert(title: String(
                                Constants.Localizable.cardCvvHintTitle
                            ).localized(),
                            message: String(
                                Constants.Localizable.cardCvvHintMessage
                            ).localized(),
                            actionTitle: String(
                                Constants.Localizable.close
                            ).localized()
        )
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text else { return }
        cardNumMaxLength = getCardNumMaxLength(cardNumberTextField.text)
        
        if textField == cardNumberTextField {
            textField.text = self.modifyCreditCardString(creditCardString: text, length: cardNumMaxLength)
            visaImageView.alpha = text.first == "4" ? 1 : 0.5
            mastercardImageView.alpha = text.first == "5" ? 1 : 0.5
        }
        
        if  text.count >= cardNumMaxLength {
            switch textField {
            case cardNumberTextField:
                cardNumberTextField.text = String(text.prefix(cardNumMaxLength))
                if text.count > cardNumMaxLength {
                    monthTextField.text = String(text.last!)
                }
                monthTextField.becomeFirstResponder()
            default:
                break
            }
        }
        
        if text.count >= 2 {
            switch textField {
            case monthTextField:
                monthTextField.text = String(text.prefix(2))
                if text.count > 2 {
                    yearTextField.text = String(text.last!)
                }
                yearTextField.becomeFirstResponder()
            case yearTextField:
                yearTextField.text = String(text.prefix(2))
                if text.count > 2 {
                    cvvTextField.text = String(text.last!)
                }
                cvvTextField.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    func modifyCreditCardString(creditCardString: String, length: Int) -> String {
        
        var whiteSpaceIndeces: [Int] = []
        
        if length == 15 + 2 {
            whiteSpaceIndeces += [4, 10]
        } else {
            whiteSpaceIndeces += [4, 8, 12]
        }
        
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        for i in 0..<arrOfCharacters.count {
            modifiedCreditCardString.append(arrOfCharacters[i])
            if (whiteSpaceIndeces.contains(i+1) && i+1 != arrOfCharacters.count) {
                modifiedCreditCardString.append(" ")
            }
        }
        
        return modifiedCreditCardString
    }
    
    private func getCardNumMaxLength(_ text: String? = "") -> Int {
        guard let text = text else { return 19 }
        cvvMaxLength = 3
        if text.prefix(1) == "3" {
            cvvMaxLength = 4
            return 15 + 2
        } else if text.prefix(1) == "4" {
            return 19 + 3
        } else if ["51", "52", "53", "54", "55"].contains(text.prefix(2)) {
            return 16 + 3
        } else if ["50", "56", "57", "58", "60", "62", "63", "67"].contains(text.prefix(2)) {
            return 19 + 3
        }
        return 16 + 3
    }
    
    private func lunaValidation(_ number: String) -> Bool {
        
        let trimmedString = Array(number.components(separatedBy: .whitespaces).joined())
        let parity = trimmedString.count % 2
        var sum = 0
        
        for i in 0..<trimmedString.count {
            var n = Int(String(trimmedString[i]))!
            if (i % 2 == parity) {
                n *= 2
                if (n > 9) {
                    n = (n % 10) + 1
                }
            }
            sum += n
        }
        return sum % 10 == 0
        
    }
}

// MARK: - Extensions

extension CreditCardView: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == monthTextField {
            if (textField.text?.count)! == 1 {
                let month = Int(textField.text!)!
                if (month < 1) {
                    textField.text = "01"
                } else {
                    textField.text = "0\(month)"
                }
            }
        }
        
        if textField == yearTextField {
            if (textField.text?.count)! == 1 {
                let currentYear = Calendar.current.component(.year, from: Date())
                let currentDecade = currentYear / 10
                let digit = Int(textField.text!)!
                var inputYear = currentDecade * 10 + digit
                if currentYear >= inputYear {
                    inputYear += 10
                }
                inputYear %= 100
                textField.text = "\(inputYear)"
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nameTextField {
            return string.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil
        }
        
        if textField == cardNumberTextField {
            if (textField.text?.count)! <= 2, let currentValue = Int(textField.text!), let newValue = Int(string) {
                if currentValue == 3 {
                    if newValue == 2 || newValue == 3 || newValue == 9 {
                        return false
                    }
                } else if currentValue == 5 {
                    if newValue == 9 {
                        return false
                    }
                } else if currentValue == 6 {
                    if newValue != 0 && newValue != 2 && newValue != 3 && newValue != 7 {
                        return false
                    }
                }
            }
        }
        
        if textField == monthTextField {
            if (textField.text?.count)! <= 2, let currentValue = Int(textField.text!), let newValue = Int(string) {
                let totalValue = currentValue*10 + newValue
                
                if totalValue < 1 || totalValue > 12 {
                    textField.text = String(currentValue)
                    return false
                }
            }
        }
        
        if textField == yearTextField {
            let currentYear = Calendar.current.component(.year, from: Date())
            var inputYear = currentYear/100 * 100
            let range = 15
            
            if let currentValue = Int(textField.text!), let newValue = Int(string) {
                let totalValue = currentValue*10 + newValue
                
                inputYear += totalValue
                if inputYear < currentYear {
                    if inputYear + 100 > currentYear + range {
                        textField.text = String(currentValue)
                        return false
                    }
                } else {
                    if inputYear >= currentYear + range {
                        textField.text = String(currentValue)
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}

extension CreditCardView: BackspaceTextFieldDelegate {
    func textFieldDidEnterBackspace(_ textField: BackspaceTextField) {
        guard let index = textFields.firstIndex(of: textField) else { return }
        
        if index > 0 {
            textFields[index - 1].becomeFirstResponder()
        } else {
            endEditing(true)
        }
    }
}
