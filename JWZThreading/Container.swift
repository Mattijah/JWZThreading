//
//  JWZContainer.swift
//  JWZThreading
//
//  Created by Matej Dorcak on 25/01/2019.
//  Copyright © 2019 Matej Dorcak. All rights reserved.
//

import Foundation

public class JWZContainer<M>: NSObject {
    public internal(set) var message: JWZMessage<M>?
    public internal(set) var parent: JWZContainer?
    public private(set) var children = [JWZContainer]()
    
    init(message: JWZMessage<M>?) {
        self.message = message
    }
    
    func hasDescendant(_ child: JWZContainer) -> Bool {
        if self == child {
            return true
        }
        
        for child in children {
            if child.hasDescendant(child) {
                return true
            }
        }
        
        return false
    }
    
    func removeChild(_ child: JWZContainer) {
        if let index = children.index(of: child) {
            children.remove(at: index)
        }
        
        child.parent = nil
    }
    
    func addChild(_ child: JWZContainer) {
        child.parent?.removeChild(child)
        children.append(child)
        child.parent = self
    }
}
