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
    var failurePostLink: String
    var isRecurrent: Bool
    var autoPaymentFrequency: AutoPaymentFrequency
    let transferType: TransferType?
    let homebankToken: String?
    let amountEditable: Bool
    let sender: CardInfo?
    let receiver: CardInfo?
    var masterPass: MasterPassData?

    public init(
        id: String,
        amount: Double,
        currency: String,
        accountId: String,
        description: String,
        postLink: String,
        failurePostLink: String,
        isRecurrent: Bool,
        autoPaymentFrequency: AutoPaymentFrequency,
        transferType: TransferType? = nil,
        homebankToken: String? = nil,
        amountEditable: Bool = false,
        sender: CardInfo? = nil,
        receiver: CardInfo? = nil,
        masterPass: MasterPassData? = nil
    ) {
        self.id = id
        self.amount = amount
        self.currency = currency
        self.accountId = accountId
        self.description = description
        self.postLink = postLink
        self.failurePostLink = failurePostLink
        self.isRecurrent = isRecurrent
        self.autoPaymentFrequency = autoPaymentFrequency
        self.transferType = transferType
        self.homebankToken = homebankToken
        self.amountEditable = amountEditable
        self.sender = sender
        self.receiver = receiver
        self.masterPass = masterPass
    }
}

extension Invoice {

    var isTransfer: Bool { transferType != nil && transferType != .masterPass }
    
    var isMasterPass: Bool { masterPass != nil }

    var scope: String { isTransfer ? Scope.transfer.rawValue : Scope.payment.rawValue }
}
