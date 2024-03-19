//
//  InstallmentQRView.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 09.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import UIKit

class QRInfoView: UIView {
    var qrLinkInfo = QRLinkInfo() {
        didSet {
            print(self.qrLinkInfo)
            if self.qrLinkInfo.customLink == "" {
                self.qrImageView.image = self.qrLinkInfo.link.image
            } else {
                self.qrImageView.image = self.qrLinkInfo.customLink.image
            }
        }
    }
    
    var text: String = "" {
        didSet {
            descriptionLabel.text = text
        }
    }
    
    private let qrPadding: CGFloat
    
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(hexString: "#7E8194")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 12
        return stackView
    }()
    
    init(qrPadding: CGFloat) {
        self.qrPadding = qrPadding
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension QRInfoView {
    func setup() {
        addSubview(stackView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(qrImageView)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        stackView.fillSuperview()
        
        qrImageView.anchor(right: stackView.rightAnchor, left: stackView.leftAnchor, paddingRight: qrPadding, paddingLeft: qrPadding)
        qrImageView.heightAnchor.constraint(equalTo: qrImageView.widthAnchor).isActive = true
        
        descriptionLabel.anchor(
            right: stackView.rightAnchor,
            left: stackView.leftAnchor,
            paddingRight: 24,
            paddingLeft: 24
        )
    }
}

