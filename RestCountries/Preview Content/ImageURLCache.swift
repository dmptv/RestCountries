//
//  ImageURLCache.swift
//  RestCountries
//
//  Created by Kanat on 09.03.2025.
//

import UIKit
import SwiftUI

class ImageURLCache {
    static let shared = ImageURLCache()

    private var cache: [String: URL] = [:]

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(cleanup), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func getURLString(forImageName name: String) -> String {
        if let url = cache[name] {
            return url.absoluteString
        }

        guard let image = UIImage(named: name), let data = image.pngData() else {
            print("Image not found or could not get data from image")
            return "image not found"
        }

        let tempFileURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("\(name).png")

        do {
            try data.write(to: tempFileURL)
            cache[name] = tempFileURL
            return tempFileURL.absoluteString
        } catch {
            print("Error writing to temporary file: \(error)")
            return "image not found"
        }
    }

    @objc
    private func cleanup() {
        for url in cache.values {
            try? FileManager.default.removeItem(at: url)
        }
        cache = [:]
    }
}
