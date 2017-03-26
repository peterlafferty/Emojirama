public struct Emoji {
    public var id: String = ""
    public var value: String = ""
    public var text: String = ""
    public var code: String = ""
    public var version: String = ""
    public var type: String = ""
    public var tags: [String] = [String]()
    public var hasSkinTone: Bool  = false
    public var tones: [String] = [String]()

    public init() {

    }

    public init?(_ data: NSDictionary) {

        guard let id = data["id"] as? Int else {
            return nil
        }
        self.id = String(id)

        guard let value = data["value"] as? String else {
            return nil
        }
        self.value = value

        guard let text = data["description"] as? String else {
            return nil
        }
        self.text = text

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

        initTags(data)
        initTones(data)
    }

    private mutating func initTones(_ data: NSDictionary) {
        if hasSkinTone {
            self.tones.append(value)
            if let tones = data["tones"] as? [String] {
                for tone in tones {
                    self.tones.append(tone)
                }
            }
        }
    }

    private mutating func initTags(_ data: NSDictionary) {
        if let tags = data["tags"] as? [String] {
            for tag in tags {
                if !tag.isEmpty {
                    self.tags.append(tag)
                }
            }
        }
    }

}
