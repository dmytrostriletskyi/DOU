import SwiftUI

struct ContentView: View {

    private let tabBarStyle: TabBarStyle = TabBarStyle()
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().backgroundColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.black
    }

    var body: some View {
        TabView() {
            LentaView()
                .tabItem {
                    Image(systemName: tabBarStyle.lentaTabImageSystemName)
                    Text("Лента")
                }
                .tag(1)
            ForumView()
                .tabItem {
                    Image(systemName: tabBarStyle.forumTabImageSystemName)
                    Text("Форум")
                }
                .tag(2)
        }.accentColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 11 Pro")
    }
}
