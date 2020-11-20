import Foundation

import SwiftUI

struct PostAuthorName: View {
    let authorName: String
    let font: String
    let color: Color
    let size: CGFloat

    var body: some View {
        Text(
            authorName
        ).font(
            .custom(
                font,
                size: size
            )
        ).foregroundColor(
            color
        )
    }
}
