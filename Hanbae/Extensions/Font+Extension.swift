//
//  Extension+Font.swift
//  Macro
//
//  Created by Lee Wonsun on 10/10/24.
//

import SwiftUI

extension Font {
    static func pretendardMedium(size: CGFloat) -> Font {
        return Font.custom("Pretendard-Medium", size: size)
    }
    
    static func pretendardRegular(size: CGFloat) -> Font {
        return Font.custom("Pretendard-Regular", size: size)
    }
    
    static func pretendardBold(size: CGFloat) -> Font {
        return Font.custom("Pretendard-Bold", size: size)
    }
    
    static func pretendardSemiBold(size: CGFloat) -> Font {
        return Font.custom("Pretendard-SemiBold", size: size)
    }
    
    static var LargeTitle_R: Font {
        return pretendardRegular(size: 34)
    }
    
    static var LargeTitle_B: Font {
        return pretendardBold(size: 34)
    }
    
    static var Title1_R: Font {
        return pretendardRegular(size: 28)
    }
    
    static var Title1_B: Font {
        return pretendardBold(size: 28)
    }
    
    static var Title2_R: Font {
        return pretendardRegular(size: 22)
    }
    
    static var Title2_B: Font {
        return pretendardBold(size: 22)
    }
    
    static var Title3_R: Font {
        return pretendardRegular(size: 20)
    }
    
    static var Title3_SB: Font {
        return pretendardSemiBold(size: 20)
    }
    
    static var Headline_SB: Font {
        return pretendardSemiBold(size: 17)
    }
    
    static var Body_R: Font {
        return pretendardRegular(size: 17)
    }
    
    static var Body_SB: Font {
        return pretendardSemiBold(size: 17)
    }
    
    static var Callout_R: Font {
        return pretendardRegular(size: 16)
    }
    
    static var Callout_SB: Font {
        return pretendardSemiBold(size: 16)
    }
    
    static var Subheadline_R: Font {
        return pretendardRegular(size: 15)
    }
    
    static var Subheadline_SB: Font {
        return pretendardSemiBold(size: 15)
    }
    
    static var Footnote_R: Font {
        return pretendardRegular(size: 13)
    }
    
    static var Footnote_SB: Font {
        return pretendardSemiBold(size: 13)
    }
    
    static var Caption1_R: Font {
        return pretendardRegular(size: 12)
    }
    
    static var Caption1_M: Font {
        return pretendardMedium(size: 12)
    }
    
    static var Caption2_R: Font {
        return pretendardRegular(size: 11)
    }
    
    static var Caption2_SB: Font {
        return pretendardSemiBold(size: 11)
    }
}

extension Font {
    static func gosanja(size: CGFloat) -> Font {
        return Font.custom("GosanjaOTF", size: size)
    }
}
