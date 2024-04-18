//
//  AutoPaymentViewController.swift
//  EpaySDK
//
//  Created by a1pamys on 2/12/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

class AutoPaymentViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var paymentModel: PaymentModel!
    
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
        l.textColor = .black
        l.text = String(
            Constants.Localizable.autoPaymentSuccess
        ).localized()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 22)
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var invoiceIdLabel: UILabel = {
        let l = UILabel()
        l.text = String(
            Constants.Localizable.invoiceId
        ).localized() + paymentModel.paymentResponseBody.invoiceID
        l.textAlignment = .center
        l.textColor = UIColor(hexString: "#7E8194")
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    private lazy var referenceLabel: UILabel = {
        let l = UILabel()
        l.text = String(
            Constants.Localizable.reference
        ).localized() + paymentModel.paymentResponseBody.reference
        l.textAlignment = .center
        l.textColor = UIColor(hexString: "#7E8194")
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
        l.textColor = UIColor(hexString: "#03034B")
        l.attributedText = attributedString
        return l
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.text = String(
            Constants.Localizable.autoPaymentAmount
        ).localized()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var onlineShopPaymentLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.text = String(
            Constants.Localizable.onlineShopPayment
        ).localized()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        l.numberOfLines = 0
        return l
    }()
    
    public lazy var sellerLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        let firstText = NSAttributedString(string: String(Constants.Localizable.merchantLabel).localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#566681"),
                                                                                                                                                                                                                                  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let secondText = NSAttributedString(string: " \(paymentModel.authConfig.merchantName)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#071222"),
                                                                                                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let newString = NSMutableAttributedString()
        newString.append(firstText)
        newString.append(secondText)
        l.attributedText = newString
        return l
    }()
    
    private lazy var periodDateLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        let firstText = NSAttributedString(string: String(Constants.Localizable.periodLabel).localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#566681"),
                                                                                                                                                                                                                                  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let secondText = NSAttributedString(string: " " + String(self.paymentModel.autoPaymentResponseBody.paymentFrequency).localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#071222"),
                                                                                                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let newString = NSMutableAttributedString()
        newString.append(firstText)
        newString.append(secondText)
        l.attributedText = newString
        return l
    }()
    
    private lazy var subscriptionStartDateLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        let firstText = NSAttributedString(string: String(Constants.Localizable.subscriptionDateLabel).localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#566681"),
                                                                                                                                                                                                                                  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let secondText = NSAttributedString(string: " " + String(self.paymentModel.autoPaymentResponseBody.createdDateString).localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#071222"),
                                                                                                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let newString = NSMutableAttributedString()
        newString.append(firstText)
        newString.append(secondText)
        l.attributedText = newString
        return l
    }()
    
    private lazy var subscriptionEndDateLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        let firstText = NSAttributedString(string: String(Constants.Localizable.subscriptionEndDateLabel).localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#566681"),
                                                                                                                                                                                                                                  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let secondText = NSAttributedString(string: " " + String(self.paymentModel.autoPaymentResponseBody.lastPaymentDateString).localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#071222"),
                                                                                                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let newString = NSMutableAttributedString()
        newString.append(firstText)
        newString.append(secondText)
        l.attributedText = newString
        return l
    }()
    
    private lazy var fillerView = UIView()
    
    private lazy var closeButton: UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 3
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.mainColor.cgColor
        b.setAttributedTitle(NSAttributedString(string: String(Constants.Localizable.close).localized(),
                                                attributes: [NSAttributedString.Key.foregroundColor : UIColor.mainColor,
                                                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]),
                             for: .normal)
        b.addTarget(self, action: #selector(closeButtonDidPressed), for: .touchUpInside)
        return b
    }()
    
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
        
        view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setupViews()
        setupConstraints()
        
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(responseLabel)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(invoiceIdLabel)
        stackView.addArrangedSubview(referenceLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(onlineShopPaymentLabel)
        stackView.addArrangedSubview(sellerLabel)
        stackView.addArrangedSubview(periodDateLabel)
        stackView.addArrangedSubview(subscriptionStartDateLabel)
        stackView.addArrangedSubview(subscriptionEndDateLabel)
        stackView.addArrangedSubview(fillerView)
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
        stackView.addCustomSpacing(40, after: responseLabel)
        stackView.addCustomSpacing(4, after: invoiceIdLabel)
        stackView.addCustomSpacing(4, after: priceLabel)
        stackView.addCustomSpacing(5, after: onlineShopPaymentLabel)
        stackView.addCustomSpacing(5, after: sellerLabel)
        stackView.addCustomSpacing(5, after: periodDateLabel)
        stackView.addCustomSpacing(5, after: subscriptionStartDateLabel)
        
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
        
    }
    
    @objc private func closeButtonDidPressed() {
        let dict = [
            "isSuccessful": true,
            "cardID": paymentModel.paymentResponseBody.cardID ?? "",
            "paymentReference": paymentModel.paymentResponseBody.reference
            ] as [String : Any]
        
        NotificationCenter.default.post(name: Notification.Name(Constants.Notification.main),  object: nil, userInfo: dict)
    }
}
