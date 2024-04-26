//
//  PaymentTypeView.swift
//  EpaySDK
//
//  Created by a1pamys on 2/11/20.
//  Copyright © 2020 Алпамыс. All rights reserved.
//

import UIKit

protocol PaymentTypesViewDelegate: AnyObject {
    func didSelectPayment(type: PaymentType)
}

class PaymentTypesView: UIView {

    private let leftLineView = UIView()
    private let rightLineView = UIView()
    private let titleLabel = UILabel()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

    private let cellId = String(describing: PaymentTypeCell.self)

    private let paymentTypes: [PaymentType]
    private let selectedPaymentType: PaymentType
    private let colorScheme: PublicProfileResponseBody.Assets.ColorScheme?
    weak var delegate: PaymentTypesViewDelegate?

    init(
        paymentTypes: [PaymentType],
        selectedPaymentType: PaymentType,
        colorScheme: PublicProfileResponseBody.Assets.ColorScheme?,
        delegate: PaymentTypesViewDelegate?
    ) {
        self.paymentTypes = paymentTypes
        self.selectedPaymentType = selectedPaymentType
        self.colorScheme = colorScheme
        self.delegate = delegate
        super.init(frame: .zero)

        addSubviews()
        setLayoutConstraints()
        stylize()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(leftLineView)
        addSubview(rightLineView)
        addSubview(collectionView)
    }

    private func setLayoutConstraints() {

        let rowsCount = paymentTypes.count % 2 == 0 ? paymentTypes.count / 2 : (paymentTypes.count + 1) / 2
        let collectionViewHeight = CGFloat(rowsCount * 44 + (rowsCount - 1) * 10)

        //@Dos turn off line payment
//        titleLabel.anchor(top: topAnchor, paddingTop: 8, centerX: centerXAnchor)
//
//        leftLineView.anchor(
//            right: titleLabel.leftAnchor,
//            left: leftAnchor,
//            paddingRight: 10,
//            paddingLeft: 24,
//            height: 1,
//            centerY: titleLabel.centerYAnchor
//        )
//
//        rightLineView.anchor(
//            right: rightAnchor,
//            left: titleLabel.rightAnchor,
//            paddingRight: 24,
//            paddingLeft: 10,
//            height: 1,
//            centerY: titleLabel.centerYAnchor
//        )

        collectionView.anchor(
            top: titleLabel.bottomAnchor,
            right: rightAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            paddingTop: 16,
            paddingRight: 16,
            paddingLeft: 16,
            paddingBottom: 8,
            height: collectionViewHeight
        )
    }

    private func stylize() {
        backgroundColor = .clear

        titleLabel.text = String(Constants.Localizable.choosePaymentMethod).localized()
        titleLabel.textColor = colorScheme?.textColor
        titleLabel.font = UIFont.systemFont(ofSize: 14)

        leftLineView.backgroundColor = colorScheme?.textColor
        rightLineView.backgroundColor = colorScheme?.textColor

        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 10

        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PaymentTypeCell.self, forCellWithReuseIdentifier: cellId)
    }
}

extension PaymentTypesView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paymentTypes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let typeCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PaymentTypeCell
        guard let cell = typeCell else { return UICollectionViewCell() }
        cell.isSelected = paymentTypes[indexPath.item] == selectedPaymentType
        cell.setImage(by: paymentTypes[indexPath.item].iconName)
        cell.setColor(scheme: colorScheme)
        
        return cell
    }
}

extension PaymentTypesView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectPayment(type: paymentTypes[indexPath.item])
    }
}

extension PaymentTypesView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        //@Dos added 3 lines block instead 2
        // CGSize(width: (collectionView.frame.width - 8) / 2, height: 44)
        return CGSize(width: (collectionView.frame.width - 250), height: 44)
    }
}
