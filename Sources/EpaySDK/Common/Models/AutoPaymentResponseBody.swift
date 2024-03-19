//
//  AutoPaymentResponseBody.swift
//  EpaySDK
//
//  Created by a1pamys on 6/1/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

class AutoPaymentResponseBody: Decodable {
    var createdDate: Date
    var paymentFrequency: String
    var lastPaymentDate: Date
    var clientId: String
    var invoiceId: String
    var amount: Double
    var currency: String
    var reference: String
    
    var createdDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: createdDate)
    }
    
    var lastPaymentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: lastPaymentDate)
    }
}
