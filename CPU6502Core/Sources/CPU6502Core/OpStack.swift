extension CPU6502 {
    func execTXS(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        pushByte(memory, value: X, cycle: &cycle)
    }
    
    func execTSX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        X = popByte(memory, cycle: &cycle)
        updateStatusFromConst(X)
    }
    
    func execPHA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        pushByte(memory, value: A, cycle: &cycle)
        cycle += 1
    }
    
    func execPLA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        A = popByte(memory, cycle: &cycle)
        cycle += 2
        updateStatusFromConst(A)
    }
    
    func execPHP(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        pushByte(memory, value: P, cycle: &cycle)
        cycle += 1
    }
    
    func execPLP(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        P = popByte(memory, cycle: &cycle)
        cycle += 2
    }
}
