import Foundation

enum Route: Hashable {
    case launch
    case home
    case content(Mood)
    case meditationSetup(Mood)
    case meditation(duration: Int, mood: Mood, music: String)
    case journalEditor(entry: JournalEntry?)
    case stats
    case settings
    case profile
}
