//
//  CardInfo.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 06.06.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation

public struct CardInfo {
    let cardCred: String
    let cardNumber: String
    let payerName: String

    public init(cardCred: String, cardNumber: String, payerName: String) {
        self.cardCred = cardCred
        self.cardNumber = cardNumber
        self.payerName = payerName
    }
}

public extension CardInfo {

    var maskedCardNumber: String {
        let firstSixDigit = cardNumber.prefix(6).description
        let lastFourDigit = cardNumber.suffix(4).description
        return firstSixDigit + "******" + lastFourDigit
    }
}
