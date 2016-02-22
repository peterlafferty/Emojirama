import UIKit

private let reuseIdentifier = "Cell"

struct Emoji {
    let id: String
    let value: String
    let description: String
    let code: String
    let version: String
    let type: String
    var tags: [String]
    let hasSkinTone: Bool
    
    init?(_ data:NSDictionary) {
        
        guard let id = data["id"] as? Int else {
            return nil
        }
        self.id = String(id)
        
        guard let value = data["value"] as? String else {
            return nil
        }
        self.value = value

        guard let description = data["description"] as? String else {
            return nil
        }
        self.description = description

        guard let code = data["code"] as? String else {
            return nil
        }
        self.code = code
        
        guard let version = data["version"] as? String else {
            return nil
        }
        self.version = version
        
        guard let type = data["type"] as? String else {
            return nil
        }
        self.type = type
     
        guard let hasSkinTone = data["hasSkinTone"] as? Bool else {
            return nil
        }
        self.hasSkinTone = hasSkinTone
        
        self.tags = [String]()
        
        if let tags = data["tags"] as? [String] {
            for tag in tags {
                if !tag.isEmpty {
                    self.tags.append(tag)
                }
            }
        }
    }
    
}