import Foundation

import SwiftUI

struct PostTitle: View {
    let title: String
    let font: String
    let color: Color
    let size: CGFloat

    var body: some View {
        Text(
            title
        ).font(
            .custom(
                font,
                size: size
            )
        ).fontWeight(
            .semibold
        ).foregroundColor(
            color
        ).multilineTextAlignment(
            .leading
        )
    }
}
