extension CPU6502 {
    func execNOP(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        cycle += 1
    }
    
    func execBRK(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        PC += 1
        pushWord(memory, value: PC, cycle: &cycle)
        pushByte(memory, value: P, cycle: &cycle)
        cycle += 1
        PC = readWord(memory, address: 0xFFFE, cycle: &cycle)
        I = true
    }
}
