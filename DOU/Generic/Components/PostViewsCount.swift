import Foundation

import SwiftUI

struct PostViewsCount: View {
    let viewsCount: Int64
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
                    " \(viewsCount)")
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
