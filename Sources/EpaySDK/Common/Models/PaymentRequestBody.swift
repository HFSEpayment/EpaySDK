//
//  PaymentRequestBody.swift
//  EpaySDK
//
//  Created by a1pamys on 2/17/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

struct PaymentRequestBody {
    
    // MARK: - Public properties
    
    let amount: Double
    let currency: String
    let name: String?
    let cryptogram: String?
    let invoiceId: String
    let description: String?
    let accountId: String?
    let email: String?
    let phone: String?
    let postLink: String
    let backLink: String?
    let failurePostLink: String
    let failureBackLink: String?
    var language: String?
    let useGoBonus: Bool
    let cardSave: Bool
    let not3d: Bool?
    let paymentType: String?
    let osuvoxCardId: String?
    let terminalId: String?
    let applePayToken: [String: Any]?
    let masterpass: MasterPassData?

    // MARK: - Initializers
    
    init(amount: Double,
         currency: String,
         name: String? = nil,
         cryptogram: String? = nil,
         invoiceId: String,
         description: String? = nil,
         accountId: String? = nil,
         email: String? = nil,
         phone: String? = nil,
         postLink: String,
         backLink: String? = nil,
         failurePostLink: String,
         failureBackLink: String? = nil,
         useGoBonus: Bool,
         cardSave: Bool,
         not3d: Bool? = nil,
         paymentType: String? = nil,
         osuvoxCardId: String? = nil,
         terminalId: String? = nil,
         applePayToken: [String: Any]? = nil,
         masterpass: MasterPassData? = nil,
         language: String? = nil
    ) {
        self.amount = amount
        self.currency = currency
        self.name = name
        self.cryptogram = cryptogram
        self.invoiceId = invoiceId
        self.description = description
        self.accountId = accountId
        self.email = email
        self.phone = phone
        self.postLink = postLink
        self.backLink = backLink
        self.failurePostLink = failurePostLink
        self.failureBackLink = failureBackLink
        self.useGoBonus = useGoBonus
        self.cardSave = cardSave
        self.not3d = not3d
        self.paymentType = paymentType
        self.osuvoxCardId = osuvoxCardId
        self.terminalId = terminalId
        self.applePayToken = applePayToken
        self.masterpass = masterpass
        self.language = language
    }
}
