[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Git](https://img.shields.io/badge/GitHub-Mattijah-blue.svg?style=flat)](https://github.com/Mattijah)


# JWZThreading

Implementation of the JWZ algorithm for threading email
messages as described by Jamie Zawinski at http://www.jwz.org/doc/threading.html.


## Usage

```swift
import JWZThreading

// Create an array of messages
let messages = downloadedMessages.map({
    JWZMessage(id: $0.header.messageID, message: $0, inReplyTo: $0.header.inReplyTo, references: $0.header.references)
})

// Call `thread(from:)` with a list of messages
let threads = JWZThread.thread(from: messages)

// Output the result
for container in threads {
    print(container.message?.id, container.children.count)
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
