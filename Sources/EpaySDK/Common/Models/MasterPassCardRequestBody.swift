//
//  MasterPassCardRequestBody.swift
//  EpaySDK
//
//  Created by Abyken Nurlan on 02.01.2024.
//  Copyright © 2024 Алпамыс. All rights reserved.
//

import Foundation

struct MasterPassCardRequestBody {
    let token: String
    let amount: Double
    let merchantName: String
    let session: String
    let currencyCode: String
}
