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
    public var merchantName: String
    public var isAppClip: Bool?
    public var appClipToken: String
    public var appleMerchantId: String?
    
    // MARK: - Initializers
    
    public init(merchantName: String, isAppClip: Bool? = false, appClipToken: String, appleMerchantId: String? = nil) {
        self.merchantName = merchantName
        self.isAppClip = isAppClip
        self.appClipToken = appClipToken
        self.appleMerchantId = appleMerchantId
    }
    
}


