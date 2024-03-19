//
//  SuffixTextField.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 29.06.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

class SuffixTextField: UITextField {

    private let suffixLabel = UILabel()

    private let suffixSpace: CGFloat = 4
    private var suffixLabelLeftConstraint: NSLayoutConstraint?

    var suffix: String? {
        get { suffixLabel.text }
        set {
            suffixLabel.text = newValue
            setNeedsDisplay()
        }
    }

    var suffixTextColor: UIColor {
        get { suffixLabel.textColor }
        set { suffixLabel.textColor = newValue }
    }

    var suffixFont: UIFont? {
        get { suffixLabel.font }
        set { suffixLabel.font = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(suffixLabel)
        setLayoutConstraints()
        suffixLabel.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if let textRange = allTextRange {
            setSuffix(after: firstRect(for: textRange))
        }

        return super.editingRect(forBounds: bounds)
    }

    override func draw(_ rect: CGRect) {
        if let textRange = allTextRange {
            setSuffix(after: firstRect(for: textRange))
        }

        super.draw(rect)
    }

    private func setSuffix(after textRect: CGRect) {
        let textRectX = textRect.origin.x

        if textRectX != .infinity && textRectX != -.infinity {
            suffixLabelLeftConstraint?.constant = textRect.width + textRectX + suffixSpace
        }
        suffixLabel.isHidden = text?.isEmpty != false
    }

    private func setLayoutConstraints() {
        let suffixLabelLeftConstraint = suffixLabel.leftAnchor.constraint(equalTo: leftAnchor)
        self.suffixLabelLeftConstraint = suffixLabelLeftConstraint

        suffixLabel.translatesAutoresizingMaskIntoConstraints = false
        let layoutConstraints = [
            suffixLabelLeftConstraint,
            suffixLabel.topAnchor.constraint(equalTo: topAnchor),
            suffixLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            suffixLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 24)
        ]
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
