//
//  SuccessViewController.swift
//  EpaySDK
//
//  Created by a1pamys on 2/12/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var paymentModel: PaymentModel!
    
    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = .clear
        if #available(iOS 11.0, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
        return v
    }()
    
    private lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 8
        v.distribution = .fill
        v.alignment = .fill
        return v
    }()
    
    private lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: Constants.Images.success, in: Bundle.module, compatibleWith: nil)
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private lazy var logoImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: Constants.Images.logo, in: Bundle.module, compatibleWith: nil)
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private lazy var responseLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 22)
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var invoiceIdLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    private lazy var referenceLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    private lazy var priceLabel: UILabel = {
        let l = UILabel()
        let s = String(paymentModel.invoice.amount) + " KZT"
        l.textAlignment = .center
        let attributedString = NSMutableAttributedString(string: s)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: NSRange(location: s.count - 3, length: 3))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 36), range: NSRange(location: 0, length: s.count - 3))
        l.attributedText = attributedString
        return l
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = paymentModel.invoice.description
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()

    private let sellerView = UIView()
    private let sellerLabel = UILabel()
    private let sellerValueLabel = UILabel()

    private let commissionView = UIView()
    private let commissionLabel = UILabel()
    private let commissionValueLabel = UILabel()

    private let senderView = UIView()
    private let senderLabel = UILabel()
    private let senderCardImageView = UIImageView()
    private let senderCardLabel = UILabel()

    private let receiverView = UIView()
    private let receiverLabel = UILabel()
    private let receiverCardImageView = UIImageView()
    private let receiverCardLabel = UILabel()
    
    private lazy var fillerView = UIView()
    
    private lazy var closeButton: UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 3
        b.layer.borderWidth = 1
        b.setAttributedTitle(NSAttributedString(string: String(Constants.Localizable.close).localized(),
                                                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]), for: .normal)
        b.addTarget(self, action: #selector(closeButtonDidPressed), for: .touchUpInside)
        return b
    }()
    
    private lazy var recurrentPaymentView: UIView = {
        let v = UIView()
        let l = UILabel()
        var string: String
        switch paymentModel.invoice.autoPaymentFrequency {
        case .weekly:
            string = Constants.Localizable.weeklyAutopaymentQuestion
        case .monthly:
            string = Constants.Localizable.monthlyAutopaymentQuestion
        case .quarterly:
            string = Constants.Localizable.quarterlyAutopaymentQuestion
        }
        l.text = String(string).localized()
        
        let colorScheme = paymentModel.publicProfile?.assets?.color_scheme
        if let textColor = paymentModel.publicProfile?.assets?.color_scheme?.textColor {
            l.textColor = textColor
        } else {
            l.textColor = .black
        }
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 0
        let s = UISwitch()
        s.onTintColor = UIColor.mainColor
        s.addTarget(self, action: #selector(handleToggleSwitch), for: .valueChanged)
        v.addSubview(l)
        v.addSubview(s)
        l.anchor(top: v.topAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, paddingLeft: 16)
        s.anchor(top: v.topAnchor, right: v.rightAnchor, left: l.rightAnchor, paddingRight: 16, paddingLeft: 8)
        return v
    }()
    
    private lazy var subscribeButton: UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 3
        b.setAttributedTitle(NSAttributedString(string: String(Constants.Localizable.confirmSubscribe).localized(),
                                                attributes: [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]),
                             for: .normal)
        b.addTarget(self, action: #selector(onSubscribeButtonDidPressed), for: .touchUpInside)
        b.isHidden = true
        return b
    }()

    private var isReccurantPaymentAvailable: Bool {
        return paymentModel.invoice.isRecurrent == true && paymentModel.invoice.transferType == nil
    }
    
    // MARK: - Initializer
    init(paymentModel: PaymentModel) {
        super.init(nibName: nil, bundle: nil)
        self.paymentModel = paymentModel
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //@Dos added for some merchant autoRedirect
        if paymentModel.invoice.autoRedirect == true {
            closeButtonDidPressed()
        }
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()

        setupViews()
        setupConstraints()
        stylize()
        setTexts()
        setCustomStyle()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        view.addSubview(scrollView)

        scrollView.addSubview(stackView)

        commissionView.addSubview(commissionLabel)
        commissionView.addSubview(commissionValueLabel)

        sellerView.addSubview(sellerLabel)
        sellerView.addSubview(sellerValueLabel)

        senderView.addSubview(senderLabel)
        senderView.addSubview(senderCardImageView)
        senderView.addSubview(senderCardLabel)

        receiverView.addSubview(receiverLabel)
        receiverView.addSubview(receiverCardImageView)
        receiverView.addSubview(receiverCardLabel)

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(responseLabel)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(invoiceIdLabel)
        stackView.addArrangedSubview(referenceLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(commissionView)
        
        if paymentModel.transferResponseBody?.senderCardPAN != nil {
            stackView.addArrangedSubview(senderView)
        }
        if paymentModel.transferResponseBody?.receiverCardPAN != nil {
            stackView.addArrangedSubview(receiverView)
        }
        
        stackView.addArrangedSubview(sellerView)
        
        if isReccurantPaymentAvailable {
            stackView.addArrangedSubview(recurrentPaymentView)
        }
        stackView.addArrangedSubview(fillerView)

        if isReccurantPaymentAvailable {
            stackView.addArrangedSubview(subscribeButton)
        }
        
        stackView.addArrangedSubview(closeButton)
        
    }
    
    private func setupConstraints() {
        if #available(iOS 11.0, *) {
            scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, left: view.leftAnchor, bottom: view.bottomAnchor)
        } else {
            scrollView.anchor(top: view.topAnchor, right: view.rightAnchor, left: view.leftAnchor, bottom: view.bottomAnchor)
        }
        
        stackView.anchor(top: scrollView.topAnchor, right: scrollView.rightAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, width: view.frame.width)
        
        imageView.anchor(height: 48)
        logoImageView.anchor(height: 34)
        stackView.addCustomSpacing(32, after: responseLabel)
        stackView.addCustomSpacing(4, after: invoiceIdLabel)
        stackView.addCustomSpacing(5, after: commissionView)

        if paymentModel.transferResponseBody?.senderCardPAN == nil && paymentModel.transferResponseBody?.receiverCardPAN == nil {
            stackView.addCustomSpacing(32, after: sellerView)
        } else {
            stackView.addCustomSpacing(5, after: sellerView)

            if paymentModel.transferResponseBody?.receiverCardPAN == nil {
                stackView.addCustomSpacing(32, after: senderView)
            } else {
                stackView.addCustomSpacing(32, after: receiverView)
            }
        }

        let fillerViewHeightConstraint = fillerView.heightAnchor.constraint(equalToConstant: 1000)
        fillerViewHeightConstraint.priority = UILayoutPriority(500)
        fillerViewHeightConstraint.isActive = true
        
        closeButton.anchor(right: scrollView.rightAnchor, left: scrollView.leftAnchor, paddingRight: 16, paddingLeft: 16, width: view.frame.width - 32, height: 48)
        
        var closeButtonBottomConstraint: NSLayoutConstraint!
        if #available(iOS 11.0, *) {
            closeButtonBottomConstraint = closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        } else {
            closeButtonBottomConstraint = closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        }
        closeButtonBottomConstraint.priority = UILayoutPriority(800)
        closeButtonBottomConstraint.isActive = true
        
        if isReccurantPaymentAvailable {
            recurrentPaymentView.anchor(right: scrollView.rightAnchor, left: scrollView.leftAnchor, paddingRight: 16, paddingLeft: 16)
            subscribeButton.anchor(right: scrollView.rightAnchor, left: scrollView.leftAnchor, paddingRight: 16, paddingLeft: 16, width: view.frame.width - 32, height: 48)
        }

        commissionView.anchor(height: 20)
        commissionLabel.anchor(left: commissionView.leftAnchor, paddingLeft: 100, centerY: commissionView.centerYAnchor)
        commissionValueLabel.anchor(left: commissionView.centerXAnchor, paddingLeft: 20, centerY: commissionView.centerYAnchor)

        sellerView.anchor(height: 20)
        sellerLabel.anchor(left: sellerView.leftAnchor, paddingLeft: 100, centerY: sellerView.centerYAnchor)
        sellerValueLabel.anchor(left: sellerView.centerXAnchor, paddingLeft: 20, centerY: sellerView.centerYAnchor)

        senderView.anchor(height: 20)
        senderLabel.anchor(left: senderView.leftAnchor, paddingLeft: 100, centerY: senderView.centerYAnchor)
        senderCardImageView.anchor(left: senderView.centerXAnchor, paddingLeft: 20, centerY: senderView.centerYAnchor)
        senderCardLabel.anchor(left: senderCardImageView.rightAnchor, paddingLeft: 4, centerY: senderView.centerYAnchor)

        receiverView.anchor(height: 20)
        receiverLabel.anchor(left: receiverView.leftAnchor, paddingLeft: 100, centerY: receiverView.centerYAnchor)
        receiverCardImageView.anchor(left: receiverView.centerXAnchor, paddingLeft: 20, centerY: receiverView.centerYAnchor)
        receiverCardLabel.anchor(left: receiverCardImageView.rightAnchor, paddingLeft: 4, centerY: receiverView.centerYAnchor)
    }

    private func stylize() {
        commissionLabel.font = .systemFont(ofSize: 14)
        commissionLabel.text = localized(by: Constants.Localizable.commissionLabel)

        commissionValueLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        commissionValueLabel.text = "0 KZT"

        sellerLabel.font = .systemFont(ofSize: 14)
        sellerLabel.text = localized(by: Constants.Localizable.merchantLabel)

        sellerValueLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        sellerValueLabel.text = paymentModel.authConfig.merchantName

        senderLabel.font = .systemFont(ofSize: 14)
        senderLabel.text = "Отправитель:"

        if let iconName = paymentModel.transferResponseBody?.senderCardIconName {
            senderCardImageView.image = UIImage(named: iconName, in: Bundle.module, compatibleWith: nil)
        }

        senderCardLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        senderCardLabel.text = paymentModel.transferResponseBody?.senderCardMaskedNumber

        receiverLabel.font = .systemFont(ofSize: 14)
        receiverLabel.text = "Получатель:"

        if let iconName = paymentModel.transferResponseBody?.receiverCardIconName {
            receiverCardImageView.image = UIImage(named: iconName, in: Bundle.module, compatibleWith: nil)
        }

        receiverCardLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        receiverCardLabel.text = paymentModel.transferResponseBody?.receiverCardMaskedNumber
    }

    private func setTexts() {
        var invoiceText = localized(by: Constants.Localizable.invoiceId)
        var referenceText = localized(by: Constants.Localizable.reference)

        if let response = paymentModel.paymentResponseBody {
            invoiceText += response.invoiceID
            referenceText += response.reference
        } else if let response = paymentModel.transferResponseBody {
            invoiceText += response.orderID ?? ""
            referenceText += response.reference ?? ""
        } else if paymentModel.paymentType == .QR {
            invoiceText += paymentModel.invoice.id
            referenceText = ""
        }

        let paymentAccepted = paymentModel.invoice.transferType == nil || paymentModel.invoice.transferType == .AFT
        responseLabel.text = paymentAccepted ? localized(by: Constants.Localizable.paymentAccepted) : "Перевод прошел успешно"
        invoiceIdLabel.text = invoiceText
        referenceLabel.text = referenceText
    }

    private func localized(by key: String) -> String {
        return String(key).localized()
    }

    private func setCustomStyle() {
        let colorScheme = paymentModel.publicProfile?.assets?.color_scheme
        guard let params = colorScheme?.bgGradientParams, let color1 = params.color1, let color2 = params.color2 else { return }

        view.setGradientBackground(angle: params.angle, colors: color1.cgColor, color2.cgColor)
        responseLabel.textColor = colorScheme?.textColor
        invoiceIdLabel.textColor = colorScheme?.textColor
        referenceLabel.textColor = colorScheme?.textColor
        priceLabel.textColor = colorScheme?.textColor
        descriptionLabel.textColor = colorScheme?.textColor
        commissionLabel.textColor = colorScheme?.textColor
        sellerLabel.textColor = colorScheme?.textColor
        senderLabel.textColor = colorScheme?.textColor
        senderCardLabel.textColor = colorScheme?.textColor
        receiverLabel.textColor = colorScheme?.textColor
        receiverCardLabel.textColor = colorScheme?.textColor
        closeButton.layer.borderColor = colorScheme?.buttonsColor?.cgColor
        closeButton.setTitleColor(colorScheme?.buttonsColor, for: .normal)
    }
    
    @objc private func closeButtonDidPressed() {
        var dict: [String: Any] = ["isSuccessful": true]

        if let response = paymentModel.paymentResponseBody {
            if let cardId = response.cardID {
                dict["cardID"] = cardId
            }
            dict["paymentReference"] = response.reference
        } else if let response = paymentModel.transferResponseBody {
            dict["transferReference"] = response.reference
        }
        NotificationCenter.default.post(name: Notification.Name(Constants.Notification.main),  object: nil, userInfo: dict)
    }
    
    @objc private func handleToggleSwitch(sender: UISwitch) {
        if sender.isOn {
            subscribeButton.isHidden = false
            let colorScheme = paymentModel.publicProfile?.assets?.color_scheme
            subscribeButton.backgroundColor = colorScheme?.buttonsColor
        } else {
            subscribeButton.isHidden = true
        }
    }
    
    @objc private func onSubscribeButtonDidPressed() {
        let vc = LoadingViewController(paymentModel: self.paymentModel)
        self.navigationController?.pushViewController(vc, animated: true)
        vc.subscribeToAutoPayment()
    }
}
