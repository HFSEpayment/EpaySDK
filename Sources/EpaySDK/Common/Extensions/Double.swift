//
//  Double.swift
//  EpaySDK
//
//  Created by a1pamys on 5/17/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
