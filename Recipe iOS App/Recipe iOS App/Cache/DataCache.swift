//
//  DataCache.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import Foundation

actor DataCache<T: Codable> {
    private let cacheFile: URL
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init(filename: String) {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                      in: .userDomainMask).first!
        cacheFile = cacheDirectory.appendingPathComponent(filename)
    }

    func save(_ data: T) async {
        do {
            let data = try encoder.encode(data)
            try data.write(to: cacheFile)
        } catch {
            print("Error saving cache: \(error)")
        }
    }

    func load() async -> T? {
        guard FileManager.default.fileExists(atPath: cacheFile.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: cacheFile)
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error loading cache: \(error)")
            return nil
        }
    }

    func clear() async {
        try? FileManager.default.removeItem(at: cacheFile)
    }
}
