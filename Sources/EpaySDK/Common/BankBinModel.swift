//
//  BankBinModel.swift
//  EpaySDK
//
//  Created by a1pamys on 5/17/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

class BankBinModel: Decodable {
    var id: Int
    var name: String
    var code: String
    var checkCodeWord: Bool
    var cardType: String?
    var bins: [Int]?
    
    init(id: Int,
         name: String,
         code: String,
         checkCodeWord: Bool,
         cardType: String?,
         bins: [Int]?) {
        self.id = id
        self.name = name
        self.code = code
        self.checkCodeWord = checkCodeWord
        self.cardType = cardType
        self.bins = bins
    }
    
    static func getBankBinModel() -> [BankBinModel]? {
        if let url = Bundle.module.url(forResource: "bins", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                
                let decoder = JSONDecoder()
                
                let model = try decoder.decode([BankBinModel].self, from: data)
                return model
                
            } catch {
                return nil
            }
        }

        return nil
    }
}
