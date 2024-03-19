//
//  CreditCardViewDelegate.swift
//  EpaySDK
//
//  Created by a1pamys on 4/1/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

protocol CreditCardViewDelegate {
    func showAlert(title: String, message: String, actionTitle: String)
    func scanCard()
}
