//
//  LicenseView.swift
//  EpaySDK
//
//  Created by a1pamys on 2/22/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

class LicenseView: UIView {

    private lazy var logoImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: Constants.Images.hbLogo, in: Bundle.module, compatibleWith: nil)
        return v
    }()
    
    private lazy var licenseLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .right
        l.font = UIFont.systemFont(ofSize: 8)
        let year = Calendar.current.component(.year, from: Date())
        l.text = String(Constants.Localizable.halykLicense).localized()
        + String(year) + String(Constants.Localizable.halyJsc).localized()
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoImageView)
        addSubview(licenseLabel)
        
        logoImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 30, paddingLeft: 16, width: 90, height: 30)
        licenseLabel.anchor(top: topAnchor, right: rightAnchor, left: logoImageView.rightAnchor, bottom: bottomAnchor, paddingTop: 30, paddingRight: 16, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCustomText(color: UIColor?) {
        licenseLabel.textColor = color
    }
}
