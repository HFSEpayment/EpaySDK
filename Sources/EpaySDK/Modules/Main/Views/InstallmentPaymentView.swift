//
//  CreditMonthsView.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 06.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import Foundation
import UIKit

class InstallmentPaymentView: UIView {
    weak var delegate: PaymentViewDelegate?
    
    var selectedSegmentIndex: Int = 0 {
        didSet {
            segmentedControl.selectedIndex = selectedSegmentIndex
        }
    }
    
    var months: [Int] = [] {
        didSet {
            segmentedControl.itemTitles =  months.map { "\($0)" }
        }
    }
    
    var amount: Double = 0 {
        didSet {
            let s = "\(Int(amount.rounded())) KZT"
            let attributedString = NSMutableAttributedString(string: s)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: NSRange(location: s.count - 3, length: 3))
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: NSRange(location: 0, length: s.count - 3))
            amountLabel.attributedText = attributedString
        }
    }
    
    var overpayment: Double = 0
    
    var showQR: Bool = true {
        didSet {
            if showQR {
                qrView.isHidden = false
                installmentButton.isHidden = true
            } else {
                qrView.isHidden = true
                installmentButton.isHidden = false
            }
        }
    }
    
    var qrLinkInfo = QRLinkInfo() {
        didSet {
            qrView.qrLinkInfo = qrLinkInfo
        }
    }
    
    var monthLabelText: String {
        let localiztion = overpayment > 0 ? Constants.Localizable.creditForMonths : Constants.Localizable.installmentForMonths
        return NSLocalizedString(
            localiztion,
            tableName: Constants.Localizable.tableName,
            bundle: Bundle.module,
            comment: ""
        )
    }
    
    var installmentButtonAttributedTitle: NSAttributedString {
        let localization = overpayment > 0 ? Constants.Localizable.payCredit : Constants.Localizable.payInstallment
        return NSAttributedString(
            string: NSLocalizedString(
                localization,
                tableName: Constants.Localizable.tableName,
                bundle: Bundle.module,
                comment: ""
            ),
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
            ]
        )
    }
    // MARK: Views
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = monthLabelText
        label.textColor = UIColor(hexString: "#7E8194")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var segmentedControl: CustomSegmentedControl = {
        let segmentedControl = CustomSegmentedControl(delegate: delegate)
        return segmentedControl
    }()
    
    private let amountHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            Constants.Localizable.monthlyPayment,
            tableName: Constants.Localizable.tableName,
            bundle: Bundle.module,
            comment: ""
        )
        label.textColor = UIColor(hexString: "#7E8194")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor(hexString: "#03034B")
        return label
    }()
    
    private lazy var installmentButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.layer.cornerRadius = 12
        button.layer.cornerRadius = 12
        button.setAttributedTitle(
            installmentButtonAttributedTitle,
            for: .normal
        )
        
        button.backgroundColor = UIColor(hexString: "#2AA65C")
        
        let colorOne = UIColor(hexString: "#2AA65C").cgColor
        let colorTwo = UIColor(hexString: "#00805F").cgColor
        button.setGradientBackground(colors: colorOne, colorTwo)
        
        button.addTarget(self, action: #selector(didTapMakeInstallmentButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var qrView: QRInfoView = {
        let view = QRInfoView(qrPadding: 96)
        view.text =  NSLocalizedString(
            Constants.Localizable.scanViaQr,
            tableName: Constants.Localizable.tableName,
            bundle: Bundle.module,
            comment: ""
        )
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    init(delegate: PaymentViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension InstallmentPaymentView {
    func setup() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(monthLabel)
        
        stackView.addArrangedSubview(segmentedControl)
        
        stackView.addArrangedSubview(amountHeaderLabel)
        stackView.addArrangedSubview(amountLabel)
        stackView.addArrangedSubview(qrView)
        stackView.addArrangedSubview(installmentButton)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        stackView.anchor(top: topAnchor, right: rightAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 8, paddingRight: 16, paddingLeft: 16, paddingBottom: 24)
        stackView.addCustomSpacing(8, after: monthLabel)
        
        stackView.addCustomSpacing(24, after: segmentedControl)
        segmentedControl.anchor(height: 35)
        
        stackView.addCustomSpacing(16, after: amountLabel)
        
        installmentButton.anchor(height: 48)
    }
    
    @objc private func didTapMakeInstallmentButton() {
        delegate?.makeInstallment()
    }
}
