//
//  String+WidthHeight.swift
//  Eda
//
//  Created by Шпинев Виталий Васильевич on 15/01/2019.
//  Copyright © 2019 Шпинев Виталий Васильевич. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}
