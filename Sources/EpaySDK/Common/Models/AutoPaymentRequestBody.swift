//
//  AutoPaymentRequestBody.swift
//  EpaySDK
//
//  Created by a1pamys on 6/1/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

class AutoPaymentRequestBody {
    var transactionId: String
    var paymentFrequency: AutoPaymentFrequency
    
    init(transactionId: String,
         paymentFrequency: AutoPaymentFrequency) {
        self.transactionId = transactionId
        self.paymentFrequency = paymentFrequency
    }

}
