//
//  OrderRequestBody.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 14.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import Foundation

struct OrderRequestBody {
    let shopId: String
    let amount: Double
    let orderId: String
    let creditConditionId: String
}
