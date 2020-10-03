import SwiftUI

struct LentaView: View {

    private let navigationBarStyle: NavigationBarStyle = NavigationBarStyle()

    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont(
                    name: navigationBarStyle.headerFont,
                    size: CGFloat(navigationBarStyle.headerSize
                )
            )!,
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            PublicationsView()
        }
    }
}

struct LentaView_Previews: PreviewProvider {
    static var previews: some View {
        LentaView()
    }
}
