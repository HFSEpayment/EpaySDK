//
//  HomeBankCard.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 28.03.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation

struct HomeBankCard: Decodable {

    let aliasName: String?
    let isHidden: Bool?
    let systemAttributeId: String?
    let cardInfo: CardInfo?
    let limit: [Limit]?

    struct CardInfo: Decodable {
        let ownerId: String?
        let cardMask: String?
        let iban: String?
        let isValid: Bool?
        let currency: String?
        let currentBalance: String?
        let cardType: String?
        let isMultiCurrency: Bool?
        let isVirtual: Bool?
    }

    struct Limit: Decodable {
        let currencyLimit: String?
        let endPeriod: String?
        let limitPeriod: Int?
        let maxAmount: Double?
    }
}

extension HomeBankCard {

    var iconName: String {
        if cardInfo?.cardType?.contains("MC") == true {
            return Constants.Images.mastercard
        } else if cardInfo?.cardType?.contains("VISA") == true {
            return Constants.Images.visa
        } else if cardInfo?.cardType?.contains("WALLET") == true {
            return Constants.Images.wallet
        } else {
            return ""
        }
    }

    var cardName: String? {
        if aliasName?.isEmpty == false {
            return aliasName
        } else if cardInfo?.isVirtual == true {
            return "Virtual"
        } else if cardInfo?.cardType?.contains("WALLET") == true {
            return "Homebank Wallet"
        } else {
            return "Card"
        }
    }

    var maskedCardNumber: String? {
        guard let cardNumber = cardInfo?.cardMask else { return nil }
        return "•" + cardNumber.prefix(4)
    }

    var amount: Decimal? {
        guard let string = cardInfo?.currentBalance?.components(separatedBy: " ").first, Double(string) != nil else { return nil }
        return Decimal(string: string)
    }

    var displayedAmount: String? {
        guard let amount = amount?.displayedAmount else { return nil }
        return amount + " ₸"
    }
}
