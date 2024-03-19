//
//  TokenResponseBody.swift
//  EpaySDK
//
//  Created by a1pamys on 2/17/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

public struct TokenResponseBody: Decodable {
    
    // MARK: - Public properties
    
    var access_token: String
    var expires_in: String
    var scope: String
    var token_type: String
    
    init(access_token: String,
         expires_in: String,
         scope: String,
         token_type: String) {
        self.access_token = access_token
        self.expires_in = expires_in
        self.scope = scope
        self.token_type = token_type
    }
}
