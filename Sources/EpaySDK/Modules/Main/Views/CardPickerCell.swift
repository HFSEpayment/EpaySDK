//
//  CardPickerCell.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 25.03.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

class CardPickerCell: UITableViewCell {

    private let iconImageView = UIImageView()
    private let aliasLabel = UILabel()
    private let cardNumberLabel = UILabel()
    private let amountLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func set(card: HomeBankCard) {
        let image = UIImage(named: card.iconName, in: Bundle.module, compatibleWith: nil)
        iconImageView.image = image
        aliasLabel.text = card.cardName
        cardNumberLabel.text = card.maskedCardNumber
        amountLabel.text = card.displayedAmount
    }

    private func addSubviews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(aliasLabel)
        contentView.addSubview(cardNumberLabel)
        contentView.addSubview(amountLabel)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
        ]

        aliasLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            aliasLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 8),
            aliasLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2),
            aliasLabel.rightAnchor.constraint(equalTo: amountLabel.leftAnchor, constant: -8)
        ]

        cardNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            cardNumberLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 2),
            cardNumberLabel.leftAnchor.constraint(equalTo: aliasLabel.leftAnchor),
            cardNumberLabel.rightAnchor.constraint(equalTo: aliasLabel.rightAnchor)
        ]

        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12)
        ]
        amountLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        aliasLabel.font = .systemFont(ofSize: 14)
        aliasLabel.textColor = UIColor(hexString: "#03034B")

        cardNumberLabel.font = .systemFont(ofSize: 13)
        cardNumberLabel.textColor = UIColor(hexString: "#7E8194")

        amountLabel.font = .systemFont(ofSize: 14)
        amountLabel.textAlignment = .right
        amountLabel.textColor = UIColor(hexString: "#071222")
    }
}
