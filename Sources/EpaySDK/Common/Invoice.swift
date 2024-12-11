//
//  Invoice.swift
//  EpaySDK
//
//  Created by a1pamys on 2/17/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

public struct Invoice {

    enum Scope: String { case payment, transfer }

    var id: String
    var amount: Double
    var currency: String
    var accountId: String
    var description: String
    var postLink: String
    var backLink: String?
    var failurePostLink: String
    var failureBackLink: String?
    var isRecurrent: Bool
    var autoPaymentFrequency: AutoPaymentFrequency
    let transferType: TransferType?
    let homebankToken: String?
    let amountEditable: Bool
    let sender: CardInfo?
    let receiver: CardInfo?
    var masterPass: MasterPassData?
    var email: String?
    var phone: String?
    var cardSave: Bool?
    var langApp: String?
    var autoRedirect: Bool?

    public init(
        id: String,
        amount: Double,
        currency: String,
        accountId: String,
        description: String,
        postLink: String,
        backLink: String? = nil,
        failurePostLink: String,
        failureBackLink: String? = nil,
        isRecurrent: Bool,
        autoPaymentFrequency: AutoPaymentFrequency,
        transferType: TransferType? = nil,
        homebankToken: String? = nil,
        amountEditable: Bool = false,
        sender: CardInfo? = nil,
        receiver: CardInfo? = nil,
        masterPass: MasterPassData? = nil,
        email: String? = nil,
        phone: String? = nil,
        cardSave: Bool? = nil,
        langApp: String? = nil,
        autoRedirect: Bool? = nil
    ) {
        self.id = id
        self.amount = amount
        self.currency = currency
        self.accountId = accountId
        self.description = description
        self.postLink = postLink
        self.backLink = backLink
        self.failurePostLink = failurePostLink
        self.failureBackLink = failureBackLink
        self.isRecurrent = isRecurrent
        self.autoPaymentFrequency = autoPaymentFrequency
        self.transferType = transferType
        self.homebankToken = homebankToken
        self.amountEditable = amountEditable
        self.sender = sender
        self.receiver = receiver
        self.masterPass = masterPass
        self.email = email
        self.phone = phone
        self.cardSave = cardSave
        self.langApp = langApp
        self.autoRedirect = autoRedirect
    }
}

extension Invoice {

    var isTransfer: Bool { transferType != nil && transferType != .masterPass }
    
    var isMasterPass: Bool { masterPass != nil }

    var scope: String { isTransfer ? Scope.transfer.rawValue : Scope.payment.rawValue }
}
