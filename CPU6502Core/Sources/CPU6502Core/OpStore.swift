extension CPU6502 {
    func execSTA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        writeByte(memory, address: address, value: A, cycle: &cycle)
    }
    
    func execSTX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        writeByte(memory, address: address, value: X, cycle: &cycle)
    }
    
    func execSTY(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        writeByte(memory, address: address, value: Y, cycle: &cycle)
    }
}