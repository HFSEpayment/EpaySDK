//
//  PaymenResponseBody.swift
//  EpaySDK
//
//  Created by a1pamys on 2/17/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

public struct PaymentResponseBody: Decodable {
    
    // MARK: - Public properties
    
    var id: String
    var amount: Double
    var currency: String
    var invoiceID: String
    var accountId: String?
    var phone: String? 
    var email: String
    var description: String?
    var reference: String
    var language: String?
    var secure3D: Details3D?
    var cardID: String?
    var intReference: String?
}

