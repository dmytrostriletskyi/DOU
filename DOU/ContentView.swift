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
            ArticlesView()
                .tabItem {
                    Image(systemName: tabBarStyle.lentaTabImageSystemName)
                    Text("Стрічка")
                }.tag(1)
            ForumView()
                .tabItem {
                    Image(systemName: tabBarStyle.forumTabImageSystemName)
                    Text("Форум")
                }.tag(2)
            SalariesView()
                .tabItem {
                    Image(systemName: tabBarStyle.forumTabImageSystemName)
                    Text("Зарплати")
                }.tag(3)
        }.accentColor(.white).accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 11 Pro")
    }
}
