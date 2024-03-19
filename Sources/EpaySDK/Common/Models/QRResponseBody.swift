//
//  QRResponseBody.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 07.03.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation
import UIKit

enum QRStatus: String {
    case NEW, SCANNED, BLOCKED, REJECTED, AUTH, PAID
}

struct QRResponseBody: Decodable {
    let qrcode: String?
    let status: String?
    let trType: String?
    let secure3D: Bool?
    let issuer: String?
    let issuerBankCountry: String?
    let fee: Double?
    let amount: Double?
    let currency: String?
    let paymentChannel: String?
    let errDescription: String?
    let retCode: String?
}

extension QRResponseBody {

    var qrImage: UIImage? { qrcode?.image }

    var qrStatus: QRStatus? {
        guard let rawValue = status else { return nil }
        return QRStatus(rawValue: rawValue)
    }
}
