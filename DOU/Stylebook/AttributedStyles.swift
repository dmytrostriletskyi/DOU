import Foundation
import SwiftUI

import Atributika

struct AttributedPostItemStyle {
    let textSize: CGFloat = 16
    let emphasizedTextSize: CGFloat = 12
    let emphasizedTextObliqueness: Float = 0.24
    let headerOneSize: CGFloat = 22
    let headerTwoSize: CGFloat = 20
    let headerThreeSize: CGFloat = 18
    let headerFourSize: CGFloat = 16
    let headerFiveSize: CGFloat = 14
    let headerSixSize: CGFloat = 12
    let headerWeight: UIFont.Weight = UIFont.Weight.bold
    let paragraphLineSPacing: Float = 2
    let linkColor: Atributika.Color = Atributika.Color(red: 0.09, green: 0.46, blue: 0.67, alpha: 1.00)
    let linkUnderlineStyle = NSUnderlineStyle.single
    let informationFont: String = "Arial"
    let informationSize: Int64 = 13
    let informationColor: SwiftUI.Color = SwiftUI.Color(
        red: 0,
        green: 0,
        blue: 0,
        opacity: 1.0
    )
    let viewsImageSystemName: String = "eye.fill"
}
