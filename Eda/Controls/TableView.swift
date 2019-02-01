//
//  TableView.swift
//  Eda
//
//  Created by Шпинев Виталий Васильевич on 16/01/2019.
//  Copyright © 2019 Шпинев Виталий Васильевич. All rights reserved.
//

import UIKit

class TableView: UITableView {
    
    private let tableCellReuseId = "restaurantCell"
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        register(RestaurantCell.self, forCellReuseIdentifier: tableCellReuseId)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - UITableViewDelegate functions
extension TableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
