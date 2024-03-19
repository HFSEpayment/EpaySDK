//
//  InstallmentStepsView.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 09.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import UIKit

class InstallmentStepsView: UIView {
    var orderStatus: OrderStatus {
        didSet {
            processStepsView.orderStatus = orderStatus
            stepsStateView.orderStatus = orderStatus
        }
    }
    
    var installmentInfoAmount: Double = 0 {
        didSet {
            installmentInfoView.amount = installmentInfoAmount
        }
    }
    
    var installmentInfoCommission: Double = 0 {
        didSet {
            installmentInfoView.commission = installmentInfoCommission
        }
    }
    
    var installmentInfoSeller: String = "" {
        didSet {
            installmentInfoView.seller = installmentInfoSeller
        }
    }
    
    var installmentInfoOrderId: String = "" {
        didSet {
            installmentInfoView.orderNumber = installmentInfoOrderId
        }
    }
    
    var installmentPaymentDescription: String = "" {
        didSet {
            installmentInfoView.paymentDescription = installmentPaymentDescription
        }
    }
    
    private let processStepsView: ProcessStepsView
    
    private let stepsStateView: StepsStateView
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#DFE3E6")
        return view
    }()
    
    private let installmentInfoView = InstallmentInfoView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    init(orderStatus: OrderStatus) {
        self.orderStatus = orderStatus
        self.stepsStateView = StepsStateView(orderStatus: orderStatus)
        self.processStepsView = ProcessStepsView(orderStatus: orderStatus)
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension InstallmentStepsView {
    func setup() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(processStepsView)
        stackView.addArrangedSubview(stepsStateView)
        stackView.addArrangedSubview(lineView)
        stackView.addArrangedSubview(installmentInfoView)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        stackView.fillSuperview()
        
        stackView.addCustomSpacing(16, after: processStepsView)
        stackView.addCustomSpacing(24, after: stepsStateView)
        stackView.addCustomSpacing(24, after: lineView)
        
        lineView.anchor(
            right: rightAnchor,
            left: leftAnchor,
            paddingTop: 24,
            height: 1
        )
    }
}
