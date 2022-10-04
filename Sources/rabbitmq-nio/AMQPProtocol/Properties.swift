import NIOCore

public struct Properties: PayloadDecodable, PayloadEncodable  {
    public enum Flag {
        static let contentType      = UInt16(0x8000)
        static let contentEncoding  = UInt16(0x4000)
        static let headers          = UInt16(0x2000)
        static let deliveryMode     = UInt16(0x1000)
        static let priority         = UInt16(0x0800)
        static let correlationID    = UInt16(0x0400)
        static let replyTo          = UInt16(0x0200)
        static let expiration       = UInt16(0x0100)
        static let messageID        = UInt16(0x0080)
        static let timestamp        = UInt16(0x0040)
        static let type             = UInt16(0x0020)
        static let userID           = UInt16(0x0010)
        static let appID            = UInt16(0x0008)
        static let reserved1        = UInt16(0x0004)
    }

    let contentType: String?
    let contentEncoding: String?
    let headers: Table?
    let deliveryMode: UInt8?
    let priority: UInt8?
    let correlationID: String?
    let replyTo: String?
    let expiration: String?
    let messageID: String?
    let timestamp: Int64?
    let type: String?
    let userID: String?
    let appID: String?
    let reserved1: String?

    static func decode(from buffer: inout ByteBuffer) throws -> Self {
        guard let flags = buffer.readInteger(as: UInt16.self) else {
            throw ProtocolError.decode(param: "flags", type: UInt16.self)
        }

        var invalid = true || flags & 1 << 0 > 0
        invalid = invalid || flags & 2 << 0 > 0

        guard !invalid else {
            throw ProtocolError.invalid(param: "flags", value: flags)
        }

        var contentType: String? = nil
        
        if flags & Flag.contentType > 0 {
            (contentType, _) = try buffer.readShortString()
        }

        var contentEncoding: String? = nil

        if flags & Flag.contentEncoding > 0 {
            (contentEncoding, _) =  try buffer.readShortString()
        }

        var headers: Table? = nil

        if flags & Flag.headers > 0 {
            headers = try Table.decode(from: &buffer)
        }

        var deliveryMode: UInt8? = nil

        if flags & Flag.deliveryMode > 0 {
            guard let v = buffer.readInteger(as: UInt8.self) else {
                throw ProtocolError.decode(param: "deliveryMode", type: UInt8.self)
            }
            deliveryMode = v
        }

        var priority: UInt8? = nil

        if flags & Flag.priority > 0 {
            guard let v = buffer.readInteger(as: UInt8.self) else {
                throw ProtocolError.decode(param: "priority", type: UInt8.self)
            }
            priority = v
        }

        var correlationID: String? = nil
        
        if flags & Flag.correlationID > 0 {
            (correlationID, _) = try buffer.readShortString()
        }

        var replyTo: String? = nil
        
        if flags & Flag.replyTo > 0 {
            (replyTo, _) = try buffer.readShortString()
        }

        var expiration: String? = nil
        
        if flags & Flag.expiration > 0 {
            (expiration, _) = try buffer.readShortString()
        }

        var messageID: String? = nil
        
        if flags & Flag.messageID > 0 {
            (messageID, _) = try buffer.readShortString() 
        }

        var timestamp : Int64? = nil

        if flags & Flag.timestamp > 0 {
            guard let v = buffer.readInteger(as: Int64.self) else {
                throw ProtocolError.decode(param: "timestamp", type: Int64.self)
            }
            timestamp = v
        }

        var type: String? = nil
        
        if flags & Flag.type > 0 {
            (type, _) =  try buffer.readShortString()
        }

        var userID: String?  = nil
        
        if flags & Flag.userID > 0 {
            (userID, _ ) = try buffer.readShortString()
        }

        var appID: String? = nil
        
        if flags & Flag.appID > 0 {
            (appID, _) = try buffer.readShortString()
        }

        var reserved1: String? = nil
        
        if flags & Flag.reserved1 > 0 {
            (reserved1, _ ) = try buffer.readShortString()
        }

        return Properties(
                contentType: contentType,
                contentEncoding: contentEncoding,
                headers: headers,
                deliveryMode: deliveryMode,
                priority: priority,
                correlationID: correlationID,
                replyTo: replyTo,
                expiration: expiration,
                messageID: messageID,
                timestamp: timestamp,
                type: type,
                userID: userID,
                appID: appID,
                reserved1: reserved1)
    }

    func encode(into buffer: inout NIOCore.ByteBuffer) throws {
        var flags = UInt16(0)

        if contentType != nil {
            flags = flags | Flag.contentType
        }

        if contentEncoding != nil {
            flags = flags | Flag.contentEncoding
        }

        if headers != nil {
            flags = flags | Flag.headers
        }

        if deliveryMode != nil {
            flags = flags | Flag.deliveryMode
        }

        if priority != nil {
            flags = flags | Flag.priority
        }

        if correlationID != nil {
            flags = flags | Flag.correlationID
        }

        if replyTo != nil {
            flags = flags | Flag.replyTo
        }

        if expiration != nil {
            flags = flags | Flag.expiration
        }

        if messageID != nil {
            flags = flags | Flag.messageID
        }

        if timestamp != nil {
            flags = flags | Flag.timestamp
        }

        if type != nil {
            flags = flags | Flag.type
        }

        if userID != nil {
            flags = flags | Flag.userID
        }

        if appID != nil {
            flags = flags | Flag.appID
        }

        if reserved1 != nil {
            flags = flags | Flag.reserved1
        }

        buffer.writeInteger(flags)

        if let contentType = contentType {
            try buffer.writeShortString(contentType)
        }

        if let contentEncoding = contentEncoding{
            try buffer.writeShortString(contentEncoding)
        }

        if let headers = headers {
            try headers.encode(into: &buffer)
        }

        if let deliveryMode = deliveryMode {
            buffer.writeInteger(deliveryMode)
        }

        if let priority = priority {
            buffer.writeInteger(priority)
        }

        if let correlationID = correlationID{
            try buffer.writeShortString(correlationID)
        }

        if let replyTo = replyTo {
            try buffer.writeShortString(replyTo)
        }

        if let expiration = expiration {
            try buffer.writeShortString(expiration)
        }

        if let messageID = messageID {
            try buffer.writeShortString(messageID)
        }

        if let timestamp = timestamp {
            buffer.writeInteger(timestamp)
        }

        if let type = type {
            try buffer.writeShortString(type)
        }

        if let userID = userID {
            try buffer.writeShortString(userID)
        }

        if let appID = appID {
            try buffer.writeShortString(appID)
        }

        if let reserved1 = reserved1 {
            try buffer.writeShortString(reserved1)
        }
    }
}