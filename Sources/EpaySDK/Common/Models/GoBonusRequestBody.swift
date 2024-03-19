//
//  GoBonusRequestBody.swift
//  EpaySDK
//
//  Created by a1pamys on 5/17/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

class GoBonusRequestBody {
    var cryptogram: String
    
    init(cryptogram: String) {
        self.cryptogram = cryptogram
    }
}
