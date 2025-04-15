//
//  ImageCache.swift
//  Recipe iOS App
//
//  Created by Samuel Folledo on 4/14/25.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    init() {
        cacheDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                  in: .userDomainMask).first!
            .appendingPathComponent("CachedImages")
        createCacheDirectory()
    }

    func image(for key: String, remoteURL: URL) async -> UIImage? {
        // Memory cache check
        if let cached = memoryCache.object(forKey: key as NSString) {
            return cached
        }

        // Disk cache check
        if let diskImage = loadFromDisk(key: key) {
            memoryCache.setObject(diskImage, forKey: key as NSString)
            return diskImage
        }

        // Network fetch
        do {
            let (data, _) = try await URLSession.shared.data(from: remoteURL)
            guard let image = UIImage(data: data) else { return nil }

            memoryCache.setObject(image, forKey: key as NSString)
            saveToDisk(image: image, key: key)

            return image
        } catch {
            return nil
        }
    }

    private func loadFromDisk(key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }

    private func saveToDisk(image: UIImage, key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        DispatchQueue.global(qos: .utility).async {
            if let data = image.pngData() {
                try? data.write(to: fileURL)
            }
        }
    }

    private func createCacheDirectory() {
        guard !fileManager.fileExists(atPath: cacheDirectory.path) else { return }
        try? fileManager.createDirectory(at: cacheDirectory,
                                         withIntermediateDirectories: true)
    }

    func clearCache(for key: String) {
        memoryCache.removeObject(forKey: key as NSString)
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? fileManager.removeItem(at: fileURL)
    }
}
