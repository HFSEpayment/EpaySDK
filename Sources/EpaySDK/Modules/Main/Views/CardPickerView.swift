//
//  CardPickerView.swift
//  EpaySDK
//
//  Created by Daulet Tungatarov on 25.03.2023.
//  Copyright © 2023 Алпамыс. All rights reserved.
//

import UIKit

protocol CardPickerViewDelegate: AnyObject {
    func didSelect(card: HomeBankCard)
}

class CardPickerView: UIView {

    private let tableView = UITableView()

    private let cellId = String(describing: CardPickerCell.self)
    private let cards: [HomeBankCard]

    weak var delegate: CardPickerViewDelegate?

    init(cards: [HomeBankCard]) {
        self.cards = cards
        super.init(frame: .zero)

        addSubview(tableView)
        stylize()
        tableView.anchor(top: topAnchor, right: rightAnchor, left: leftAnchor, bottom: bottomAnchor)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func stylize() {
        backgroundColor = .white
        layer.cornerRadius = 6

        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 8))
        tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 8))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CardPickerCell.self, forCellReuseIdentifier: cellId)
    }
}

extension CardPickerView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CardPickerCell else {
            return UITableViewCell()
        }
        cell.set(card: cards[indexPath.row])
        return cell
    }
}

extension CardPickerView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelect(card: cards[indexPath.row])
    }
}
