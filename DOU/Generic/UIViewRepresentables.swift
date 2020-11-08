import Foundation
import SwiftUI

import Atributika

struct PostTextView: UIViewRepresentable {
    let uiView: AttributedLabel

    func makeUIView(context: Context) -> AttributedLabel { return uiView }
    func updateUIView(_ uiView: AttributedLabel, context: Context) {}
}

struct PostImageView: UIViewRepresentable {
    let uiView: AttributedLabel

    func makeUIView(context: Context) -> AttributedLabel { return uiView }
    func updateUIView(_ uiView: AttributedLabel, context: Context) {}
}
