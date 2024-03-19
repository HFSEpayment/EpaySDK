//
//  TerminalsResponseModel.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 13.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import Foundation

class TerminalsResponseBody: Decodable {
    let id: String
    let terminalId: String
    let singleMessageScheme: Bool
    let shop: ShopResponseBody
    
    class ShopResponseBody: Decodable {
        let id: String
        let name: String
        let url: String
        let merchant: MerchantResponseBody
        
        class MerchantResponseBody: Decodable {
            let id: String
            let tradeName: String
            let companyName: String
            let description: String
            let phone: String
        }
    }
}
