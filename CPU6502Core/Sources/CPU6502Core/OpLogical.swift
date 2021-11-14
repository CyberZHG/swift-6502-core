extension CPU6502 {
    func execAND(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        A &= readByte(memory, address: address, cycle: &cycle)
        updateStatusFromConst(A)
    }
    
    func execORA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        A |= readByte(memory, address: address, cycle: &cycle)
        updateStatusFromConst(A)
    }
    
    func execEOR(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        A ^= readByte(memory, address: address, cycle: &cycle)
        updateStatusFromConst(A)
    }
}
