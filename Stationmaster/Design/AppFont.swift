//
//  AppFont.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 01/07/2022.
//

import SwiftUI

struct AppFont {
    
    enum FontNames {
        static var regular = "SFProText-Regular"
        static var medium = "SFProText-Medium"
        static var semibold = "SFProText-Semibold"
        static var bold = "SFProText-Bold"
    }
    
    static var navbarFont: Font {
        return Font.custom(FontNames.medium, size: 20)
    }
    
    static var proMedium10: Font {
        return Font.custom(FontNames.medium, size: 10)
    }
    
    static var proRegular14: Font {
        return Font.custom(FontNames.regular, size: 14)
    }
    
    static var proRegular16: Font {
        return Font.custom(FontNames.regular, size: 16)
    }
    
    static var proRegular18: Font {
        return Font.custom(FontNames.regular, size: 18)
    }
    
    static var proRegular32: Font {
        return Font.custom(FontNames.regular, size: 32)
    }
    
    static var proSemibold18: Font {
        return Font.custom(FontNames.semibold, size: 14)
    }
    
    static var proSemibold24: Font {
        return Font.custom(FontNames.semibold, size: 24)
    }
    
}
