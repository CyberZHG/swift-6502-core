extension CPU6502 {
    func execJMP(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        PC = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
    }
    
    func execJSR(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let addr = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        pushWord(memory, value: PC - 1, cycle: &cycle)
        cycle += 1
        PC = addr
    }
    
    func execRTS(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        PC = popWord(memory, cycle: &cycle) + 1
        cycle += 3
    }
}
