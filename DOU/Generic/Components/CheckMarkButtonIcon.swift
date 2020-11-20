import Foundation
import SwiftUI

struct CheckMarkButtonIcon: View {
    var body: some View {
        Image(
            systemName: "checkmark"
        ).foregroundColor(
            Color.blue
        ).font(
            Font.system(
                size: 15,
                weight: .semibold
            )
        )
    }
}
