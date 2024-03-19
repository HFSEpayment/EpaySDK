//
//  File.swift
//  EpaySDK
//
//  Created by a1pamys on 4/1/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation
import UIKit

protocol PaymentViewDelegate: AnyObject {
    func makePayment(pan: String, expDate: String, cvc: Int, name: String?, email: String?, phone: String?, useGoBonus: Bool, isMasterPass: Bool?, saveCard: Bool?)
    func showAlert(title: String, message: String, actionTitle: String)
    func scanCard()
    func popMainViewController()
    func updateTableView()
    func requestGoBonus(pan: String, expDate: String, cvc: Int)
    func makeInstallment()
    func installmentMonthsChanged(to months: String)
    func showCardPicker(under cardView: UIView)
    func makeHalykIDPayment(useGoBonus: Bool)
    func didTapPayInHomebank()
    func didTapApplePayButton()
}
