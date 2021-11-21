extension CPU6502 {
    func execLDA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        A = readByte(memory, address: address, cycle: &cycle)
        updateStatusNZFromConst(A)
    }
    
    func execLDX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        X = readByte(memory, address: address, cycle: &cycle)
        updateStatusNZFromConst(X)
    }
    
    func execLDY(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        Y = readByte(memory, address: address, cycle: &cycle)
        updateStatusNZFromConst(Y)
    }
    
    func execLAS(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        let M = readByte(memory, address: address, cycle: &cycle)
        A = M & SP
        X = A
        SP = A
        updateStatusNZFromConst(A)
    }
}
