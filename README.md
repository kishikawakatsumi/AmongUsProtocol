# Among Us Protocol

```swift
import AmongUsProtocol

guard let packet = PacketParser.parse(packet: data) else {
    return
}

switch packet {
case .normal(let normal):
    print("\(normal)")
case .reliable(let reliable):
    print("\(reliable)")
case .hello(let hello):
    print("\(hello)")
case .disconnect:
    print("Disconnected")
case .acknowledgement, .fragment, .ping:
    break
}

```
