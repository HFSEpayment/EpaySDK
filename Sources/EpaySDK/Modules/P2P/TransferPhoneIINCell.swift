//
//  TransferPhoneIINCell.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 14.06.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

protocol TransferPhoneIINCellDelegate: AnyObject {
    func didPressContactsButton()
}

class TransferPhoneIINCell: UITableViewCell {

    private let containerView = UIView()
    private let phoneTextField = SkyFloatingLabelTextField()
    private let iinTextField = SkyFloatingLabelTextField()
    private let contactsButton = UIButton()

    private let phoneInputListener = MaskedTextInputListener()
    private let iinInputListener = MaskedTextInputListener()

    weak var delegate: TransferPhoneIINCellDelegate?

    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet { setCustomStyles() }
    }

    var phoneNumber: String? {
        didSet {
            phoneTextField.text = phoneNumber
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setLayoutConstraints()
        stylize()

        contactsButton.addTarget(self, action: #selector(contactsButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func getReceiverData() -> TransferReceiver? {
        var isValid = true
        let phone = phoneTextField.text?.phoneNumber ?? ""
        let iin = iinTextField.text ?? ""

        if phone.count != 11 {
            phoneTextField.lineColor = .red
            phoneTextField.errorMessage = phone.isEmpty ? "Заполните поле" : "Неверный номер телефона"
            isValid = false
        } else {
            phoneTextField.lineColor = colorScheme?.cardTextColor ?? UIColor(hexString: "#DFE3E6")
            phoneTextField.errorMessage = nil
        }
        if !IINTextValidator().validateCharacters(in: iin) {
            iinTextField.lineColor = .red
            iinTextField.errorMessage = iin.isEmpty ? "Заполните поле" : "Неверный ИИН"
            isValid = false
        } else {
            iinTextField.lineColor = colorScheme?.cardTextColor ?? UIColor(hexString: "#DFE3E6")
            iinTextField.errorMessage = nil
        }
        guard isValid else { return nil }

        let receiver = TransferReceiver(transferType: "TYPEPHONE", phone: phone, iin: iin)
        return receiver
    }

    private func addSubviews() {
        contentView.addSubview(containerView)

        containerView.addSubview(phoneTextField)
        containerView.addSubview(iinTextField)
        containerView.addSubview(contactsButton)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 22),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -22),
            containerView.heightAnchor.constraint(equalToConstant: 205)
        ]

        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            phoneTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            phoneTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16),
            phoneTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16)
        ]

        iinTextField.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iinTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 24),
            iinTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16),
            iinTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16)
        ]

        contactsButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            contactsButton.bottomAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: -6),
            contactsButton.rightAnchor.constraint(equalTo: phoneTextField.rightAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        selectionStyle = .none
        backgroundColor = .clear

        containerView.layer.cornerRadius = 5

        phoneInputListener.primaryMaskFormat = "+7 [000] [000] [0000]"
        phoneTextField.delegate = phoneInputListener
        phoneTextField.keyboardType = .asciiCapableNumberPad
        phoneTextField.font = .systemFont(ofSize: 16)
        phoneTextField.placeholder = "Номер телефона получателя"
        phoneTextField.title = "Номер телефона получателя"
        phoneTextField.keyboardType = .numberPad
        phoneTextField.errorColor = .red

        iinInputListener.primaryMaskFormat = "[000000000000]"
        iinTextField.delegate = iinInputListener
        iinTextField.font = .systemFont(ofSize: 16)
        iinTextField.placeholder = "ИИН получателя"
        iinTextField.title = "ИИН получателя"
        iinTextField.keyboardType = .numberPad
        iinTextField.errorColor = .red
        iinTextField.keyboardType = .asciiCapableNumberPad

        let image = UIImage(named: Constants.Images.personCircle, in: Bundle.module, compatibleWith: nil)
        contactsButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    private func setCustomStyles() {
        guard let params = colorScheme?.cardBgGradientParams,
              let color1 = params.color1,
              let color2 = params.color2,
              let textColor = colorScheme?.cardTextColor else { return }

        DispatchQueue.main.async {
            self.containerView.setGradientBackground(angle: params.angle, colors: color1.cgColor, color2.cgColor)
        }
        [phoneTextField, iinTextField].forEach { textField in
            textField.textColor = textColor
            textField.placeholderColor = textColor
            textField.lineColor = textColor
            textField.selectedLineColor = textColor
            textField.titleColor = textColor
            textField.selectedTitleColor = textColor
            textField.titleFormatter = { (text: String) -> String in return text }
        }
        contactsButton.tintColor = textColor
    }

    @objc private func contactsButtonTapped() {
        delegate?.didPressContactsButton()
    }
}
