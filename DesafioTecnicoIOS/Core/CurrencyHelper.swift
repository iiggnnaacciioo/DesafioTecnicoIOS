//
//  CurrencyHelper.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 31-08-24.
//

import Foundation

struct CurrencyHelper {
    static func formatDollarToCLPesos(amount: Double, exchangeRate: Double) -> String {
        let amountInPesos = amount * exchangeRate
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "es_CL")
        formatter.numberStyle = .currency
        return formatter.string(from: amountInPesos as NSNumber) ?? "$ \(Int(amountInPesos))"
    }
}
