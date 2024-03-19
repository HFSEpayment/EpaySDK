//
//  PickedCardView.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 24.03.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

class PickedCardView: UIView {

    private let iconImageView = UIImageView()
    private let aliasLabel = UILabel()
    private let amountLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func set(card: HomeBankCard?, isCardListEmpty: Bool) {
        if isCardListEmpty {
            descriptionLabel.isHidden = false
            descriptionLabel.text = "Список карт пуст"
            descriptionLabel.textColor = UIColor(hexString: "#CBCDD5")
        } else if let card = card {
            let image = UIImage(named: card.iconName, in: Bundle.module, compatibleWith: nil)
            iconImageView.image = image
            amountLabel.text = card.displayedAmount
            descriptionLabel.isHidden = true
            descriptionLabel.text = nil

            if let cardName = card.cardName, let cardNumber = card.maskedCardNumber {
                aliasLabel.text = cardName + " " + cardNumber
            }
        } else {
            descriptionLabel.isHidden = false
            descriptionLabel.text = "Выберите карту"
            descriptionLabel.textColor = UIColor(hexString: "#7E8194")
        }
    }

    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(aliasLabel)
        addSubview(amountLabel)
        addSubview(arrowImageView)
        addSubview(descriptionLabel)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
        ]

        aliasLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            aliasLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 8),
            aliasLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            aliasLabel.rightAnchor.constraint(equalTo: arrowImageView.leftAnchor, constant: -8)
        ]

        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            amountLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            amountLabel.leftAnchor.constraint(equalTo: aliasLabel.leftAnchor),
            amountLabel.rightAnchor.constraint(equalTo: aliasLabel.rightAnchor)
        ]

        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalTo: arrowImageView.widthAnchor)
        ]

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        backgroundColor = .white
        layer.cornerRadius = 3
        layer.borderColor = UIColor(hexString: "#DFE3E6").cgColor
        layer.borderWidth = 1

        aliasLabel.font = .systemFont(ofSize: 14)
        aliasLabel.textColor = UIColor(hexString: "#7E8194")

        amountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        amountLabel.textColor = UIColor(hexString: "#071222")

        let image = UIImage(named: Constants.Images.arrowDown, in: Bundle.module, compatibleWith: nil)
        arrowImageView.image = image

        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor(hexString: "#7E8194")
        descriptionLabel.isHidden = true
    }
}
