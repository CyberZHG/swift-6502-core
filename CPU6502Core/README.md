# CPU6502Core

Emulation of the 6502 CPU.

```swift
import CPU6502Core

var cpu = CPU6502()
var memory = PlainMemory()

memory.setBytes(start: 0x8000, bytes: [0xA9, 0x0A])  // LDA #10
cpu.PC = 0x8000
let actualCycle = try self.cpu.execute(memory, maxCycle: 2)
// `actualCycle` will be 2
// `cpu.PC` will be 0x8002
// `cpu.A` will be 0x0A
```
