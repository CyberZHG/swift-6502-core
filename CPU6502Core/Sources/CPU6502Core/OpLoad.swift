extension CPU6502 {
    func execLDA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        A = readByte(memory, address: address, cycle: &cycle)
        updateStatusFromConst(A)
    }
    
    func execLDX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        X = readByte(memory, address: address, cycle: &cycle)
        updateStatusFromConst(X)
    }
    
    func execLDY(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        Y = readByte(memory, address: address, cycle: &cycle)
        updateStatusFromConst(Y)
    }
}
