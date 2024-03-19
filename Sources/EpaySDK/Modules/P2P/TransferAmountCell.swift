//
//  TransferAmountCell.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 21.04.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

class TransferAmountCell: UITableViewCell {

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let amountLabel = UILabel()
    private let amountTextField = SuffixTextField()
    private let errorTextField = UILabel()

    private var textFormatter: AmountFormatter { AmountFormatter(useCommaSeparator: false, attributes: attributes) }
    private var attributes: [NSAttributedString.Key: Any] {
        return [
            .font: UIFont.systemFont(ofSize: 28, weight: .semibold),
            .foregroundColor: UIColor(hexString: "#03034B")
        ]
    }

    var amount: Double {
        get {
            let text = amountTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
            return Double(text) ?? 0
        }
        set {
            set(amount: newValue)
        }
    }

    var amountEditable: Bool {
        get { amountTextField.isEnabled }
        set { amountTextField.isEnabled = newValue }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func set(amount: Double) {
        amountTextField.attributedText = textFormatter.apply(to: amount.description)
        amountTextField.setNeedsDisplay()
    }

    func set(text: String) {
        amountTextField.attributedText = textFormatter.apply(to: text)
        amountTextField.setNeedsDisplay()
    }

    func getAmount() -> Double? {
        guard let text = amountTextField.text else { return nil }

        if text.isEmpty || amount == 0 {
            errorTextField.text = "Обязательное поле"
            return nil
        } else if amount > 1000000 {
            errorTextField.text = "Cумма перевода не должна превышать 1 000 000 ₸"
            return nil
        } else {
            errorTextField.text = nil
            return amount
        }
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        contentView.addSubview(errorTextField)

        containerView.addSubview(titleLabel)
        containerView.addSubview(amountTextField)
    }

    private func setLayoutConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 22),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -22)
        ]

        errorTextField.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            errorTextField.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 4),
            errorTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 22),
            errorTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            errorTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -22),
            errorTextField.heightAnchor.constraint(equalToConstant: 12)
        ]

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 15)
        ]

        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            amountTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            amountTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            amountTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            amountTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            amountTextField.heightAnchor.constraint(equalToConstant: 35)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func stylize() {
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.layer.cornerRadius = 4
        containerView.layer.borderColor = UIColor(hexString: "#BABAC3").cgColor
        containerView.layer.borderWidth = 1

        errorTextField.font = .systemFont(ofSize: 12)
        errorTextField.textColor = UIColor(hexString: "#F42B74")

        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = UIColor(hexString: "#9C9EAC")
        titleLabel.text = "Сумма перевода"

        amountTextField.font = .systemFont(ofSize: 28, weight: .semibold)
        amountTextField.textColor = UIColor(hexString: "#03034B")
        amountTextField.textAlignment = .center
        amountTextField.keyboardType = .decimalPad
        amountTextField.suffix = "KZT"
        amountTextField.suffixFont = .systemFont(ofSize: 28, weight: .semibold)
        amountTextField.suffixTextColor = UIColor(hexString: "#03034B")
        amountTextField.delegate = self
    }
}

extension TransferAmountCell: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let text = textField.text ?? ""
        var updatedText = (text as NSString).replacingCharacters(in: range, with: string)

        // Replacing , to .
        if string.contains(",") {
            updatedText = updatedText.replacingOccurrences(of: ",", with: ".")
        }
        if updatedText.count <= 10 {
            let caretPosition = max(textField.caretPosition + string.count - range.length, 0)
            set(text: updatedText)
            textField.caretPosition = caretPosition
        }

        return false
    }
}
