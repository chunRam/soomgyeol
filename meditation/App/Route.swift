import Foundation

enum Route: Hashable {
    case launch
    case login
    case signup
    case home
    case content(Mood)
    case meditationSetup(Mood)
    case meditation(duration: Int, mood: Mood, music: String)
    case meditationSummary(duration: Int, mood: Mood)
    case journalEditor(entry: JournalEntry?)
    case stats
    case settings
    case profile
}
