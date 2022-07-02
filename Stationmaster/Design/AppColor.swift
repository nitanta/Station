//
//  AppColor.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 01/07/2022.
//

import SwiftUI

@propertyWrapper
struct Theme {
    let light: Color
    let dark: Color

    var wrappedValue: Color {
        return ThemeManager.isDarkModeEnabled ? self.dark : self.light
    }
}

enum ThemeManager {
    static var isDarkModeEnabled = false
}


struct AppColor {
    
    enum BackGround {
        @Theme(light: .white, dark: .white)
        static var background: Color
    }
    
    enum Components {
        
        enum TabBar {
            @Theme(light: AppColor.blue, dark: AppColor.blue)
            static var tint: Color
        }
        
    }

    @Theme(light: .black, dark: .black)
    static var primaryText: Color
    
    @Theme(light: .gray, dark: .gray)
    static var primaryLightText: Color
    
    @Theme(light: .white, dark: .white)
    static var textWhite: Color
    
    @Theme(light: .red, dark: .red)
    static var red: Color
    
    @Theme(light: .green, dark: .green)
    static var green: Color
    
    @Theme(light: .blue, dark: .blue)
    static var blue: Color
    
    
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
