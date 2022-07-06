//
//  DatasetDownloadManager.swift
//  Stationmaster
//
//  Created by Nitanta Adhikari on 05/07/2022.
//

import Foundation
import ZIPFoundation
import os.log

class DatasetDownloadManager: LoggableManager {
    let fileName = "TrafficDataset"
    let cacheName = "DownloadCache"
    let flightPlanURL = URL(string: Global.baseURL + "/gtfs/\(Global.operatorr)/\(Global.operatorr).zip?key=\(Global.staticAPIKey)")!


    lazy var cache: URLCache = {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let diskCacheURL = cachesURL.appendingPathComponent(cacheName) //1GB
        let cache = URLCache(memoryCapacity: 100_000_000, diskCapacity: 1_000_000_000, directory: diskCacheURL)
        logger.info("Cache path: \(diskCacheURL.path)")
        return cache
    }()

    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        return URLSession(configuration: config)
    }()
    
    override init() {
        super.init()
    }
    
    func startDownload(completion: ((Result<URL, Error>) -> ())? = nil) {
        downloadFile(remoteURL: flightPlanURL, completion: completion)
    }

    private func downloadFile(remoteURL: URL, completion: ((Result<URL, Error>) -> ())?) {
        let request = URLRequest(url: remoteURL)
        let downloadTask = session.downloadTask(with: request) { url, response, error in

            if let error = error {
                completion?(.failure(error))
                return
            }

            if let response = response, let url = url, self.cache.cachedResponse(for: request) == nil, let data = try? Data(contentsOf: url, options: [.mappedIfSafe]) {
                self.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
            }

            guard let tempURL = url else { return }
            //_ = try? FileManager.default.replaceItemAt(targetURL, withItemAt: tempURL)
            guard let targetURL = self.save(tempURL: tempURL) else { return }
            self.logger.info("Dataset Donwload \(targetURL)")
            completion?(.success(targetURL))
        }
        downloadTask.resume()
        
    }
    
    private func save(tempURL: URL) -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let documentsDirectory = paths.first, let documentURL = URL(string: documentsDirectory) else { return nil }
        let zipPath = documentURL.appendingPathComponent(self.fileName + ".zip")
        let dataPath = documentURL
        do {
            if let finalURL = try FileManager.default.replaceItemAt(zipPath, withItemAt: tempURL) {
                try FileManager.default.unzipItem(at: zipPath, to: dataPath)
                return dataPath
            }
        } catch {
            logger.info("\(error.localizedDescription)")
        }
        
        return nil
    }
    
}
