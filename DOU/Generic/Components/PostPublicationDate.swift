import Foundation

import SwiftUI

struct PostPublicationDate: View {
    let publicationDate: String
    let font: String
    let color: Color
    let size: CGFloat

    var body: some View {
        Text(
            publicationDate
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
