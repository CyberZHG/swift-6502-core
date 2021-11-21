extension CPU6502 {
    func execAND(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        A &= readByte(memory, address: address, cycle: &cycle)
        updateStatusNZFromConst(A)
    }
    
    func execORA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        A |= readByte(memory, address: address, cycle: &cycle)
        updateStatusNZFromConst(A)
    }
    
    func execEOR(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        A ^= readByte(memory, address: address, cycle: &cycle)
        updateStatusNZFromConst(A)
    }
    
    func execBIT(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        let result = A & readByte(memory, address: address, cycle: &cycle)
        Z = result == 0
        V = (result & 0b01000000) > 0
        N = (result & 0b10000000) > 0
    }
}
