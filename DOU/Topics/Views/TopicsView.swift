import SwiftUI
import SwiftSoup

struct TopicsView: View {
    
    let topicsService: TopicsService
    let initialTopics: [Topic]
    
    @State private var topics = [Topic]()
    @State private var currentlyFetchingArticles: Bool = true
    
    private let style = Style()

    init(topicsService: TopicsService, initialTopics: [Topic]) {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.systemFont(
                ofSize: style.navigationBarHeaderSize,
                weight: UIFont.Weight.semibold
            )
        ]
        
        self.topicsService = topicsService
        self.initialTopics = initialTopics
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
                            
                            self.topicsService.getNext { result in
                                topics.append(contentsOf: result)
                            }
                        }
                    }
                }.navigationBarTitle(
                    style.navigationBarHeaderNameUkrainian,
                    displayMode: .inline
                )
            }
        }.onAppear {
            self.topics.append(contentsOf: initialTopics)
            self.currentlyFetchingArticles = false
        }
    }
    
    struct Style {
        let navigationBarHeaderSize: CGFloat = 20
        let navigationBarHeaderNameUkrainian: String = "Форум"
        let navigationBarHeaderNameRussian: String = "Форум"
    }
}
