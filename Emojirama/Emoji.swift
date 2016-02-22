import SwiftyJSON

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
    
    init?(json:JSON) {
        self.id = json["id"].string ?? ""
        self.value = json["value"].string ?? ""
        self.description  = json["description"].string ?? ""
        self.code = json["code"].string ?? ""
        self.version = json["version"].string ?? ""
        self.type = json["type"].string ?? ""
        self.tags = [String]()
        self.hasSkinTone = json["hasSkinTone"].boolValue ?? false
        
        if let tags = json["tags"].array {
            for tag in tags {
                
                self.tags.append(tag.string ?? "")
            }
        }
        
        
    }
    
}