//
//  TitleView.swift
//  EpaySDK
//
//  Created by a1pamys on 2/6/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

protocol OrderDetailsViewDelegate: AnyObject {
    func didTapMoreInfoView()
}

class OrderDetailsView: UITableViewHeaderFooterView {

    private let logoImageView = UIImageView()
    private let orderNumberLabel = UILabel()
    private let priceLabel = UILabel()

    private let stackView = UIStackView()

    private let additionalInfoView = UIView()
    private let descriptionLabel = UILabel()
    private let commissionLabel = UILabel()
    private let commissionValueLabel = UILabel()
    private let merchantLabel = UILabel()
    private let merchantValueLabel = UILabel()

    private let moreInfoView = UIView()
    private let arrayImageView = UIImageView()
    private let moreLabel = UILabel()

    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet { setCustomStyles() }
    }

    var isAdditionalInfoEnabled = true {
        didSet {
            if !isAdditionalInfoEnabled {
                stackView.arrangedSubviews.forEach(stackView.removeArrangedSubview)
            }
            stackView.isHidden = !isAdditionalInfoEnabled
        }
    }

    var isAdditionalInfoViewHidden: Bool {
        get { additionalInfoView.isHidden }
        set {
            additionalInfoView.isHidden = newValue
            arrayImageView.transform = newValue ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: .pi)
        }
    }

    weak var delegate: OrderDetailsViewDelegate?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        addSubviews()
        setLayoutConstraints()
        stylize()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moreInfoViewTapped))
        moreInfoView.addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func set(logoImage: UIImage?) {
        let defaultImage = UIImage(named: Constants.Images.logo, in: Bundle.module, compatibleWith: nil)
        logoImageView.image = logoImage ?? defaultImage
    }

    func set(orderNumber: String) {
        let invoiceText = String(Constants.Localizable.invoiceId).localized()
        orderNumberLabel.text = invoiceText + " " + orderNumber.description
    }

    func set(amount: Double) {
        let attributedString = NSMutableAttributedString()
        let amountString = NSAttributedString(string: String(amount), attributes: [.font: UIFont.boldSystemFont(ofSize: 36)])
        let currencyString = NSAttributedString(string: " KZT", attributes: [.font: UIFont.systemFont(ofSize: 18)])
        attributedString.append(amountString)
        attributedString.append(currencyString)
        priceLabel.attributedText = attributedString
    }

    func set(description: String) {
        descriptionLabel.text = description
        
        //@Dos added break line
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .center
        descriptionLabel.sizeToFit()
    }

    func set(merchant: String) {
        merchantValueLabel.text = merchant
    }

    private func addSubviews() {
        addSubview(logoImageView)
        addSubview(orderNumberLabel)
        addSubview(priceLabel)
        addSubview(stackView)

        additionalInfoView.addSubview(descriptionLabel)
        additionalInfoView.addSubview(commissionLabel)
        additionalInfoView.addSubview(commissionValueLabel)
        additionalInfoView.addSubview(merchantLabel)
        additionalInfoView.addSubview(merchantValueLabel)

        moreInfoView.addSubview(arrayImageView)
        moreInfoView.addSubview(moreLabel)

        stackView.addArrangedSubview(additionalInfoView)
        stackView.addArrangedSubview(moreInfoView)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 34)
        ]

        orderNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            orderNumberLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            orderNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            priceLabel.topAnchor.constraint(equalTo: orderNumberLabel.bottomAnchor, constant: 4),
            priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 44)
        ]

        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
        ]

        additionalInfoView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [additionalInfoView.heightAnchor.constraint(equalToConstant: 72)]

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        layoutConstraints += [
            descriptionLabel.topAnchor.constraint(equalTo: additionalInfoView.topAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: additionalInfoView.centerXAnchor),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16),
            //@Dos added break line
            descriptionLabel.leadingAnchor.constraint(equalTo: additionalInfoView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: additionalInfoView.trailingAnchor)
        ]
        

        commissionLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            commissionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            commissionLabel.rightAnchor.constraint(equalTo: additionalInfoView.centerXAnchor, constant: -8),
            commissionLabel.heightAnchor.constraint(equalToConstant: 16)
        ]

        commissionValueLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            commissionValueLabel.topAnchor.constraint(equalTo: commissionLabel.topAnchor),
            commissionValueLabel.leftAnchor.constraint(equalTo: additionalInfoView.centerXAnchor, constant: 8),
            commissionValueLabel.heightAnchor.constraint(equalToConstant: 16)
        ]

        merchantLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            merchantLabel.topAnchor.constraint(equalTo: commissionLabel.bottomAnchor, constant: 8),
            merchantLabel.rightAnchor.constraint(equalTo: additionalInfoView.centerXAnchor, constant: -8),
            merchantLabel.heightAnchor.constraint(equalToConstant: 16)
        ]

        merchantValueLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            merchantValueLabel.topAnchor.constraint(equalTo: merchantLabel.topAnchor),
            merchantValueLabel.leftAnchor.constraint(equalTo: additionalInfoView.centerXAnchor, constant: 8),
            merchantValueLabel.heightAnchor.constraint(equalToConstant: 16)
        ]

        moreInfoView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [moreInfoView.heightAnchor.constraint(equalToConstant: 16)]

        arrayImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            arrayImageView.centerYAnchor.constraint(equalTo: moreInfoView.centerYAnchor),
            arrayImageView.rightAnchor.constraint(equalTo: moreLabel.leftAnchor, constant: -4),
            arrayImageView.widthAnchor.constraint(equalToConstant: 14),
            arrayImageView.heightAnchor.constraint(equalTo: arrayImageView.widthAnchor)
        ]

        moreLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            moreLabel.topAnchor.constraint(equalTo: moreInfoView.topAnchor),
            moreLabel.bottomAnchor.constraint(equalTo: moreInfoView.bottomAnchor),
            moreLabel.centerXAnchor.constraint(equalTo: moreInfoView.centerXAnchor),
        ]

        NSLayoutConstraint.activate(layoutConstraints)
        
    }

    private func stylize() {
        logoImageView.contentMode = .scaleAspectFit

        orderNumberLabel.font = .systemFont(ofSize: 14)

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 26

        descriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)

        commissionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        commissionLabel.text = "Комиссия"

        commissionValueLabel.font = .systemFont(ofSize: 14, weight: .medium)
        commissionValueLabel.text = "0 KZT"

        merchantLabel.font = .systemFont(ofSize: 14, weight: .regular)
        merchantLabel.text = "Продавец"

        merchantValueLabel.font = .systemFont(ofSize: 14, weight: .medium)

        let arrayImage = UIImage(named: Constants.Images.chevronDownCircleOutline, in: Bundle.module, compatibleWith: nil)
        arrayImageView.image = arrayImage?.withRenderingMode(.alwaysTemplate)

        moreLabel.font = .systemFont(ofSize: 14, weight: .medium)
        moreLabel.text = "Подробнее о заказе"
    }

    private func setCustomStyles() {
        orderNumberLabel.textColor = colorScheme?.textColor
        priceLabel.textColor = colorScheme?.textColor
        descriptionLabel.textColor = colorScheme?.buttonsColor
        commissionLabel.textColor = colorScheme?.textColor
        commissionValueLabel.textColor = colorScheme?.buttonsColor
        merchantLabel.textColor = colorScheme?.textColor
        merchantValueLabel.textColor = colorScheme?.buttonsColor
        arrayImageView.tintColor = colorScheme?.buttonsColor
        moreLabel.textColor = colorScheme?.buttonsColor
    }

    @objc private func moreInfoViewTapped() {
        delegate?.didTapMoreInfoView()
    }
}
