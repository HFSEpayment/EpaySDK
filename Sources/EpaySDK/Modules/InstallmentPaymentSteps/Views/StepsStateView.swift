//
//  StepsStateView.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 09.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import UIKit

class StepsStateView: UIView {
    var orderStatus: OrderStatus {
        didSet {
            update(status: orderStatus)
        }
    }
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.color = UIColor(hexString: "#2AA65C")
        return indicatorView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(hexString: "#141414")
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    private lazy var stateDescription: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = UIColor(hexString: "#7E8194")
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    init(orderStatus: OrderStatus) {
        self.orderStatus = orderStatus
        super.init(frame: .zero)
        setup()
        update(status: orderStatus)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(status: OrderStatus) {
        switch status {
        case .scan:
            indicatorView.isHidden = false
            iconImageView.isHidden = true
            stateLabel.text = String(
                Constants.Localizable.pleaseWait
            ).localized()
            stateDescription.text = String(
                Constants.Localizable.doNotUpdatePage
            ).localized()
        case .inProgress:
            indicatorView.isHidden = true
            iconImageView.isHidden = false
            iconImageView.image = UIImage(named: Constants.Images.wait, in: Bundle.module, compatibleWith: nil)
            stateLabel.text = String(
                Constants.Localizable.decisionInProgress
            ).localized()
            stateDescription.text = String(
                Constants.Localizable.checkingData
            ).localized()
        case .reject:
            indicatorView.isHidden = true
            iconImageView.image = UIImage(named: Constants.Images.fail, in: Bundle.module, compatibleWith: nil)
            stateLabel.text = String(
                Constants.Localizable.applicationIsRejected
            ).localized()
            stateDescription.text = String(
                Constants.Localizable.tryToChangeWatOfPayment
            ).localized()
        case .accept:
            indicatorView.isHidden = true
            iconImageView.image = UIImage(named: Constants.Images.success, in: Bundle.module, compatibleWith: nil)
            stateLabel.text = String(
                Constants.Localizable.installmentIsAccepted
            ).localized()
            stateDescription.text = String(
                Constants.Localizable.installmentRegistrationIsEnded
            ).localized()
        default:
            break
        }
    }
}

private extension StepsStateView {
    func setup() {
        addSubview(stackView)
        indicatorView.startAnimating()
        
        stackView.addArrangedSubview(indicatorView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(stateLabel)
        stackView.addArrangedSubview(stateDescription)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        stackView.fillSuperview()
        
        stateDescription.anchor(
            right: stackView.rightAnchor,
            left: stackView.leftAnchor,
            paddingRight: 34,
            paddingLeft: 34
        )
        
        iconImageView.anchor(top: stackView.topAnchor, paddingTop: 20, height: 35)
        
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        
        indicatorView.anchor(top: stackView.topAnchor, paddingTop: 28)
    }
}
