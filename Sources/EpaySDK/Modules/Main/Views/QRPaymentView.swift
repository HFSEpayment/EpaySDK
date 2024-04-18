//
//  QRPaymentView.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 07.03.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

class QRPaymentView: UIView {

    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    private let payButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    weak var delegate: PaymentViewDelegate?

    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet {
            descriptionLabel.textColor = colorScheme?.textColor
            payButton.backgroundColor = colorScheme?.buttonsColor
            cancelButton.layer.borderColor = colorScheme?.buttonsColor?.cgColor
            cancelButton.setTitleColor(colorScheme?.buttonsColor, for: .normal)
        }
    }

    init(delegate: PaymentViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)

        addSubviews()
        setLayoutConstraints()
        stylize()

        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setQR(image: UIImage?) {
        imageView.image = image
    }

    private func addSubviews() {
        addSubview(descriptionLabel)
        addSubview(imageView)
        addSubview(payButton)
        addSubview(cancelButton)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            descriptionLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: -28),
            descriptionLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: 28)
        ]

        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ]

        payButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            payButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            payButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            payButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 48)
        ]

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            cancelButton.topAnchor.constraint(equalTo: payButton.bottomAnchor, constant: 16),
            cancelButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            cancelButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 48)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        descriptionLabel.textColor = UIColor(hexString: "#7E8194")
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = String(
            Constants.Localizable.scanQRToPay
        ).localized()
        

        imageView.contentMode = .scaleToFill

        payButton.backgroundColor = UIColor.lightGray
        payButton.layer.cornerRadius = 3
        payButton.setTitle("Оплатить в Homebank", for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.titleLabel?.font = .boldSystemFont(ofSize: 16)        

        let cancelTitle = String(
            Constants.Localizable.cancel
        ).localized()
        cancelButton.layer.cornerRadius = 3
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitle(cancelTitle, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16)
    }

    @objc private func payButtonTapped() {
        delegate?.didTapPayInHomebank()
    }

    @objc private func cancelButtonTapped() {
        delegate?.popMainViewController()
    }
}
