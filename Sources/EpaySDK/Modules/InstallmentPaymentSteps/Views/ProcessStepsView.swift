//
//  ProcessStepsView.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 09.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import UIKit

class ProcessStepsView: UIView {
    var orderStatus: OrderStatus {
        didSet {
            switch orderStatus {
            case .scan:
                isHidden = false
                stepsLabel.text = String(
                    Constants.Localizable.step1Of3
                ).localized()
                stepDescriptionLabel.text = String(
                    Constants.Localizable.step1Description
                ).localized()
            case .inProgress:
                isHidden = false
                stepsLabel.text = String(
                    Constants.Localizable.step2Of3
                ).localized()
                stepDescriptionLabel.text = String(
                    Constants.Localizable.step2Description
                ).localized()
            default:
                self.isHidden = true
            }
        }
    }
    
    private lazy var stepsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#4F4F4F")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var stepDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(hexString: "#7E8194")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "time_icon", in: Bundle.module, compatibleWith: nil)
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexString: "#F1F2F6").cgColor
        return view
    }()
    
    
    init(orderStatus: OrderStatus) {
        self.orderStatus = orderStatus
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProcessStepsView {
    func setup() {
        addSubview(containerView)
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(stepsLabel)
        stackView.addArrangedSubview(stepDescriptionLabel)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        containerView.fillSuperview()
        
        iconImageView.anchor(
            top: containerView.topAnchor,
            left: containerView.leftAnchor,
            paddingTop: 19,
            paddingLeft: 16
        )
        
        stackView.anchor(
            top: containerView.topAnchor,
            right: containerView.rightAnchor,
            left: iconImageView.rightAnchor,
            bottom: containerView.bottomAnchor,
            paddingTop: 12,
            paddingRight: 12,
            paddingLeft: 16,
            paddingBottom: 12
        )
    }
}
