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
//            HomeView()
            LentaView()
                .tabItem {
                    Image(systemName: tabBarStyle.homeTabImageSystemName)
                    Text("Главная")
                }
                .tag(0)
            LentaView()
                .tabItem {
                    Image(systemName: tabBarStyle.lentaTabImageSystemName)
                    Text("Лента")
                }
                .tag(1)
            JobsView()
                .tabItem {
                    Image(systemName: tabBarStyle.forumTabImageSystemName)
                    Text("Форум")
                }
                .tag(2)
            JobsView()
                .tabItem {
                    Image(systemName: tabBarStyle.jobsTabImageSystemName)
                    Text("Работа")
                }
                .tag(2)
            UserView()
                .tabItem {
                    Image(systemName: tabBarStyle.settingsTabImageSystemName)
                    Text("Настройки")
                }
                .tag(3)
        }.accentColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 11 Pro")
    }
}
