//
//  MeasurementFormatter+Extension.swift
//  NearMeApp
//
//  Created by Brian Surface on 10/13/24.
//

import Foundation


extension MeasurementFormatter {
    static var distance:MeasurementFormatter{
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        formatter.locale = Locale.current
        return formatter
    }
}
