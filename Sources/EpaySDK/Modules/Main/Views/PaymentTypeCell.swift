//
//  PaymentTypeCell.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 09.03.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

enum PaymentType {
    case creditCard, QR, halykID, applePay, installment

    var iconName: String {
        switch self {
        case .creditCard: return Constants.Images.creditCard
        case .QR: return Constants.Images.qr
        case .halykID: return Constants.Images.halykID
        case .applePay: return Constants.Images.applePayDefault
        case .installment: return Constants.Images.installment
        }
    }
}

class PaymentTypeCell: UICollectionViewCell {

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.borderWidth = 1
        layer.cornerRadius = 3

        addSubview(imageView)
        imageView.anchor(height: 25, centerX: centerXAnchor, centerY: centerYAnchor)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setImage(by name: String) {
        let image = UIImage(named: name, in: Bundle.module, compatibleWith: nil)
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
    }
    
    func setColor(scheme: PublicProfileResponseBody.Assets.ColorScheme?) {
        let color = scheme?.buttonsColor?.withAlphaComponent(isSelected ? 1 : 0.3)
        imageView.tintColor = color
        layer.borderColor = color?.cgColor
    }
}
