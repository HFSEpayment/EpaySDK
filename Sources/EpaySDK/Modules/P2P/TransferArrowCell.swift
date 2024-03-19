//
//  TransferArrowCell.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 17.05.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation
import UIKit

class TransferArrowCell: UITableViewCell {

    private let arrowImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(arrowImageView)
        setLayoutConstraints()
        arrowImageView.image = UIImage(named: Constants.Images.arrowDownSharp, in: Bundle.module, compatibleWith: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setLayoutConstraints() {
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        let layoutConstraints = [
            arrowImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            arrowImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            arrowImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
