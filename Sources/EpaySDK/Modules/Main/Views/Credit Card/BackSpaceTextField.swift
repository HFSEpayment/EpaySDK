//
//  BackSpaceTextField.swift
//  EpaySDK
//
//  Created by a1pamys on 4/1/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

class BackspaceTextField: SkyFloatingLabelTextField {
    weak var backspaceTextFieldDelegate: BackspaceTextFieldDelegate?

    override func deleteBackward() {
        if text?.isEmpty ?? false {
            backspaceTextFieldDelegate?.textFieldDidEnterBackspace(self)
        }

        super.deleteBackward()
    }
    
}
