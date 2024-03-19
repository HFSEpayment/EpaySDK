
//  URL.swift
//  EpaySDK
//
//  Created by a1pamys on 2/24/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import Foundation

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
