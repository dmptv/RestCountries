//
//  ImageURLCache.swift
//  RestCountries
//
//  Created by Kanat on 09.03.2025.
//

import UIKit
import SwiftUI

@MainActor
final class ImageURLCache {
    static let shared = ImageURLCache()

    private var cache: [String: URL] = [:]

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(cleanup), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func getURLString(forImageName name: String) async -> String? {
        let result = "image not found"
        if let url = cache[name] {
            return url.absoluteString
        }

        guard let image = UIImage(named: name), let data = image.pngData() else {
            print("Image not found or could not get data from image")
            return result
        }

        let tempFileURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("\(name).png")

        return await Task.detached {
            let tempFileURL = FileManager.default
                .temporaryDirectory
                .appendingPathComponent("\(name).png")
            do {
                try data.write(to: tempFileURL)
                await MainActor.run {
                    self.cache[name] = tempFileURL
                }
                return tempFileURL.absoluteString
            } catch {
                print("Error writing to temporary file: \(error)")
                return "image not found"
            }
        }.value
    }

    @objc func cleanup() async {
        for url in cache.values {
            try? FileManager.default.removeItem(at: url)
        }
        cache = [:]
    }
}
