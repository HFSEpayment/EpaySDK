//
//  BackspaceTextFieldDelegate.swift
//  EpaySDK
//
//  Created by a1pamys on 4/1/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

protocol BackspaceTextFieldDelegate: class {
    func textFieldDidEnterBackspace(_ textField: BackspaceTextField)
}
