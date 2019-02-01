//
//  CacheCleaner.swift
//  Eda
//
//  Created by Шпинев Виталий Васильевич on 16/01/2019.
//  Copyright © 2019 Шпинев Виталий Васильевич. All rights reserved.
//

import SDWebImage
import Kingfisher
import Nuke

class CacheCleaner {
    
    static func clearAllCaches() {
        cleanSdCache()
        cleanNukeCache()
        cleanKingfisherCache()
    }
    
    private static func cleanSdCache() {
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk {}
    }
    
    private static func cleanNukeCache() {
        ImageCache.shared.removeAll()
        DataLoader.sharedUrlCache.removeAllCachedResponses()
    }
    
    private static func cleanKingfisherCache() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache {}
    }
}
