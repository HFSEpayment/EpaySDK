//
//  TransferRequestBody.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 18.05.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation

struct TransferRequestBody: Encodable {

    struct Order: Encodable {
        let amount: Double?
        let currency: String?
        let description: String?
        let id: String?
        var senderEmail: String?
        let foreign: Bool = false
        let terminalId: String?
        var backLink: String?
        var failureBackLink: String?
        let postLink: String?
        let failurePostLink: String?
    }

    struct Card: Encodable {
        var sender: TransferSender?
        var receiver: TransferReceiver?
    }

    let order: Order
    let card: Card
}

struct TransferSender: Encodable {

    struct CardExpiration: Encodable {
        let month: String?
        let year: String?
    }

    var save: Bool = false
    var address: String?
    var cvc: String?
    var id: String?
    var expire: CardExpiration?
    var name: String? = nil
    var cardCred: String?
    var transferType = "TYPEPAN"
}

struct TransferReceiver: Encodable {
    var save: Bool = false
    var address: String?
    var id: String?
    var cardCred: String?
    var transferType = "TYPEPAN"
    var name: String? = nil
    var firstName: String?
    var lastName: String?
    var city: String?
    var country: String?
    var docNumber: String?
    var phone: String?
    var iin: String?    
}
