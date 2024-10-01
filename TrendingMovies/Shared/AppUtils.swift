//
//  AppUtils.swift
//  TrendingMovies
//
//  Created by Mohamed Sayed on 01/10/2024.
//

import Foundation

class AppUtils {
    // Function to format currency
    static func formatCurrency(_ amount: Int?) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: amount ?? 0)) ?? ""
    }

    // Function to extract year and month from date string
    static func extractYearAndMonth(from dateString: String, with format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: dateString) else { return "" }

        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        let monthName = monthFormatter.string(from: date)

        return "\(monthName) \(year)"
    }
}
