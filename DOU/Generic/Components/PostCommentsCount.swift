import Foundation

import SwiftUI

struct PostCommentsCount: View {
    let commentsCount: Int64
    let imageSystemNane: String
    let font: String
    let color: Color
    let size: CGFloat

    var body: some View {
        HStack {
            (
                Text(
                    Image(
                        systemName: imageSystemNane
                    )
                ) + Text(
                    " \(commentsCount)")
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
}
