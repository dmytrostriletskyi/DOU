import Foundation
import SwiftUI

import Atributika

struct AttributedPostItemStyle {
    
    public let textSize: CGFloat = 16

    public let emphasizedTextSize: CGFloat = 12
    public let emphasizedTextObliqueness: Float = 0.24

    public let headerOneSize: CGFloat = 22
    public let headerTwoSize: CGFloat = 20
    public let headerThreeSize: CGFloat = 18
    public let headerFourSize: CGFloat = 16
    public let headerFiveSize: CGFloat = 14
    public let headerSixSize: CGFloat = 12
    public let headerWeight: UIFont.Weight = UIFont.Weight.bold
    
    public let paragraphLineSPacing: Float = 2
    
    public let linkColor: Atributika.Color = Atributika.Color(red: 0.09, green: 0.46, blue: 0.67, alpha: 1.00)
    public let linkUnderlineStyle: NSUnderlineStyle = NSUnderlineStyle.single
    
    public let informationFont: String = "Arial"
    public let informationSize: Int64 = 13
    public let informationColor: SwiftUI.Color = SwiftUI.Color(
        red: 0,
        green: 0,
        blue: 0,
        opacity: 1.0
    )
    
    public let viewsImageSystemName: String = "eye.fill"
}
