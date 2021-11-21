extension CPU6502 {
    func execNOP(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        cycle += 1
        if addrMode != .implied {
            let _ = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        }
    }
    
    func execBRK(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        PC += 1
        pushWord(memory, value: PC, cycle: &cycle)
        pushByte(memory, value: P, cycle: &cycle)
        cycle += 1
        PC = readWord(memory, address: 0xFFFE, cycle: &cycle)
    }
    
    func execRTI(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        P = popByte(memory, cycle: &cycle)
        PC = popWord(memory, cycle: &cycle)
        cycle += 2
    }
    
    func execJAM(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        cycle += 1
        halt = true
    }
}
