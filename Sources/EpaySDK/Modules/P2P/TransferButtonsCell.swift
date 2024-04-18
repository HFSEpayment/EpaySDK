//
//  TransferButtonsCell.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 24.04.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

protocol TransferButtonsCellDelegate: AnyObject {
    func didPressTransferButton()
    func didPressCancelButton()
}

class TransferButtonsCell: UITableViewCell {

    private let transferButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    weak var delegate: TransferButtonsCellDelegate?

    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet {
            transferButton.backgroundColor = colorScheme?.buttonsColor
            transferButton.setTitleColor(colorScheme?.bgSecondColor, for: .normal)
            cancelButton.layer.borderColor = colorScheme?.buttonsColor?.cgColor
            cancelButton.setTitleColor(colorScheme?.buttonsColor, for: .normal)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setLayoutConstraints()
        stylize()
        setActions()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func addSubviews() {
        contentView.addSubview(transferButton)
        contentView.addSubview(cancelButton)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        transferButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            transferButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            transferButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 22),
            transferButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -22),
            transferButton.heightAnchor.constraint(equalToConstant: 48)
        ]

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            cancelButton.topAnchor.constraint(equalTo: transferButton.bottomAnchor, constant: 12),
            cancelButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 22),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cancelButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -22),
            cancelButton.heightAnchor.constraint(equalToConstant: 48)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        selectionStyle = .none
        backgroundColor = .clear

        transferButton.backgroundColor = UIColor(hexString: "#E0E0E0")
        transferButton.layer.cornerRadius = 3
        transferButton.setTitle("Перевести", for: .normal)
        transferButton.setTitleColor(.white, for: .normal)
        transferButton.titleLabel?.font = .boldSystemFont(ofSize: 16)

        let cancelTitle = String(
            Constants.Localizable.cancel
        ).localized()
        
        cancelButton.layer.cornerRadius = 3
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitle(cancelTitle, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16)
    }

    private func setActions() {
        transferButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }

    @objc private func payButtonTapped() {
        delegate?.didPressTransferButton()
    }

    @objc private func cancelButtonTapped() {
        delegate?.didPressCancelButton()
    }
}
