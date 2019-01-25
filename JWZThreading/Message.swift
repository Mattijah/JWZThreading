//
//  JWZMessage.swift
//  JWZThreading
//
//  Created by S on 25/01/2019.
//  Copyright © 2019 Matej Dorcak. All rights reserved.
//

import Foundation

public class JWZMessage<M> {
    public let id: String
    public let message: M?
    public let references: [String]
    
    public init(id: String, message: M? = nil, inReplyTo: [String], references: [String]) {
        self.id = id
        self.message = message
        self.references = (references.isEmpty && !inReplyTo.isEmpty) ? [inReplyTo.first!] : references
    }
}
