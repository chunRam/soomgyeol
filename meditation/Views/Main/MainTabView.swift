import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home

    enum Tab {
        case home, journal, stats, profile
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTabView()
                .tag(Tab.home)
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }

            HistoryTabView()
                .tag(Tab.journal)
                .tabItem {
                    Label("일지", systemImage: "book.closed.fill")
                }

            StatsTabView()
                .tag(Tab.stats)
                .tabItem {
                    Label("통계", systemImage: "chart.bar.fill")
                }

            ProfileTabView()
                .tag(Tab.profile)
                .tabItem {
                    Label("프로필", systemImage: "person.crop.circle")
                }
        }
        .accentColor(Color("DarkPurple")) // 강조 색상
    }
}
