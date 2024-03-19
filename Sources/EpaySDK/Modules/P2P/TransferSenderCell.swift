//
//  TransferSenderCell.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 20.04.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

class TransferSenderCell: UITableViewCell {

    private let stackView = UIStackView()
    private lazy var creditCardView = CreditCardView(delegate: self)
    private let saveDataOptionView = UIView()
    private let switcher = UISwitch()
    private let descriptionLabel = UILabel()

    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet {
            creditCardView.colorScheme = colorScheme
            descriptionLabel.textColor = colorScheme?.textColor
        }
    }
    
    var publicProfile: PublicProfileResponseBody.Assets? {
        didSet {
            creditCardView.publicProfile = publicProfile
        }
    }

    var showSaveDataOption: Bool {
        get { !saveDataOptionView.isHidden }
        set { saveDataOptionView.isHidden = !newValue }
    }

    var card: CardInfo? {
        didSet {
            guard let card = card, !card.cardCred.isEmpty, !card.cardNumber.isEmpty else { return }
            creditCardView.cardNumber = card.maskedCardNumber
            creditCardView.monthTextField.text = "**"
            creditCardView.yearTextField.text = "**"
            creditCardView.cvvTextField.text = "***"
            creditCardView.nameTextField.text = card.payerName.uppercased()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func getSenderData() -> TransferSender? {
        var isValid = true
        let textFields = [creditCardView.cardNumberTextField, creditCardView.monthTextField, creditCardView.yearTextField, creditCardView.cvvTextField, creditCardView.nameTextField]
        let cardNumber = creditCardView.cardNumberTextField.text?.replacingOccurrences(of: " ", with: "")
        let month = creditCardView.monthTextField.text
        let year = creditCardView.yearTextField.text
        let cvc = creditCardView.cvvTextField.text
        let name = creditCardView.nameTextField.text
        var isTypeCardId = false

        if let maskedCardNumber = card?.maskedCardNumber {
            isTypeCardId = cardNumber == maskedCardNumber
        }

        for field in textFields {
            field.resignFirstResponder()
            if field.isHidden == false && field.text?.isEmpty != false {
                field.lineColor = .red
                isValid = false
            } else {
                field.lineColor = colorScheme?.cardTextColor ?? UIColor(hexString: "#DFE3E6")
            }
        }
        if !isTypeCardId && (cardNumber!.count + cvc!.count != 19 || creditCardView.isCardLunaValid() == false) {
            creditCardView.cardNumberTextField.lineColor = .red
            isValid = false
        }
        if (creditCardView.nameTextField.isHidden == false && name?.split(separator: " ").count != 2) {
            creditCardView.nameTextField.lineColor = .red
            isValid = false
        }
        guard isValid else { return nil }

        if isTypeCardId {
            let sender = TransferSender(cardCred: card?.cardCred, transferType: "TYPECARDID")
            return sender
        } else {
            let expiration = TransferSender.CardExpiration(month: month, year: year)
            let sender = TransferSender(save: switcher.isOn, cvc: cvc, expire: expiration, name: name, cardCred: cardNumber)
            return sender
        }
    }

    private func addSubviews() {
        contentView.addSubview(stackView)

        saveDataOptionView.addSubview(switcher)
        saveDataOptionView.addSubview(descriptionLabel)

        stackView.addArrangedSubview(creditCardView)
        stackView.addArrangedSubview(saveDataOptionView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 22),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -22)
        ]

        switcher.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            switcher.topAnchor.constraint(equalTo: saveDataOptionView.topAnchor),
            switcher.leftAnchor.constraint(equalTo: saveDataOptionView.leftAnchor),
            switcher.bottomAnchor.constraint(equalTo: saveDataOptionView.bottomAnchor)
        ]

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            descriptionLabel.centerYAnchor.constraint(equalTo: saveDataOptionView.centerYAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: switcher.rightAnchor, constant: 10),
            descriptionLabel.rightAnchor.constraint(equalTo: saveDataOptionView.rightAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        selectionStyle = .none
        backgroundColor = .clear

        stackView.axis = .vertical
        stackView.spacing = 8

        switcher.onTintColor = UIColor.mainColor
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.text = "Сохранить данные отправителя"
    }
}

extension TransferSenderCell: CreditCardViewDelegate {

    func showAlert(title: String, message: String, actionTitle: String) {}

    func scanCard() {}
}
