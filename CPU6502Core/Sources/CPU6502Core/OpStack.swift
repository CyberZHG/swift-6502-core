extension CPU6502 {
    func execTXS(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        pushByte(memory, value: X, cycle: &cycle)
    }
    
    func execTSX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        X = popByte(memory, cycle: &cycle)
    }
}
