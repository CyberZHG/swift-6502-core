extension CPU6502 {
    func execCLC(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        C = false
        cycle += 1
    }
    
    func execSEC(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        C = true
        cycle += 1
    }
    
    func execCLD(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        D = false
        cycle += 1
    }
    
    func execSED(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        D = true
        cycle += 1
    }
    
    func execCLI(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        I = false
        cycle += 1
    }
    
    func execSEI(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        I = true
        cycle += 1
    }
    
    func execCLV(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        V = false
        cycle += 1
    }
}
