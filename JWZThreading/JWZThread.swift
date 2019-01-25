//
//  JWZThread.swift
//  JWZThreading
//
//  Created by Matej Dorcak on 25/01/2019.
//  Copyright © 2019 Matej Dorcak. All rights reserved.
//

import Foundation

public class JWZThread {
    private init() {}
    
    public class func thread<M>(from messages: [JWZMessage<M>]) -> [JWZContainer<M>] {
        // MARK: #3
        return idTable(from: messages).reduce(into: [JWZContainer](), { (containers: inout [JWZContainer], dictElement) in
            // MARK: #2
            if dictElement.value.parent == nil {
                // MARK: #4
                containers.append(contentsOf: pruneEmptyContainers(dictElement.value))
            }
        })
    }
    
    fileprivate class func idTable<M>(from messages: [JWZMessage<M>]) -> [String: JWZContainer<M>] {
        var idTable = [String: JWZContainer<M>]()
        
        for message in messages {
            // MARK: #1A
            let parentContainer = idTable[message.id] ?? JWZContainer<M>(message: message)
            
            if idTable[message.id] == nil {
                idTable[message.id] = parentContainer
            }
            else if parentContainer.message == nil {
                parentContainer.message = message
            }
            
            // MARK: #1B
            var previousReference: JWZContainer<M>?
            
            for messageID in message.references {
                if idTable[messageID] == nil {
                    idTable[messageID] = JWZContainer(message: nil)
                }
                
                let container = idTable[messageID]!
                
                if let previousReference = previousReference {
                    if container.parent == nil && !container.hasDescendant(previousReference) {
                        previousReference.addChild(container)
                    }
                }
                
                previousReference = container
            }
            
            // MARK: #1C
            if let lastReference = previousReference {
                if !parentContainer.hasDescendant(lastReference) {
                    lastReference.addChild(parentContainer)
                }
            }
        }
        
        return idTable
    }
    
    fileprivate class func pruneEmptyContainers<M>(_ parentContainer: JWZContainer<M>) -> [JWZContainer<M>] {
        var prunedContainers = [JWZContainer<M>]()
        
        for container in parentContainer.children {
            prunedContainers.append(contentsOf: pruneEmptyContainers(container))
            parentContainer.removeChild(container)
        }
        
        for container in prunedContainers {
            parentContainer.addChild(container)
        }
        
        // MARK: #4A
        if parentContainer.message == nil && parentContainer.children.isEmpty {
            return []
        }
        
        // MARK: #4B
        if parentContainer.message == nil && (parentContainer.children.count == 1 || parentContainer.parent != nil) {
            let children = parentContainer.children
            
            for container in parentContainer.children {
                parentContainer.removeChild(container)
            }
            
            return children
        }
        
        return [parentContainer]
    }
}
