//
//  QRModalViewController.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 15.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import Foundation
import UIKit

class QRPopupViewController: UIViewController {
    private lazy var qrView: QRInfoView = {
        let view = QRInfoView(qrPadding: 64)
        view.qrLinkInfo.customLink = "https://epay.homebank.kz/myLoanApplications"
        view.text = String(
            Constants.Localizable.myApplicationsQRDescription
        ).localized()
        return view
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
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    @objc func closeButtonTouched() {
        dismiss(animated: true)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension QRPopupViewController {
    func setup() {
        stackView.addArrangedSubview(qrView)
        stackView.addArrangedSubview(closeButton)
        containerView.addSubview(stackView)
        
        view.addSubview(containerView)
        view.backgroundColor = UIColor(hexString: "#0C121D").withAlphaComponent(0.7)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        stackView.anchor(
            top: containerView.topAnchor,
            right: containerView.rightAnchor,
            left: containerView.leftAnchor,
            bottom: containerView.bottomAnchor,
            paddingRight: 16,
            paddingLeft: 16,
            paddingBottom: 16
        )
        
        containerView.anchor(
            right: view.rightAnchor,
            left: view.leftAnchor,
            paddingRight: 16,
            paddingLeft: 16,
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor
        )
        
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        closeButton.anchor(height: 48)
        
        qrView.anchor(right: containerView.rightAnchor, left: containerView.leftAnchor, paddingRight: 33, paddingLeft: 33)
        
    }
}
