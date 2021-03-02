import Foundation

func gameIdToCode(gameId: Int32) -> String {
    let charSet = "QWXRTYLPESDFGHUJKZOCVBINMA".map { $0 }
    if gameId < -1 { // v2
        let firstTwo = Int(gameId & 0x3FF)
        let lastFour = Int((gameId >> 10) & 0xFFFFF)
        var a = lastFour
        a /= 26
        var b = a
        b /= 26
        return [
            charSet[firstTwo % 26],
            charSet[firstTwo / 26],
            charSet[lastFour % 26],
            charSet[a % 26],
            charSet[b % 26],
            charSet[b / 26 % 26],
        ]
        .map { String($0) }
        .joined()
    } else { // v1
        return "\(gameId)"
    }
}

func decodeClientVersion(_ version: Int32) -> String {
    let year = floor(Double(version) / 25000)
    var m = version
    m %= 25000
    let month = floor(Double(m) / 1800)
    m %= 1800
    let day = floor(Double(m) / 50)
    let revision = m % 50
    return "\(Int(year)).\(Int(month)).\(Int(day)).\(revision)"
}

func decimalToIpAddress(_ decimal: UInt32) -> String {
    var ip = ""
    var delimiter = ""
    var decimal = decimal
    for e in (0...3).reversed() {
        let octet = decimal / UInt32(pow(Double(256), Double(e)))
        decimal -= octet * UInt32(pow(Double(256), Double(e)))
        ip = "\(octet)\(delimiter)\(ip)"
        delimiter = "."
    }
    return ip
}
