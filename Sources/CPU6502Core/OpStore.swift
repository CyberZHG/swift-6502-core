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
    
    func execSAX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        writeByte(memory, address: address, value: A & X, cycle: &cycle)
    }
    
    func execSHA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        var dummyCycle = 0
        let V = readByte(memory, address: PC - 1, cycle: &dummyCycle)
        writeByte(memory, address: address, value: A & X & (V &+ 1), cycle: &cycle)
    }
    
    func execSHX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        var dummyCycle = 0
        let H = readByte(memory, address: PC - 1, cycle: &dummyCycle)
        writeByte(memory, address: address, value: X & (H &+ 1), cycle: &cycle)
    }
    
    func execSHY(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        var dummyCycle = 0
        let H = readByte(memory, address: PC - 1, cycle: &dummyCycle)
        writeByte(memory, address: address, value: Y & (H &+ 1), cycle: &cycle)
    }
    
    func execSHS(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        var dummyCycle = 0
        let H = readByte(memory, address: PC - 1, cycle: &dummyCycle)
        SP = A & X
        writeByte(memory, address: address, value: SP & (H &+ 1), cycle: &cycle)
    }
}
