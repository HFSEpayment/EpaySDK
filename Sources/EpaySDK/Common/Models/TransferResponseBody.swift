//
//  TransferResponseBody.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 19.05.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation

struct TransferResponseBody: Decodable {
    let id: String?
    let amount: Double?
    let fee: Double?
    let accountID: String?
    let currency: String?
    let email: String?
    let description: String?
    let reference: String?
    let orderID: String?
    let senderCardID: String?
    let senderCardPAN: String?
    let senderCardType: String?
    let senderTransferType: String?
    let receiverCardID: String?
    let receiverCardPAN: String?
    let receiverCardType: String?
    let receiverTransferType: String?
    let intReference: String?
    let terminalID: String?
}

extension TransferResponseBody {

    var senderCardMaskedNumber: String? {
        guard let lastFourDigit = senderCardPAN?.suffix(4) else { return nil }
        return "・" + lastFourDigit
    }

    var receiverCardMaskedNumber: String? {
        guard let lastFourDigit = receiverCardPAN?.suffix(4) else { return nil }
        return "・" + lastFourDigit
    }

    var senderCardIconName: String {
        if senderCardType?.contains("MasterCard") == true {
            return Constants.Images.mcTranslucent
        } else if senderCardType?.contains("VISA") == true {
            return Constants.Images.visaTranslucent
        } else {
            return ""
        }
    }

    var receiverCardIconName: String {
        if receiverCardType?.contains("MasterCard") == true {
            return Constants.Images.mcTranslucent
        } else if receiverCardType?.contains("VISA") == true {
            return Constants.Images.visaTranslucent
        } else {
            return ""
        }
    }
}
