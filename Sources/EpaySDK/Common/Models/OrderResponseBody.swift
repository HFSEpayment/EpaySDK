//
//  OrderResponseBody.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 14.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import Foundation

class OrderResponseBody: Decodable {
    let id: String
    let amount: Double
    let shopId: String
    let creditConditionId: String
    let approvedAmount: Double
    let approvedMonthCount: Int
    let approvedInterestRate: Double
}
