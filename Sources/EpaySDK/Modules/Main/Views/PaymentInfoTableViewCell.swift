//
//  PaymentInfoCollectionViewCell.swift
//  EpaySDK
//
//  Created by a1pamys on 2/11/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

class PaymentInfoTableViewCell: UITableViewCell {

    // MARK: - Public properties
    
    static let cellId = "paymentInfoTableViewCellId"
    
    var amount: Double? {
        didSet {
            creditCardPaymentView.amount = amount
            halykIdPaymentView.amount = amount
        }
    }
    var masterPassData: MasterPassData? {
        didSet {
            creditCardPaymentView.masterPassData = masterPassData
        }
    }
    var months: [Int]? {
        didSet {
            if let months = months {
                installmentPaymentView.months = months
            }
        }
    }
    var monthlyPaymentAmount: Double = 0 {
        didSet {
            installmentPaymentView.amount = monthlyPaymentAmount
        }
    }
    var overpaymentAmount: Double = 0 {
        didSet {
            installmentPaymentView.overpayment = overpaymentAmount
        }
    }
    var selectedMonthIndex: Int = 0 {
        didSet {
            installmentPaymentView.selectedSegmentIndex = selectedMonthIndex
        }
    }
    var qrLinkInfo = QRLinkInfo() {
        didSet {
            installmentPaymentView.qrLinkInfo = qrLinkInfo
        }
    }
    
    var paymentTag: Int = 0 {
        didSet {
            if paymentTag == 0 {
                creditCardPaymentView.isHidden = false
                installmentPaymentView.isHidden = true
                
            } else {
                installmentPaymentView.isHidden = false
                creditCardPaymentView.isHidden = true
            }
        }
    }
    
    var showQR: Bool = true {
        didSet {
            installmentPaymentView.showQR = showQR
        }
    }

    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet {
            creditCardPaymentView.colorScheme = colorScheme
            qrPaymentView.colorScheme = colorScheme
            halykIdPaymentView.colorScheme = colorScheme
            applePayPaymentView.colorScheme = colorScheme
            installmentPaymentView.colorScheme = colorScheme
        }
    }
    
    var publicProfile: PublicProfileResponseBody.Assets? {
        didSet {
            creditCardPaymentView.publicProfile = publicProfile
        }
    }

    var paymentType: PaymentType = .creditCard {
        didSet {
            creditCardPaymentView.isHidden = paymentType != .creditCard
            qrPaymentView.isHidden = paymentType != .QR
            halykIdPaymentView.isHidden = paymentType != .halykID
            applePayPaymentView.isHidden = paymentType != .applePay
            installmentPaymentView.isHidden = paymentType != .installment
        }
    }
    
    var qrImage: UIImage? {
        didSet {
            qrPaymentView.setQR(image: qrImage)
        }
    }
    
    
    weak var delegate: PaymentInfoTableViewCellDelegate?
    
    // MARK: - UI Elements
    public lazy var creditCardPaymentView = CreditCardPaymentView(delegate: self)
    public lazy var applePayPaymentView = ApplePayPaymentView(delegate: self)
    public lazy var installmentPaymentView = InstallmentPaymentView(delegate: self)
    public lazy var qrPaymentView = QRPaymentView(delegate: self)
    public lazy var halykIdPaymentView = HalykIDPaymentView(delegate: self)
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods

    func set(card: HomeBankCard?, isCardListEmpty: Bool) {
        halykIdPaymentView.set(card: card, isCardListEmpty: isCardListEmpty)
    }
    
    func preEmailandPhone (invoice: Invoice?) {
        creditCardPaymentView.preEmailandPhone(invoice: invoice)
    }

    // MARK: - Private methods
    
    private func setupViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(creditCardPaymentView)
        stackView.addArrangedSubview(installmentPaymentView)
        stackView.addArrangedSubview(qrPaymentView)
        stackView.addArrangedSubview(halykIdPaymentView)
        stackView.addArrangedSubview(applePayPaymentView)
    }
    
    private func setupConstraints() {
        stackView.fillSuperview()
    }
}

// MARK: - Extensions

extension PaymentInfoTableViewCell: CreditCardViewDelegate {
    func scanCard() {
        delegate?.scanCard()
    }
    
    func showAlert(title: String, message: String, actionTitle: String) {
        delegate?.showAlert(title: title, message: message, actionTitle: actionTitle)
    }
}

extension PaymentInfoTableViewCell: PaymentViewDelegate {
    func makeInstallment() {
        delegate?.makeInstallment()
    }
    
    func installmentMonthsChanged(to months: String) {
        delegate?.installmentMonthsChanged(to: months)
    }
    
    func popMainViewController() {
        delegate?.popMainViewController()
    }
    
    func makePayment(pan: String, expDate: String, cvc: Int, name: String?, email: String?, phone: String?, useGoBonus: Bool, isMasterPass: Bool?, saveCard: Bool?) {
        delegate?.makePayment(pan: pan, expDate: expDate, cvc: cvc, name: name, email: email, phone: phone, useGoBonus: useGoBonus, isMasterPass: isMasterPass, saveCard: saveCard)
    }
    
    func updateTableView() {
        delegate?.updateTableView()
    }
    
    func requestGoBonus(pan: String, expDate: String, cvc: Int) {
        delegate?.requestGoBonus(pan: pan, expDate: expDate, cvc: cvc)
    }

    func showCardPicker(under cardView: UIView) {
        delegate?.showCardPicker(under: cardView)
    }

    func makeHalykIDPayment(useGoBonus: Bool) {
        delegate?.makeHalykIDPayment(useGoBonus: useGoBonus)
    }

    func didTapPayInHomebank() {
        delegate?.didTapPayInHomebank()
    }
    
    func didTapApplePayButton() {
        delegate?.didTapApplePayButton()
    }
}
