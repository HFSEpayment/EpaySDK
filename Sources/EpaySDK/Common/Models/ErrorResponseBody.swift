//
//  ErrorResponseBody.swift
//  EpaySDK
//
//  Created by a1pamys on 2/18/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

public struct ErrorResponseBody: Decodable {
    
    // MARK: - Public properties
    
    var code: Int
    var message: String

    // MARK: - Initializers
    
    init(code: Int = -1, message: String) {
        self.code = code
        self.message = message
    }
}
