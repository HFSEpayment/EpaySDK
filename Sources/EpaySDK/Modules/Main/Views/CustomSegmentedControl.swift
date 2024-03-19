//
//  CustomSegmentedControl.swift
//  EpaySDK
//
//  Created by Dias Dauletov on 16.12.2021.
//  Copyright © 2021 Алпамыс. All rights reserved.
//

import Foundation
import UIKit

class ItemView: UIView {
    var title: String = "" {
        didSet {
            label.text = title
        }
    }
    
    var selected: Bool = false {
        didSet {
            if selected {
                label.textColor = UIColor(hexString: "#2AA65C")
                layer.borderColor = UIColor(hexString: "#2AA65C").cgColor
                backgroundColor = .white
            } else {
                label.textColor = UIColor(hexString: "#99A3B3")
                layer.borderColor = UIColor(hexString: "#99A3B3").cgColor
                backgroundColor = UIColor(hexString: "#FBFCFC")
            }
        }
    }
    
    var isFirstItem: Bool = false {
        didSet {
            if isFirstItem {
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
                layer.cornerRadius = 10
            }
        }
    }
    
    var isLastItem: Bool = false {
        didSet {
            if isLastItem {
                layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
                layer.cornerRadius = 10
            }
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MuseoSansCyrl-700", size: 12)
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#99A3B3")
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(label)
        
        label.anchor(centerX: centerXAnchor, centerY: centerYAnchor)
        layer.borderWidth = 1
        layer.borderColor = UIColor(hexString: "#99A3B3").cgColor
        backgroundColor = UIColor(hexString: "#FBFCFC")
    }
}

class CustomSegmentedControl: UIView {
    weak var delegate: PaymentViewDelegate?
    
    var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex < itemViews.count {
                itemViews[oldValue].selected = false
                itemViews[selectedIndex].selected = true
            }
        }
    }
    
    var itemTitles: [String] = [] {
        didSet {
            var newItemViews: [ItemView] = []
            for title in itemTitles {
                newItemViews.append(getItemView(with: title))
            }
            newItemViews.first?.isFirstItem = true
            newItemViews.last?.isLastItem = true
            
            itemViews = newItemViews
        }
    }
    
    private var itemViews: [ItemView] = [] {
        didSet {
            stackView.removeAllArrangedSubviews()
            
            for view in itemViews {
                stackView.addArrangedSubview(view)
            }
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    init(delegate: PaymentViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getItemView(with title: String) -> ItemView {
        let view = ItemView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        view.title = title
        return view
    }
    
    @objc func didTap(sender: UITapGestureRecognizer) {
        guard let index = itemViews.firstIndex(where: { $0 == sender.view }) else { return }
        selectedIndex = index
        delegate?.installmentMonthsChanged(to: itemTitles[selectedIndex])
    }
}

private extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
