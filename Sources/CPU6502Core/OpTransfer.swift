extension CPU6502 {
    func execTAX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        X = A
        cycle += 1
        updateStatusNZFromConst(X)
    }
    
    func execTXA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        A = X
        cycle += 1
        updateStatusNZFromConst(A)
    }
    
    func execTAY(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        Y = A
        cycle += 1
        updateStatusNZFromConst(Y)
    }
    
    func execTYA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        A = Y
        cycle += 1
        updateStatusNZFromConst(A)
    }
}
