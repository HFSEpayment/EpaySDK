//
//  TransferReceiverCell.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 20.04.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

class TransferReceiverCell: UITableViewCell {

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

    func getReceiverData() -> TransferReceiver? {
        var isValid = true
        let cardNumber = creditCardView.cardNumberTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        var isTypeCardId = false

        if let maskedCardNumber = card?.maskedCardNumber {
            isTypeCardId = cardNumber == maskedCardNumber
        }

        if !isTypeCardId && (cardNumber.count != 16 || creditCardView.isCardLunaValid() == false) {
            creditCardView.cardNumberTextField.lineColor = .red
            isValid = false
        } else {
            creditCardView.cardNumberTextField.lineColor = colorScheme?.cardTextColor ?? UIColor(hexString: "#DFE3E6")
        }
        guard isValid else { return nil }

        if isTypeCardId {
            let receiver = TransferReceiver(cardCred: card?.cardCred, transferType: "TYPECARDID")
            return receiver
        } else {
            let receiver = TransferReceiver(save: switcher.isOn, cardCred: cardNumber)
            return receiver
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

        creditCardView.forReceiver = true

        switcher.onTintColor = UIColor.mainColor
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.text = "Сохранить данные получателя"
    }
}

extension TransferReceiverCell: CreditCardViewDelegate {

    func showAlert(title: String, message: String, actionTitle: String) {}

    func scanCard() {}
}
