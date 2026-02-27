//
//  CacheService.swift
//  SurveyApp
//
//  Created by Nettem Taraka Ram Teja on 23/02/26.
//

import Foundation
import QueueKit

// A service responsible for managing the in-memory caching of surveys.
// It uses a custom Queue data structure to store surveys temporarily before persistence.
class CacheService {
    private var queue = Queue<Survey>()
    
    // Adds a survey to the in-memory queue.
    func enqueue(_ survey: Survey) {
        queue.add(survey)
    }
    
    // Removes and returns all surveys currently in the queue.
    // Used when flushing data to the persistent storage.
    func dequeueAll() -> [Survey] {
        var items: [Survey] = []
        while let item = queue.remove() {
            items.append(item)
        }
        return items
    }
    
    // Returns the number of items currently in the cache.
    var count: Int { queue.size }
    
    // Returns true if the cache is empty.
    var isEmpty: Bool { queue.isEmpty }
}
