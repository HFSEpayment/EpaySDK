//
//  TokenRequestBody.swift
//  EpaySDK
//
//  Created by a1pamys on 2/17/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

struct TokenRequestBody {
    
    // MARK: - Public properties
    
    var grantType: String
    var scope: String
    var clientId: String
    var clientSecret: String
    var invoiceId: String
    var amount: Double
    var currency: String
    var terminal: String
    
    // MARK: - Initializers
    
    init(grantType: String,
         scope: String,
         clientId: String,
         clientSecret: String,
         invoiceId: String,
         amount: Double,
         currency: String,
         terminal: String) {
        self.grantType = grantType
        self.scope = scope
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.invoiceId = invoiceId
        self.amount = amount
        self.currency = currency
        self.terminal = terminal
    }
}
