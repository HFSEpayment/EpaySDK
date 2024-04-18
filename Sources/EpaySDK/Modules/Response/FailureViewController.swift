//
//  FailureViewController.swift
//  EpaySDK
//
//  Created by a1pamys on 2/12/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

class FailureViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var paymentModel: PaymentModel!
    private var failType: FailType!
    
    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = .white
        if #available(iOS 11.0, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
        return v
    }()
    
    private lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 16
        v.distribution = .fill
        v.alignment = .fill
        return v
    }()
    
    private lazy var failureImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: Constants.Images.fail, in: Bundle.module, compatibleWith: nil)
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 22)
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var invoiceIdLabel: UILabel = {
        let l = UILabel()
        l.text = String(Constants.Localizable.invoiceId).localized() + paymentModel.invoice.id
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    private lazy var closeButton: UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 3
        b.layer.borderWidth = 1
        b.setAttributedTitle(NSAttributedString(string: String(Constants.Localizable.close).localized(),
                                                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]),
                             for: .normal)
        b.addTarget(self, action: #selector(closeButtonDidPressed), for: .touchUpInside)
        return b
    }()
    
    private lazy var backToPaymentAndTryAgainButton: UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 3
        b.layer.borderWidth = 1
        let title =  self.failType == .token ? Constants.Localizable.tryAgain : Constants.Localizable.backToEpayForm
        b.setAttributedTitle(NSAttributedString(string: String(title).localized(),
                                                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]),
                             for: .normal)
        b.addTarget(self, action: #selector(backToPaymentAndTryAgainButtonDidPressed), for: .touchUpInside)
        return b
    }()
    
    // MARK: - Initializers
    
    public init(paymentModel: PaymentModel, failType: FailType) {
        super.init(nibName: nil, bundle: nil)
        self.paymentModel = paymentModel
        self.failType = failType
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

        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        view.backgroundColor = .white

        setupViews()
        setupConstraints()
        setTexts()
        setCustomStyle()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(failureImageView)
        stackView.addArrangedSubview(titleLabel)
        if failType == .payment || failType == .transfer {
            stackView.addArrangedSubview(invoiceIdLabel)            
        }
        stackView.addArrangedSubview(descriptionLabel)
        if failType != .autoPayment {
            view.addSubview(backToPaymentAndTryAgainButton)
        }
        view.addSubview(closeButton)
    }
    
    private func setupConstraints() {
        stackView.anchor(right: view.rightAnchor, left: view.leftAnchor, paddingRight: 16, paddingLeft: 16, centerY: view.centerYAnchor)
        failureImageView.anchor(height: 48)
        stackView.addCustomSpacing(16, after: titleLabel)
        if #available(iOS 11.0, *) {
            closeButton.anchor(right: view.rightAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingRight: 16, paddingLeft: 16, paddingBottom: 16, height: 48)
        } else {
            closeButton.anchor(right: view.rightAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, paddingRight: 16, paddingLeft: 16, paddingBottom: 16, height: 48)
        }
        if failType != .autoPayment {
            backToPaymentAndTryAgainButton.anchor(right: view.rightAnchor, left: view.leftAnchor, bottom: closeButton.topAnchor, paddingRight: 16, paddingLeft: 16, paddingBottom: 16, height: 48)
        }
    }

    private func setTexts() {
        switch failType {
        case .token: titleLabel.text = localized(by: Constants.Localizable.errorTitleToken)
        case .payment: titleLabel.text = localized(by: Constants.Localizable.paymentDeclined)
        case .autoPayment: titleLabel.text = localized(by: Constants.Localizable.autoPaymentDeclined)
        case .transfer: titleLabel.text = localized(by: Constants.Localizable.transferDeclined)
        default: break
        }

        if failType == .token {
            descriptionLabel.text = localized(by: Constants.Localizable.errorDescriptionToken)
        } else {
            if let response = paymentModel.errorResponseBody {
                let errorPaymentKey = "error_payment_" + response.code.description
                if localized(by: errorPaymentKey) != errorPaymentKey {
                    descriptionLabel.text = localized(by: errorPaymentKey)
                } else if !response.message.isEmpty {
                    descriptionLabel.text = response.message
                } else {
                    descriptionLabel.text = localized(by: Constants.Localizable.errorPaymentDefault)
                }
            } else {
                descriptionLabel.text = localized(by: Constants.Localizable.errorPaymentDefault)
            }
        }
    }

    private func localized(by key: String) -> String {
        return String(key).localized()
    }

    private func setCustomStyle() {
        let colorScheme = paymentModel.publicProfile?.assets?.color_scheme
        guard let params = colorScheme?.bgGradientParams, let color1 = params.color1, let color2 = params.color2 else { return }

        view.setGradientBackground(angle: params.angle, colors: color1.cgColor, color2.cgColor)
        titleLabel.textColor = colorScheme?.textColor
        invoiceIdLabel.textColor = colorScheme?.textColor
        descriptionLabel.textColor = colorScheme?.textColor
        backToPaymentAndTryAgainButton.setTitleColor(colorScheme?.buttonsColor, for: .normal)
        backToPaymentAndTryAgainButton.layer.borderColor = colorScheme?.buttonsColor?.cgColor
        closeButton.setTitleColor(colorScheme?.buttonsColor, for: .normal)
        closeButton.layer.borderColor = colorScheme?.buttonsColor?.cgColor
    }
    
    @objc private func backToPaymentAndTryAgainButtonDidPressed() {
        if failType == .token {
            for vc in navigationController!.viewControllers {
                if let launchScreenVC = vc as? LaunchScreenViewController {
                    navigationController?.popToViewController(launchScreenVC, animated: false)
                }
            }
        } else {
            for vc in navigationController!.viewControllers {
                if let mainVC = vc as? MainViewController {
                    navigationController?.popToViewController(mainVC, animated: true)
                } else if let transferVC = vc as? TransferViewController {
                    navigationController?.popToViewController(transferVC, animated: true)
                }
            }
        }
    }
    
    @objc private func closeButtonDidPressed() {
        var dict: [String: Any] = ["isSuccessful": false]

        if let response = paymentModel.errorResponseBody {
            dict["errorCode"] = response.code
            dict["errorMessage"] = response.message
        }

        NotificationCenter.default.post(name: Notification.Name(Constants.Notification.main),  object: nil, userInfo: dict)
    }
    
    enum FailType {
        case token
        case payment
        case autoPayment
        case transfer
    }
}
