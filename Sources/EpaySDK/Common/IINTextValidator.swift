//
//  IINTextValidator.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 15.06.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation

class IINTextValidator {

    private let pattern = "^[0-9]{12}$"

    func validateCharacters(in text: String) -> Bool {
        guard !text.isEmpty, text.count == 12, validateFormat(for: text) else { return false }

        let weight = [1, 2 ,3, 4, 5, 6, 7, 8, 9, 10, 11]
        let weightInverse = [3, 4, 5, 6, 7, 8, 9, 10, 11, 1, 2]
        var control = 0
        let numbers = text.compactMap(String.init).compactMap(Int.init)
        for i in 0..<weight.count {
            control += weight[i] * numbers[i]
        }
        control %= 11

        if control == 10 {
            control = 0

            for i in 0..<weightInverse.count {
                control += weightInverse[i] * numbers[i]
            }
            control %= 11
        }

        return control == numbers[11]
    }

    private func validateFormat(for text: String) -> Bool {
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch {
            return false
        }

        let range = NSRange(location: 0, length: text.count)
        return regex.firstMatch(in: text, range: range) != nil
    }
}
