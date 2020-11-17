import SwiftUI
import SwiftSoup

struct TopicsView: View {
    
    @State private var topics = [Topic]()
    @State private var currentlyFetchingArticles: Bool = true
    
    private let topicService: TopicService = TopicService()

    private let navigationBarStyle: NavigationBarStyle = NavigationBarStyle()
    private let tabBarStyle: TabBarStyle = TabBarStyle()

    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.systemFont(
                ofSize: CGFloat(navigationBarStyle.headerSize),
                weight: UIFont.Weight.semibold
            )
        ]
    }
        
    var body: some View {
        VStack(alignment: .leading) {
            NavigationView() {
                List(topics) { (topic: Topic) in
                    ZStack {
                        TopicsItemView(
                            topic: topic
                        ).onAppear {
                            if self.currentlyFetchingArticles {
                                return
                            }
                            
                            guard let lastTopic = topics.last else {
                                return
                            }
                            
                            if topic.id != lastTopic.id {
                                return
                            }
                            
                            self.topicService.getNext { result in
                                topics.append(contentsOf: result)
                            }
                        }
                    }
                }.navigationBarTitle(
                    tabBarStyle.topicsTabNameUkrainian,
                    displayMode: .inline
                )
            }
        }.onAppear {
            self.topicService.get { result in
                topics.append(contentsOf: result)
            }
            
            self.currentlyFetchingArticles = false
        }
    }
}
