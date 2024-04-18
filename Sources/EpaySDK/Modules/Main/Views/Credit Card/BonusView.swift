//
//  BonusView.swift
//  EpaySDK
//
//  Created by a1pamys on 2/11/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

class BonusView: UIView {
    
    // MARK: - Properties
    
    private var useGoBonus = false
    
    private var actualPrice: Double = 0 
    
    private var bonus: Double = 0 {
        didSet {
            actualLabel.text = String(actualPrice)
            bonusLabel.text = String(0.0)
            bonusAmountLabel.text = String(bonus.rounded(toPlaces: 2)) + " GO!"
        }
    }
    
    var colorScheme: PublicProfileResponseBody.Assets.ColorScheme? {
        didSet { setCustomStyles() }
    }
    
    // MARK: - UI Elements
    
    private lazy var spendBonusLabel: UILabel = {
        let l = UILabel()
        l.text = String(
            Constants.Localizable.useBonuses
        ).localized()
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    private lazy var bonusAmountLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = UIFont.boldSystemFont(ofSize: 14)
        return l
    }()
    
    private lazy var toggleSwitch: UISwitch = {
        let v = UISwitch()
        v.onTintColor = UIColor.mainColor
        v.addTarget(self, action: #selector(handleToggleSwitch), for: .valueChanged)
        return v
    }()
    
    private lazy var chargeLabel: UILabel = {
        let l = UILabel()
        l.text = String(
            Constants.Localizable.willBeCharged
        ).localized()
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    private lazy var bonusLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    private lazy var bonusLabelView: UIView = {
        let v = UIView()
        v.addSubview(bonusLabel)
        bonusLabel.anchor(top: v.topAnchor, right: v.rightAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, paddingTop: 4, paddingRight: 12, paddingLeft: 12, paddingBottom: 4)
        v.backgroundColor = UIColor(hexString: "#DCDCDC")
        v.layer.cornerRadius = 3
        v.layer.masksToBounds = true
        return v
    }()
    
    private lazy var actualLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    private lazy var actualLabelView: UIView = {
        let v = UIView()
        v.addSubview(actualLabel)
        actualLabel.anchor(top: v.topAnchor, right: v.rightAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, paddingTop: 4, paddingRight: 12, paddingLeft: 12, paddingBottom: 4)
        v.backgroundColor = UIColor.mainColor
        v.layer.cornerRadius = 3
        v.layer.masksToBounds = true
        return v
    }()
    
    private lazy var fromCardLabel: UILabel = {
        let l = UILabel()
        l.text = String(
            Constants.Localizable.fromCard
        ).localized()
        l.textColor = UIColor(hexString: "#566681")
        l.font = UIFont.systemFont(ofSize: 10)
        return l
    }()
    
    private lazy var fromBonusLabel: UILabel = {
        let l = UILabel()
        l.text = String(
            Constants.Localizable.fromBonus
        ).localized()
        l.textColor = UIColor(hexString: "#566681")
        l.font = UIFont.systemFont(ofSize: 10)
        return l
    }()
    
    private lazy var plusSignLabel: UILabel = {
        let l = UILabel()
        l.text = "+"
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    private func setCustomStyles() {
        if let textColor = colorScheme?.textColor {
            spendBonusLabel.textColor = textColor
            chargeLabel.textColor = textColor
            plusSignLabel.textColor = textColor
            fromCardLabel.textColor = textColor
            fromBonusLabel.textColor = textColor
            bonusAmountLabel.textColor = textColor
        }
    }
    
    // MARK: - Initializers
    
    init(price: Double) {
        self.actualPrice = price
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    public func setBonus(bonus: Double) {
        self.bonus = bonus
    }
    
    public func shouldUseGoBonus() -> Bool {
        return useGoBonus
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        addSubview(spendBonusLabel)
        addSubview(bonusAmountLabel)
        addSubview(toggleSwitch)
        addSubview(chargeLabel)
        addSubview(actualLabelView)
        addSubview(plusSignLabel)
        addSubview(bonusLabelView)
        addSubview(fromCardLabel)
        addSubview(fromBonusLabel)
    }
    
    private func setupConstraints() {
        spendBonusLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 36)
        bonusAmountLabel.anchor(left: spendBonusLabel.rightAnchor, bottom: spendBonusLabel.bottomAnchor, paddingTop: 36)
        toggleSwitch.anchor(right: rightAnchor, height: 32, centerY: spendBonusLabel.centerYAnchor)
        chargeLabel.anchor(top: spendBonusLabel.bottomAnchor, left: leftAnchor, paddingTop: 32)
        bonusLabelView.anchor(right: rightAnchor, centerY: chargeLabel.centerYAnchor)
        fromBonusLabel.anchor(top: bonusLabelView.bottomAnchor,centerX: bonusLabelView.centerXAnchor)
        plusSignLabel.anchor(right: bonusLabelView.leftAnchor, paddingRight: 16, centerY: chargeLabel.centerYAnchor)
        actualLabelView.anchor(right: plusSignLabel.leftAnchor, paddingRight: 16, centerY: chargeLabel.centerYAnchor)
        fromCardLabel.anchor(top: actualLabelView.bottomAnchor, bottom: bottomAnchor, centerX: actualLabelView.centerXAnchor)
    }
    
    @objc private func handleToggleSwitch(sender: UISwitch) {
        if sender.isOn {
            bonusLabel.text = bonus >= actualPrice ? String(actualPrice.rounded(toPlaces: 2)) : String(bonus.rounded(toPlaces: 2))
            actualLabel.text = bonus >= actualPrice ? String(0.0) : String((actualPrice - bonus).rounded(toPlaces: 2))
        }
        else {
            bonusLabel.text = String(0.0)
            actualLabel.text = String(actualPrice)
        }
        useGoBonus = sender.isOn
    }
}
