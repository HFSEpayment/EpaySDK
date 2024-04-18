//
//  InstallmentInfoView.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 09.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import UIKit

class InstallmentInfoView: UIView {
    var amount: Double = 0 {
        didSet {
            amountLabel.text = "\(amount) KZT"
            let s = "\(amount) KZT"
            let attributedString = NSMutableAttributedString(string: s)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(location: s.count - 3, length: 3))
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 36), range: NSRange(location: 0, length: s.count - 3))
            amountLabel.attributedText = attributedString
        }
    }
    
    var commission: Double = 0 {
        didSet {
            commissionLabel.text = String(
                Constants.Localizable.commission
            ).localized() + ": \(commission) KZT"
        }
    }
    
    var seller: String = "" {
        didSet {
            sellerLabel.text = String(
                Constants.Localizable.seller
            ).localized() + ": \(seller)"
        }
    }
    
    var orderNumber: String = "" {
        didSet {
            orderNumberLabel.text = String(
                Constants.Localizable.order
            ).localized() + orderNumber
        }
    }
    
    var paymentDescription: String = "" {
        didSet {
            paymentDescriptionLabel.text = paymentDescription
        }
    }
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Images.logo, in: Bundle.module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var orderNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#566681")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#03034B")
        label.font = UIFont.systemFont(ofSize: 36)
        return label
    }()
    
    private lazy var paymentDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = String(Constants.Localizable.paymentInOnlineShop).localized()
        label.textColor = UIColor(hexString: "#071222")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var commissionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#566681")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var sellerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#566681")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension InstallmentInfoView {
    func setup() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(orderNumberLabel)
        stackView.addArrangedSubview(amountLabel)
        stackView.addArrangedSubview(paymentDescriptionLabel)
        stackView.addArrangedSubview(commissionLabel)
        stackView.addArrangedSubview(sellerLabel)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        stackView.fillSuperview()
        
        stackView.addCustomSpacing(15, after: logoImageView)
        stackView.addCustomSpacing(16, after: orderNumberLabel)
        stackView.addCustomSpacing(16, after: amountLabel)
        stackView.addCustomSpacing(16, after: paymentDescriptionLabel)
        stackView.addCustomSpacing(5, after: commissionLabel)
    }
}
