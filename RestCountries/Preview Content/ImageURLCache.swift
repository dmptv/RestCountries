//
//  ImageURLCache.swift
//  RestCountries
//
//  Created by Kanat on 09.03.2025.
//

import UIKit
import SwiftUI

actor ImageURLCache {
    static let shared = ImageURLCache()

    private var cache: [String: URL] = [:]

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(cleanup), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func getURLString(forImageName name: String) async -> String? {
        if let url = cache[name] {
            return url.absoluteString
        }

        guard let image = UIImage(named: name), let data = image.pngData() else {
            print("Image not found or could not get data from image")
            return nil
        }

        let tempFileURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("\(name).png")
        
        do {
            try data.write(to: tempFileURL)
            cache[name] = tempFileURL
            return tempFileURL.absoluteString
        } catch {
            return nil
        }
    }

    @objc
    func cleanup() async {
        await withTaskGroup(of: Void.self) { group in
            for url in cache.values {
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    print("Error removing file: \(error)")
                }
            }
            await group.waitForAll()
        }
        cache = [:]
    }
}
