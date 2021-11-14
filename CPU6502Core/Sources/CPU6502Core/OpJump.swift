extension CPU6502 {
    func execJMP(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        PC = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
    }
}
