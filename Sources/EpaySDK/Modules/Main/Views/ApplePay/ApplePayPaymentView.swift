//
//  ApplePayPaymentView.swift
//  EpaySDK
//
//  Created by a1pamys on 2/13/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit
import PassKit

class ApplePayPaymentView: UIView {

    var delegate: PaymentViewDelegate?

    private let applePayButton = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .black)
    private let cancelButton = UIButton(type: .system)

    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet {
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

        applePayButton.addTarget(self, action: #selector(applePayButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func addSubviews() {
        addSubview(applePayButton)
        addSubview(cancelButton)
    }
    
    private func setLayoutConstraints() {
        applePayButton.anchor(
            top: topAnchor,
            right: rightAnchor,
            left: leftAnchor,
            paddingTop: 8,
            paddingRight: 16,
            paddingLeft: 16,
            height: 48
        )
        cancelButton.anchor(
            top: applePayButton.bottomAnchor,
            right: rightAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            paddingTop: 16,
            paddingRight: 16,
            paddingLeft: 16,
            paddingBottom: 8,
            height: 48
        )
    }

    private func stylize() {
        let cancelTitle = String(
            Constants.Localizable.cancel
        ).localized()
        cancelButton.layer.cornerRadius = 3
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitle(cancelTitle, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16)
    }

    @objc private func applePayButtonTapped() {
        delegate?.didTapApplePayButton()
    }

    @objc private func cancelButtonTapped() {
        delegate?.popMainViewController()
    }
}
