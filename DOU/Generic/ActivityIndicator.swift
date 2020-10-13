import Foundation
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isLoading: Bool
    
    private let spinner: UIActivityIndicatorView = UIActivityIndicatorView()

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        spinner.style = .large
        spinner.color = .black
        spinner.backgroundColor = .white
        return spinner
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        if isLoading {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }

    func configure(_ indicator: (UIActivityIndicatorView) -> Void) -> some View {
        spinner.hidesWhenStopped = true
        indicator(spinner)
        return self
    }
}
