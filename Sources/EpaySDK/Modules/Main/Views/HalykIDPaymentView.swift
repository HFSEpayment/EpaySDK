//
//  HalykIDPaymentView.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 24.03.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

class HalykIDPaymentView: UIView {

    private let payFromLabel = UILabel()
    private let pickedCardView = PickedCardView()
    private lazy var bonusView = BonusView(price: amount ?? 0)
    private let payButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    weak var delegate: PaymentViewDelegate?

    var amount: Double?
    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet {
            payFromLabel.textColor = colorScheme?.textColor
            cancelButton.layer.borderColor = colorScheme?.buttonsColor?.cgColor
            cancelButton.setTitleColor(colorScheme?.buttonsColor, for: .normal)
        }
    }

    init(delegate: PaymentViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)

        addSubviews()
        stylize()
        setLayoutConstraints()
        setActions()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func showBonusView(goBonus: Double) {
        bonusView.setBonus(bonus: goBonus)
        bonusView.isHidden = false
        delegate?.updateTableView()
    }

    func set(card: HomeBankCard?, isCardListEmpty: Bool) {
        pickedCardView.isUserInteractionEnabled = !isCardListEmpty
        pickedCardView.set(card: card, isCardListEmpty: isCardListEmpty)

        payButton.isEnabled = card != nil
        payButton.backgroundColor = card != nil ? colorScheme?.buttonsColor : UIColor.lightGray
    }

    private func addSubviews() {
        addSubview(payFromLabel)
        addSubview(pickedCardView)
        addSubview(bonusView)
        addSubview(payButton)
        addSubview(cancelButton)
    }

    private func setLayoutConstraints() {
        payFromLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 22)
        pickedCardView.anchor(top: payFromLabel.bottomAnchor, right: rightAnchor, left: leftAnchor, paddingTop: 4, paddingRight: 22, paddingLeft: 22, height: 59)
        bonusView.anchor(top: pickedCardView.bottomAnchor, right: pickedCardView.rightAnchor, left: pickedCardView.leftAnchor)
        payButton.anchor(top: bonusView.bottomAnchor, right: rightAnchor, left: leftAnchor, paddingTop: 20, paddingRight: 16, paddingLeft: 16, height: 48)
        cancelButton.anchor(top: payButton.bottomAnchor, right: rightAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 16, paddingRight: 16, paddingLeft: 16, paddingBottom: 8, height: 48)
    }

    private func stylize() {
        payFromLabel.font = .systemFont(ofSize: 14)
        payFromLabel.text = "Оплатить с"

        bonusView.isHidden = true

        let payTitle = String(
            Constants.Localizable.payAmount
        ).localized()
        payButton.backgroundColor = UIColor.lightGray
        payButton.layer.cornerRadius = 3
        payButton.setTitle(payTitle, for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        payButton.isEnabled = false

        let cancelTitle = String(
            Constants.Localizable.cancel
        ).localized()
        cancelButton.layer.cornerRadius = 3
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitle(cancelTitle, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16)
    }

    private func setActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectCardView))
        pickedCardView.addGestureRecognizer(tapGesture)

        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }

    @objc private func didSelectCardView() {
        delegate?.showCardPicker(under: pickedCardView)
    }

    @objc private func payButtonTapped() {
        delegate?.makeHalykIDPayment(useGoBonus: bonusView.shouldUseGoBonus())
    }

    @objc private func cancelButtonTapped() {
        delegate?.popMainViewController()
    }
}
