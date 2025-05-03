//
//  StringExtension.swift
//  SkyScrapper
//
//  Created by Angélica Rodrigues on 20/04/2025.
//

import Foundation

public extension String {
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func formattedAsDateInput(maxDigits: Int = 8) -> String? {
        let digits = self.replacingOccurrences(of: "/", with: "")
        guard digits.count <= maxDigits else { return nil }
        
        var formatted = ""
        for (index, char) in digits.enumerated() {
            if index == 2 || index == 4 {
                formatted.append("/")
            }
            formatted.append(char)
        }
        
        return formatted
    }
}
