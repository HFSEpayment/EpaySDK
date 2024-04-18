//
//  TransferEmailCell.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 21.04.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

class TransferEmailCell: UITableViewCell {

    private let emailTextField = SkyFloatingLabelTextField()

    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet { setCustomStyle() }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(emailTextField)
        setLayoutConstraints()
        stylize()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func getEmail() -> String? {
        guard let email = emailTextField.text, !email.isEmpty, isValidEmail(email) else {
            emailTextField.lineColor = .red
            return nil
        }
        emailTextField.lineColor = colorScheme?.textColor ?? UIColor(hexString: "#DFE3E6")
        return emailTextField.text
    }

    private func setLayoutConstraints() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        let layoutConstraints = [
            emailTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            emailTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 22),
            emailTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            emailTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -22),
            emailTextField.heightAnchor.constraint(equalToConstant: 42)
        ]
        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let placeholder = String(
            Constants.Localizable.emailRequiredHint
        ).localized()
        let title = String(
            Constants.Localizable.emailRequiredHint
        ).localized()
        emailTextField.font = .systemFont(ofSize: 14)
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        emailTextField.placeholder = placeholder
        emailTextField.title = title
    }

    private func setCustomStyle() {
        guard let textColor = colorScheme?.textColor else { return }
        emailTextField.textColor = textColor
        emailTextField.placeholderColor = textColor
        emailTextField.lineColor = textColor
        emailTextField.selectedLineColor = textColor
        emailTextField.titleColor = textColor
        emailTextField.selectedTitleColor = textColor
        emailTextField.titleFormatter = { (text: String) -> String in return text }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
