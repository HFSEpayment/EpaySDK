//
//  AmountFormatter.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 29.06.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

class AmountFormatter {

    private let minKernAttributes: [NSAttributedString.Key: Any]
    private let maxKernAttributes: [NSAttributedString.Key: Any]
    private let separator: Character

    init(
        useCommaSeparator: Bool = false,
        attributes: [NSAttributedString.Key: Any] = [:]
    ) {
        var minKernAttributes = attributes
        minKernAttributes[.kern] = 0
        self.minKernAttributes = minKernAttributes

        var maxKernAttributes = attributes
        maxKernAttributes[.kern] = (" " as NSString).size(withAttributes: attributes).width
        self.maxKernAttributes = maxKernAttributes

        separator = useCommaSeparator ? "," : "."
    }

    func apply(to text: String) -> NSMutableAttributedString {
        if text.isEmpty { return .init(string: "", attributes: maxKernAttributes) }
        let resultAttributedString = NSMutableAttributedString()
        let splittedText = text.split(separator: separator)
        let textWithoutDot = String(splittedText[0])

        for index in stride(from: textWithoutDot.count, to: 0, by: -3) {
            let startRange = max(0, index - 3)
            let endRange = index
            let threeChars = String(textWithoutDot[startRange..<endRange])

            let rangeAttributedString = NSMutableAttributedString()

            let lastChar = String(threeChars[threeChars.count - 1..<threeChars.count])
            let lastCharAttributedString = NSMutableAttributedString(
                string: lastChar,
                attributes: endRange == textWithoutDot.count ? minKernAttributes : maxKernAttributes
            )
            rangeAttributedString.insert(lastCharAttributedString, at: 0)

            let firstChars = String(threeChars[0..<threeChars.count - 1])
            let firstCharAttributedString = NSMutableAttributedString(string: firstChars, attributes: minKernAttributes)
            rangeAttributedString.insert(firstCharAttributedString, at: 0)
            resultAttributedString.insert(rangeAttributedString, at: 0)
        }
        if text.contains(separator) {
            let string = String(separator) + (splittedText.count == 2 ? String(splittedText[1]) : "")
            let dotAttributedString = NSMutableAttributedString(string: string, attributes: minKernAttributes)
            resultAttributedString.append(dotAttributedString)
        }
        return resultAttributedString
    }
}
