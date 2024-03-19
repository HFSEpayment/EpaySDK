//
//  TransferType.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 20.04.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import Foundation

public enum TransferType: String, CaseIterable {
    case P2P, AFT, OCT, CardId, byPhone, masterPass
}
