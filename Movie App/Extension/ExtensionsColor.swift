//
//  Extensions.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 02.07.2022.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat,g:CGFloat,b:CGFloat,a:CGFloat = 1) {
        self.init(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0,
            alpha: a
        )
    }
}
