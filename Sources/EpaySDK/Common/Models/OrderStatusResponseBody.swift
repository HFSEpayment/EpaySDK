//
//  OrderStatusResponseBody.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 14.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import Foundation

struct OrderStatusResponseBody: Decodable {
    let id: String
    let name: OrderStatus
}

enum OrderStatus: String, Decodable {
    case new = "NEW"
    case scan = "SCAN"
    case inProgress = "IN_PROGRESS"
    case accept = "ACCEPT"
    case reject = "REJECT"
}
