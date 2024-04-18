//
//  CreditCardPaymentView.swift
//  EpaySDK
//
//  Created by a1pamys on 2/13/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

class CreditCardPaymentView: UIView {
    
    // MARK: - Public properties
    
    weak var delegate: PaymentViewDelegate?
    var isMasterPass: Bool = false
    private let saveDataOptionView = UIView()
    private let switcher = UISwitch()
    private let descriptionLabel = UILabel()
    var amount: Double? {
        didSet {
            if let amount = amount {
                payButton.setAttributedTitle(
                    NSAttributedString(
                        string:
                            String(
                                Constants.Localizable.payAmount
                            ).localized() + " " + String(amount) + " KZT",
                                                                
                        attributes: [
                            NSAttributedString.Key.foregroundColor : colorScheme?.bgGradientParams.color1 ?? UIColor.white,
                            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
                        ]
                    ),
                    for: .normal
                )
            }
        }
    }
    
    var masterPassData: MasterPassData? {
        didSet {
            setCardDataFromMasterPass()
        }
    }

    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet { setCustomStyles() }
    }
    
    
    var publicProfile: PublicProfileResponseBody.Assets? {
        didSet {
            contactInfoView.publicProfile = publicProfile
            creditCardView.publicProfile = publicProfile
        }
    }
    
    
    // MARK: - UI Elements
    
    private lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .fill
        v.alignment = .fill
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = String(
            Constants.Localizable.fillInCardDetails
        ).localized()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()
    
    public lazy var creditCardView: CreditCardView = {
        let v = CreditCardView(delegate: self)
        return v
    }()
    
    var showSaveDataOption: Bool {
        get { !saveDataOptionView.isHidden }
        set { saveDataOptionView.isHidden = !newValue }
    }
    
    private lazy var bonusView = BonusView(price: amount ?? 0)
    private lazy var contactInfoView = ContactInfoView()
    
    func preEmailandPhone (invoice: Invoice?) {
        contactInfoView.emailTextField.text = invoice?.email
        contactInfoView.phoneTextField.text = invoice?.phone
    }
    
    private lazy var payButton: UIButton = {
        let b = UIButton()
        b.tag = 0 // 0 - disabled, 1 - enabled
        b.layer.cornerRadius = 3
        b.backgroundColor = UIColor.lightGray
        b.setAttributedTitle(NSAttributedString(string: String(Constants.Localizable.payAmount).localized(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]),
                             for: .normal)
        b.setTitleColor(.clear, for: .normal)
        b.addTarget(self, action: #selector(onPayButtonDidPressed), for: .touchUpInside)
        return b
    }()
    
    private lazy var cancelButton: UIButton = {
        let string = String(
            Constants.Localizable.cancel
        ).localized()
        let attributedString = NSAttributedString(
            string: string,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        )
        let b = UIButton()
        b.layer.cornerRadius = 3
        b.layer.borderWidth = 1
        b.setAttributedTitle(attributedString, for: .normal)
        b.addTarget(self, action: #selector(onCancelButtonDidPressed), for: .touchUpInside)
        return b
    }()
    
    // MARK: - Initializers
    
    init(delegate: PaymentViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    public func showBonusView(goBonus: Double) {
        bonusView.setBonus(bonus: goBonus)
        bonusView.isHidden = false
        bonusView.colorScheme = colorScheme
        stackView.insertArrangedSubview(bonusView, at: 2)
        delegate?.updateTableView()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(creditCardView)
        
        saveDataOptionView.addSubview(switcher)
        saveDataOptionView.addSubview(descriptionLabel)
        saveDataOptionView.isHidden = true

        stackView.addArrangedSubview(saveDataOptionView)
        stackView.addArrangedSubview(contactInfoView)
        stackView.addArrangedSubview(payButton)
        stackView.addArrangedSubview(cancelButton)
        
        
        creditCardView.cardNumberTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
        for: .editingChanged)
        creditCardView.monthTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
        for: .editingChanged)
        creditCardView.yearTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
        for: .editingChanged)
        creditCardView.cvvTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
        for: .editingChanged)
        creditCardView.nameTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
        for: .editingChanged)
        contactInfoView.emailTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        contactInfoView.phoneTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    }
    
    private func setupConstraints() {
        
        switcher.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.anchor(top: topAnchor, right: rightAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 8, paddingRight: 16, paddingLeft: 16, paddingBottom: 24)
        stackView.addCustomSpacing(6, after: titleLabel)
        stackView.addCustomSpacing(16, after: creditCardView)
        switcher.anchor(top: saveDataOptionView.topAnchor, left: saveDataOptionView.leftAnchor, bottom: saveDataOptionView.bottomAnchor)
        descriptionLabel.anchor(right: saveDataOptionView.rightAnchor, left: switcher.rightAnchor, paddingLeft: 8, centerY: saveDataOptionView.centerYAnchor)
        
        stackView.addCustomSpacing(44, after: contactInfoView)
        stackView.addCustomSpacing(16, after: payButton)
        payButton.anchor(height: 48)
        cancelButton.anchor(height: 48)
    }

    private func setCustomStyles() {
        creditCardView.colorScheme = colorScheme
        cancelButton.layer.borderColor = colorScheme?.buttonsColor?.cgColor
        cancelButton.setTitleColor(colorScheme?.buttonsColor, for: .normal)
        
        switcher.onTintColor = UIColor.mainColor
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.text = String(
            Constants.Localizable.saveCard
        ).localized()
        

        if let textColor = colorScheme?.textColor {
            descriptionLabel.textColor = textColor
            titleLabel.textColor = textColor
            contactInfoView.setCustom(textColor: textColor)
        }
    }
    
    private func setCardDataFromMasterPass() {
        let byMasterPass = (publicProfile?.payment_view_settings?.byMasterPass ?? false) && (masterPassData?.isVisible ?? false)
        
        if byMasterPass == true {
            isMasterPass = true
            creditCardView.cardNumberTextField.text = creditCardView.modifyCreditCardString(creditCardString: masterPassData?.cardData?.maskedCardNumber ?? "", length: creditCardView.cardNumMaxLength)
        
            creditCardView.monthTextField.text = masterPassData?.cardData?.ExpMonth ?? ""
            creditCardView.yearTextField.text = masterPassData?.cardData?.ExpYear ?? ""
            creditCardView.nameTextField.text = masterPassData?.cardData?.CardHolder ?? ""
            showSaveDataOption = true
            switcher.isOn = masterPassData?.masterPassAction.SaveCard ?? false
        } else {
            showSaveDataOption = false
        }
    }

    @objc private func onPayButtonDidPressed() {
        if payButton.tag != 1 {
            return
        }
        
        let textfields = [creditCardView.cardNumberTextField, creditCardView.monthTextField, creditCardView.yearTextField, creditCardView.cvvTextField]
        
        for t in textfields {
            t.resignFirstResponder()
            if t.text?.count == 0 {
                (t as SkyFloatingLabelTextField).lineColor = .red
            } else {
                (t as SkyFloatingLabelTextField).lineColor = UIColor(hexString: "#DFE3E6")
            }
        }
        
        if
            creditCardView.cardNumberTextField.text!.count + creditCardView.cvvTextField.text!.count != 19 ||
            (isMasterPass == false && creditCardView.isCardLunaValid() == false)
        {
            creditCardView.cardNumberTextField.lineColor = .red
        }
        
    
        if (creditCardView.nameTextField.isHidden == false && !creditCardView.nameTextField.text!.isEmpty && (creditCardView.nameTextField.text?.split(separator: " ").count)! < 2) {
            creditCardView.nameTextField.lineColor = .red
        }
        
        contactInfoView.validate()
        
        
        let email = contactInfoView.emailTextField.text
        let name = creditCardView.nameTextField.text
        let phone = contactInfoView.phoneTextField.text
        let pan = creditCardView.cardNumberTextField.text!.replacingOccurrences(of: " ", with: "")
        let expDate = creditCardView.monthTextField.text! + creditCardView.yearTextField.text!
        let cvc = (Int(creditCardView.cvvTextField.text!))!
        let useGoBonus = bonusView.shouldUseGoBonus()
        let saveCard = switcher.isOn
        delegate?.makePayment(pan: pan, expDate: expDate, cvc: cvc, name: name, email: email, phone: phone, useGoBonus: useGoBonus, isMasterPass: isMasterPass, saveCard: saveCard)
    }
    
    @objc private func onCancelButtonDidPressed() {
        delegate?.popMainViewController()
    }
    
    @objc private func textFieldsIsNotEmpty(sender: UITextField) {
        checkIsMasterPass()
        setPayButtonAvailability()
        setBonusViewVisibility()
    }
    
    private func checkIsMasterPass() {
        if creditCardView.cardNumberTextField.text != nil && creditCardView.cardNumberTextField.text!.count <= 7 {
            isMasterPass = false
        }
    }
    
    private func setPayButtonAvailability() {
        guard
            let pan = creditCardView.cardNumberTextField.text, !pan.isEmpty,
            (pan.count >= creditCardView.cardNumMaxLength - creditCardView.cvvMaxLength && pan.count <= creditCardView.cardNumMaxLength),
            isValidLunaAndMasterPass() == true,
            let month = creditCardView.monthTextField.text, !month.isEmpty,
            let year = creditCardView.yearTextField.text, !year.isEmpty,
            let cvc = creditCardView.cvvTextField.text, !cvc.isEmpty,
            cvc.count == creditCardView.cvvMaxLength
            else
        {
            self.payButton.backgroundColor = .lightGray
            self.payButton.tag = 0
            return
        }
        
        if (contactInfoView.isValid()) {
            if (creditCardView.nameTextField.isHidden == false) {
                if (creditCardView.nameTextField.text!.isEmpty) {
                    self.payButton.backgroundColor = .lightGray
                    self.payButton.tag = 0
                } else {
                    payButton.backgroundColor = colorScheme?.buttonsColor
                    payButton.tag = 1
                }
            } else {
                payButton.backgroundColor = colorScheme?.buttonsColor
                payButton.tag = 1
            }
        } else {
            self.payButton.backgroundColor = .lightGray
            self.payButton.tag = 0
            
        }
    }
    
    private func isValidLunaAndMasterPass() -> Bool {
        if isMasterPass == true {
            return true
        } else {
            return creditCardView.isCardLunaValid() == true
        }
    }
    
    private func setBonusViewVisibility() {
        guard
            var pan = creditCardView.cardNumberTextField.text,
            (pan.count >= creditCardView.cardNumMaxLength - creditCardView.cvvMaxLength && pan.count <= creditCardView.cardNumMaxLength),
            isValidLunaAndMasterPass() == true,
            let month = creditCardView.monthTextField.text, month.count == 2,
            let year = creditCardView.yearTextField.text, year.count == 2,
            let cvc = creditCardView.cvvTextField.text,
            cvc.count == creditCardView.cvvMaxLength,
            isHalykCard() == true
            else
        {
            bonusView.isHidden = true
            stackView.removeArrangedSubview(bonusView)
            delegate?.updateTableView()
            return
        }
                
        pan = creditCardView.cardNumberTextField.text!.replacingOccurrences(of: " ", with: "")
        let expDate = creditCardView.monthTextField.text! + creditCardView.yearTextField.text!
        delegate?.requestGoBonus(pan: pan, expDate: expDate, cvc: Int(cvc)!)
    }
    
    private func isHalykCard() -> Bool {
        guard let bankBinModels = BankBinModel.getBankBinModel() else { return false }
        
        guard let firstSixDigitsOfCard = Int(creditCardView.cardNumberTextField.text!.replacingOccurrences(of: " ", with: "").prefix(6)) else { return false }
        
        for model in bankBinModels {
            if model.code == "halykbank", model.bins?.contains(firstSixDigitsOfCard) == true {
                return true
            }
        }
        return false
    }
}

// MARK: - Extensions

extension CreditCardPaymentView: CreditCardViewDelegate {
    func scanCard() {
        delegate?.scanCard()
    }
    
    func showAlert(title: String, message: String, actionTitle: String) {
        delegate?.showAlert(title: title, message: message, actionTitle: actionTitle)
    }
}
