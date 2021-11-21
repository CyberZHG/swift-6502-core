extension CPU6502 {
    func execINC(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        var M = readByte(memory, address: address, cycle: &cycle)
        M = M &+ 1
        cycle += 1
        updateStatusNZFromConst(M)
        writeByte(memory, address: address, value: M, cycle: &cycle)
    }
    
    func execDEC(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        var M = readByte(memory, address: address, cycle: &cycle)
        M = M &- 1
        cycle += 1
        updateStatusNZFromConst(M)
        writeByte(memory, address: address, value: M, cycle: &cycle)
    }
    
    func execINX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        X = X &+ 1
        cycle += 1
        updateStatusNZFromConst(X)
    }
    
    func execDEX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        X = X &- 1
        cycle += 1
        updateStatusNZFromConst(X)
    }
    
    func execINY(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        Y = Y &+ 1
        cycle += 1
        updateStatusNZFromConst(Y)
    }
    
    func execDEY(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        Y = Y &- 1
        cycle += 1
        updateStatusNZFromConst(Y)
    }
}
