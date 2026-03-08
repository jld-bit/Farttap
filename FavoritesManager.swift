import Foundation

final class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published private(set) var favorites: Set<String> = []

    private let storageKey = "favoriteFartNames"

    private init() {
        load()
    }

    func isFavorite(_ sound: FartSound) -> Bool {
        favorites.contains(sound.name)
    }

    func toggle(_ sound: FartSound) {
        if favorites.contains(sound.name) {
            favorites.remove(sound.name)
        } else {
            favorites.insert(sound.name)
        }
        save()
    }

    private func load() {
        let saved = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        favorites = Set(saved)
    }

    private func save() {
        UserDefaults.standard.set(Array(favorites), forKey: storageKey)
    }
}
