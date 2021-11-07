extension CPU6502 {
    func execJMP(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        var val : UInt16 = 0
        switch addrMode {
        case .absolute:
            val = readWord(memory, address: PC, cycle: &cycle)
            break
        case .indirect:
            let indirectAddr = readWord(memory, address: PC, cycle: &cycle)
            if flags.contains(.useOriginalIncorrectIndirectJMP) && (indirectAddr & 0xFF) == 0xFF {
                let low = readByte(memory, address: indirectAddr, cycle: &cycle)
                let high = readByte(memory, address: (indirectAddr & 0xFF00), cycle: &cycle)
                val = (UInt16(high) << 8) | UInt16(low)
            } else {
                val = readWord(memory, address: indirectAddr, cycle: &cycle)
            }
            break
        default:
            throw EmulateError.invalidAddrMode
        }
        PC = val
    }
}
