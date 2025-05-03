//
//  UIStackView+Extension.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 25/04/2025.
//
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
