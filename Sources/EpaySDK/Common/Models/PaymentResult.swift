//
//  PaymentResult.swift
//  EpaySDK
//
//  Created by a1pamys on 3/21/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

public struct PaymentResult {
    public var isSuccessful: Bool
    public var paymentReference: String?
    public var cardID: String?
    public var errorCode: Int?
    public var errorMessage: String?
    
    init(isSuccessful: Bool = false,
         paymentReference: String? = nil,
         cardID: String? = nil,
         errorCode: Int? = nil,
         errorMessage: String? = nil) {
        self.isSuccessful = isSuccessful
        self.paymentReference = paymentReference
        self.cardID = cardID
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }

}
