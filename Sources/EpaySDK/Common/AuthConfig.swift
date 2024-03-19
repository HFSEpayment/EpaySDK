//
//  AuthConfig.swift
//  EpaySDK
//
//  Created by a1pamys on 2/17/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

public struct AuthConfig {
    
    // MARK: - Public properties
    
    public var merchantId: String
    public var merchantName: String
    public var clientId: String
    public var clientSecret: String
    public var isAppClip: Bool?
    public var appClipToken: String?
    public var appleMerchantId: String?
    
    // MARK: - Initializers
    
    public init(merchantId: String, merchantName: String, clientId: String, clientSecret: String, isAppClip: Bool? = false, appClipToken: String? = nil, appleMerchantId: String? = nil) {
        self.merchantId = merchantId
        self.merchantName = merchantName
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.isAppClip = isAppClip
        self.appClipToken = appClipToken
        self.appleMerchantId = appleMerchantId
    }
    
}


