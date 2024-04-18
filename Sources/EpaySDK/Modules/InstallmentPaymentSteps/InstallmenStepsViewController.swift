//
//  InstallmenStepsViewController.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 09.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class InstallmenStepsViewController: UIViewController {
    var orderStatus: OrderStatus = .scan {
        didSet {
            installmentStepsView.orderStatus = orderStatus
            if orderStatus == .inProgress {
                myRequestsButton.isHidden = false
                closeButton.isHidden = true
            } else {
                myRequestsButton.isHidden = true
                closeButton.isHidden = false
            }
        }
    }
    
    private let paymentModel: PaymentModel
    
    private lazy var installmentStepsView: InstallmentStepsView = {
        let view = InstallmentStepsView(orderStatus: orderStatus)
        view.installmentInfoAmount = paymentModel.invoice.amount
        view.installmentInfoOrderId = paymentModel.invoice.id
        view.installmentInfoSeller = paymentModel.terminalsResponseBody.shop.name
        view.installmentPaymentDescription = paymentModel.invoice.description
        view.installmentInfoCommission = 0
        return view
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainColor.cgColor
        button.setAttributedTitle(
            NSAttributedString(
                string: String(
                    Constants.Localizable.close
                ).localized(),
                attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.mainColor,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
                ]
            ),
            for: .normal
        )
        button.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var myRequestsButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainColor.cgColor
        button.setAttributedTitle(
            NSAttributedString(
                string: String(
                    "Мои заявки"
                ).localized(),
                attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.mainColor,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
                ]
            ),
            for: .normal
        )
        button.addTarget(self, action: #selector(myRequestsButtonTouched), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        paymentModel.getOrderStatus(every: 5) { [weak self] status, timer in // todo: time from paymentmodel
            if let prevStatus = self?.orderStatus, prevStatus != status {
                DispatchQueue.main.async {
                    self?.orderStatus = status
                }
            }
            if status == .accept || status == .reject {
                timer.invalidate()
            }
        }
    }
    
    init(paymentModel: PaymentModel) {
        self.paymentModel = paymentModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeButtonTouched() {
        let dict = [
            "isSuccessful": orderStatus == .accept,
            ] as [String : Any]
        
        NotificationCenter.default.post(name: Notification.Name(Constants.Notification.main),  object: nil, userInfo: dict)
    }
    
    @objc func myRequestsButtonTouched() {
        let vc = QRPopupViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
}

private extension InstallmenStepsViewController {
    func setup() {
        view.backgroundColor = .white
        view.addSubview(installmentStepsView)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(closeButton)
        buttonsStackView.addArrangedSubview(myRequestsButton)
        
        navigationController?.isNavigationBarHidden = true
        makeConstraints()
    }
    
    func makeConstraints() {
        installmentStepsView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            right: view.rightAnchor,
            left: view.leftAnchor,
            paddingTop: 24,
            paddingRight: 24,
            paddingLeft: 24
        )
        
        buttonsStackView.anchor(
            right: view.rightAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            paddingRight: 24,
            paddingLeft: 24,
            paddingBottom: 24
        )
        
        myRequestsButton.anchor(height: 48)
        closeButton.anchor(height: 48)
    }
}
