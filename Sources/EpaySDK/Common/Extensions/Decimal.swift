//
//  Decimal.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 30.03.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation

extension Decimal {

    var displayedAmount: String? { getDisplayedAmount(minimumFractionDigits: 2) }

    private func getDisplayedAmount(minimumFractionDigits: Int) -> String? {
        let number = NSDecimalNumber(decimal: self)
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        numberFormatter.groupingSeparator = " "
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: number)
    }
}
