//
//  PublicProfileRequestBody.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 21.02.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation

struct PublicProfileRequestBody {
    let payerEmail: String?
    let payerPhone: String?
    let backLink: String?
    let failureLink: String
    let postLink: String
}
