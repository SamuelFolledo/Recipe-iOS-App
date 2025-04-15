//
//  DataCache.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import Foundation

actor DataCache<T: Codable> {
    private let cacheDirectory: URL
    private let fileManager = FileManager.default

    init(directoryName: String) {
        let base = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = base.appendingPathComponent(directoryName)
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    func save(_ value: T, forKey key: String) async {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = value as? Data {
            try? data.write(to: fileURL)
        } else {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(value) {
                try? data.write(to: fileURL)
            }
        }
    }

    func load(forKey key: String) async -> T? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        if T.self == Data.self, let data = try? Data(contentsOf: fileURL) {
            return data as? T
        } else if let data = try? Data(contentsOf: fileURL) {
            let decoder = JSONDecoder()
            return try? decoder.decode(T.self, from: data)
        }
        return nil
    }

    func clear(forKey key: String) async {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? fileManager.removeItem(at: fileURL)
    }
}
