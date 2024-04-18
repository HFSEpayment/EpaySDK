//
//  TransferHeader.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 18.04.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

class TransferHeader: UITableViewHeaderFooterView {

    private let logoImageView = UIImageView()
    private let leftLineView = UIView()
    private let titleLabel = UILabel()
    private let rightLineView = UIView()

    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet { setCustomStyle() }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func addSubviews() {
        addSubview(logoImageView)
        addSubview(leftLineView)
        addSubview(titleLabel)
        addSubview(rightLineView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 44)
        ]

        leftLineView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            leftLineView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            leftLineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 22),
            leftLineView.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -16),
            leftLineView.heightAnchor.constraint(equalToConstant: 1)
        ]

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ]

        rightLineView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            rightLineView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            rightLineView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 16),
            rightLineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -22),
            rightLineView.heightAnchor.constraint(equalToConstant: 1)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        backgroundColor = .clear

        logoImageView.image = UIImage(named: Constants.Images.logo, in: Bundle.module, compatibleWith: nil)
        logoImageView.contentMode = .scaleAspectFit

        titleLabel.text = String(
            Constants.Localizable.fillInCardDetails
        ).localized()
        titleLabel.font = UIFont.systemFont(ofSize: 13)

        leftLineView.backgroundColor = .lightGray
        rightLineView.backgroundColor = .lightGray
    }

    private func setCustomStyle() {
        titleLabel.textColor = colorScheme?.textColor
        leftLineView.backgroundColor = colorScheme?.textColor
        rightLineView.backgroundColor = colorScheme?.textColor
    }
}
