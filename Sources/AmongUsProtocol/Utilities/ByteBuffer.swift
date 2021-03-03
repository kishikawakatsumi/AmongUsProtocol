import Foundation

public class ByteBuffer {
    public let data: Data
    private var offset = 0

    public var availableBytes: Int { data.count - offset }

    public init(_ data: Data) {
        self.data = data
    }

    public func read<T>(_ type: T.Type) -> T {
        let size = MemoryLayout<T>.size
        let value = data[offset..<(offset + size)].to(type: type)
        offset += size
        return value
    }

    public func read<T>(_ type: T.Type, default defaultValue: T) -> T {
        let size = MemoryLayout<T>.size
        guard size <= availableBytes else { return defaultValue }
        let value = data[offset..<(offset + size)].to(type: type)
        offset += size
        return value
    }

    public func read(_ type: Data.Type, count: Int) -> Data {
        let value = data[offset..<(offset + count)]
        offset += count
        return Data(value)
    }

    public func read(_ type: String.Type) -> String {
        let count = Int(read(UInt8.self))
        let value = data[offset..<(offset + count)]
        offset += count
        return String(data: value, encoding: .utf8) ?? String(repeating: "?", count: count)
    }

    public func readPackedInt32() -> Int32 {
        Int32(truncatingIfNeeded: readPackedUInt32())
    }

    public func readPackedUInt32() -> UInt32 {
        var readMore = true
        var shift = 0
        var output: UInt32 = 0

        while readMore {
            guard availableBytes > 0 else { return output }

            var b = read(UInt8.self)
            if b >= 0x80 {
                readMore = true
                b ^= 0x80
            } else {
                readMore = false
            }

            output |= (UInt32(b) << shift)
            shift += 7
        }

        return output
    }
}
