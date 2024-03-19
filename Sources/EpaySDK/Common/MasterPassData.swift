//
//  MasterPassData.swift
//  EpaySDK
//
//  Created by Abyken Nurlan on 01.09.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation

public struct MasterPassData {
    var cardData: MasterPassCardData?
    let token: String
    let merchantName: String
    let session: String
    let isClientParticipation: Bool
    let isVisible: Bool
    let masterPassAction: MasterPassAction
    
    public init(
        token: String,
        merchantName: String,
        session: String,
        isClientParticipation: Bool,
        isVisible: Bool,
        masterPassAction: MasterPassAction
    ) {
        self.token = token
        self.merchantName = merchantName
        self.session = session
        self.isClientParticipation = isClientParticipation
        self.isVisible = isVisible
        self.masterPassAction = masterPassAction
    }

}

public struct MasterPassCardData : Decodable {
    let CardHolder: String
    let PAN: String
    let ExpMonth: String
    let ExpYear: String
    let Success: Bool
    let ErrCode: Int
    let ErrMessage: String
    let WID: String
    let Recommendation: Int
    let Required: Int
    let BioCheck: Int
    let SLI: Int
    let AAV: Int
    let ETID: String
    let MITA: String
    let RRN: String
    let PAR: String
    let TUR: String
    let DEXP: String
    let Crypto: String
    let DPAN: String
}

public struct MasterPassAction {
    let SaveCard: Bool
    let updateSaveCard: Bool?
    let recurring: Bool?
    
    public init(SaveCard: Bool, updateSaveCard: Bool?, recurring: Bool?) {
        self.SaveCard = SaveCard
        self.updateSaveCard = updateSaveCard
        self.recurring = recurring
    }
}

public extension MasterPassCardData {
    var maskedCardNumber: String {
        let firstSixDigit = PAN.prefix(6).description
        let lastFourDigit = PAN.suffix(4).description
        return firstSixDigit + "******" + lastFourDigit
    }
}

