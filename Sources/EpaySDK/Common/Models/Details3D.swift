//
//  Details3D.swift
//  EpaySDK
//
//  Created by a1pamys on 3/13/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

struct Details3D: Decodable {
    
    // MARK: - Public properties
    
    var paReq: String
    var md: String
    var termURL: String?
    var action: String
}
