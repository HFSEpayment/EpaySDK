//
//  CreditConditionResponseModel.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 10.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import Foundation

class CreditConditionResponseBody: Decodable {
    let id: String
    let shopId: String
    let monthCount: Int
    let interestRate: Double
}
