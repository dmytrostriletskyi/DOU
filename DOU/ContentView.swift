import SwiftUI

import URLImage

struct ContentView: View {

    @State var showLaunchScreen = true
    @State var showLaunchScreenTimerSeconds = 2
    @State private var articles = [Article]()
    
    private let style: Style = Style()
    private let showLaunchScreenTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let articlesService: ArticlesService = ArticlesService(
        source: ArticlesApiSource()
    )

    init() {
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().backgroundColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.black
    }

    var body: some View {
        Group {
            if showLaunchScreen {
                GeometryReader { geo in
                    Color.black.edgesIgnoringSafeArea(.all)
                    URLImage(
                        URL(
                            string: "https://hsto.org/webt/5k/8b/ie/5k8bieusukdmvczompbkyto_x6o.png"
                        )!
                    ) { proxy in
                        proxy.image.resizable().aspectRatio(contentMode: .fill).clipped()
                    }.frame(
                        width: geo.size.width,
                        height: geo.size.height
                    )
                }.onReceive(showLaunchScreenTimer) { _ in
                    if self.showLaunchScreenTimerSeconds > 0 {
                        self.showLaunchScreenTimerSeconds -= 1
                    }
                    
                    if self.showLaunchScreenTimerSeconds == 0 {
                        self.showLaunchScreen = false
                    }
                }.onAppear {
                    self.articlesService.get { result in
                        self.articles = result
                    }
                }
            }
            
            if !showLaunchScreen {
                TabView() {
                    ArticlesScreenView(articlesService: articlesService, initialArticles: articles).tabItem {
                        Image(systemName: style.articlesTabImageSystemName)
                        Text(style.articlesTabItemNameUkrainian)
                    }.tag(1)
                    ArticlesScreenView(articlesService: articlesService, initialArticles: articles).tabItem {
                        Image(systemName: style.forumTabImageSystemName)
                        Text(style.forumTabItemNameUkrainian)
                    }.tag(2)
                    SalariesView().tabItem {
                        Image(systemName: style.salariesTabImageSystemName)
                        Text(style.salariesTabItemNameUkrainian)
                    }.tag(3)
                }.accentColor(
                    .white
                ).accentColor(
                    .blue
                )
            }
        }.transition(
            .opacity
        ).animation(
            .easeInOut
        )
    }
    
    struct Style {
        public let articlesTabImageSystemName: String = "doc.plaintext"
        public let forumTabImageSystemName: String = "text.bubble"
        public let salariesTabImageSystemName: String = "dollarsign.circle"
        public let articlesTabItemNameUkrainian: String = "Стрічка"
        public let articlesTabItemNameRussian: String = "Лента"
        public let forumTabItemNameUkrainian: String = "Форум"
        public let forumTabItemNameRussian: String = "Форум"
        public let salariesTabItemNameUkrainian: String = "Зарплати"
        public let salariesTabItemNameRussian: String = "Зарплаты"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 11 Pro")
    }
}
