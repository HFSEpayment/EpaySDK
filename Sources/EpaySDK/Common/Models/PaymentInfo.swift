//
//  PaymentInfo.swift
//  EpaySDK
//
//  Created by a1pamys on 2/17/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

struct PaymentInfo {
    
    // MARK: - Public properties
    
    var hpan: String
    var expDate: String
    var cvc: String
    var email: String
    var name: String
    var useGoBonus: Bool
    
    // MARK: - Initializers
    
    init(hpan: String,
         expDate: String,
         cvc: String,
         email: String,
         name: String,
         useGoBonus: Bool = false) {
        self.hpan = hpan
        self.expDate = expDate
        self.cvc = cvc
        self.email = email
        self.name = name
        self.useGoBonus = useGoBonus
    }
}
