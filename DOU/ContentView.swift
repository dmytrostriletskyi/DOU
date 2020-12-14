import SwiftUI

import URLImage

struct ContentView: View {
    @State var showLaunchScreen = true
    @State var showLaunchScreenTimerSeconds = 2

    private let style = Style()
    private let showLaunchScreenTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let articlesService = ArticlesService(source: ArticlesApiSource())
    private let topicsService = TopicsService()
    @State private var articles = [Article]()
    @State private var topics = [Topic]()

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

                    self.topicsService.get { result in
                        self.topics = result
                    }
                }
            }

            if !showLaunchScreen {
                TabView() {
                    ArticlesScreenView(articlesService: articlesService, initialArticles: articles).tabItem {
                        Image(systemName: style.articlesTabImageSystemName)
                        Text(style.articlesTabItemNameUkrainian)
                    }.tag(1)
                    TopicsView(topicsService: topicsService, initialTopics: topics).tabItem {
                        Image(systemName: style.topicsTabImageSystemName)
                        Text(style.topicsTabItemNameUkrainian)
                    }.tag(2)
                    SalariesView().tabItem {
                        Image(systemName: style.salariesTabImageSystemName)
                        Text(style.salariesTabItemNameUkrainian)
                    }.tag(3)
                }.accentColor(
                    .white
                )
            }
        }.transition(
            .opacity
        ).animation(
            .easeInOut
        )
    }

    struct Style {
        let articlesTabImageSystemName: String = "doc.plaintext"
        let topicsTabImageSystemName: String = "text.bubble"
        let salariesTabImageSystemName: String = "dollarsign.circle"
        let articlesTabItemNameUkrainian: String = "Стрічка"
        let articlesTabItemNameRussian: String = "Лента"
        let topicsTabItemNameUkrainian: String = "Форум"
        let topicsTabItemNameRussian: String = "Форум"
        let salariesTabItemNameUkrainian: String = "Зарплати"
        let salariesTabItemNameRussian: String = "Зарплаты"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 11 Pro")
    }
}
