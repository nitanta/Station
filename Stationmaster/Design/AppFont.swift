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
        return Font.system(size: 20)
    }
    
    static var proRegular10: Font {
        return Font.system(size: 10)
    }
    
    static var proRegular14: Font {
        return Font.system(size: 14)
    }
    
    static var proRegular16: Font {
        return Font.system(size: 16)
    }
    
    static var proRegular18: Font {
        return Font.system(size: 18)
    }
    
    static var proRegular32: Font {
        return Font.system(size: 32)
    }
    
    static var proSemibold18: Font {
        return Font.system(size: 18, weight: .semibold, design: .default)
    }
    
    static var proSemibold24: Font {
        return Font.system(size: 24, weight: .semibold, design: .default)
    }
    
}
