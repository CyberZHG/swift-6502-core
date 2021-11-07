extension CPU6502 {
    func execJMP(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        var val : UInt16 = 0
        switch addrMode {
        case .ABSOLUTE:
            val = readWord(memory, address: PC, cycle: &cycle)
            break
        case .INDIRECT:
            let indirectAddr = readWord(memory, address: PC, cycle: &cycle)
            val = readWord(memory, address: indirectAddr, cycle: &cycle)
            break
        default:
            throw EmulateError.invalidAddrMode
        }
        PC = val
    }
}
