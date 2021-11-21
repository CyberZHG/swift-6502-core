extension CPU6502 {
    func execBCC(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        if !C {
            cycle += 1
            if isPageCrossed(PC, address) {
                cycle += 1
            }
            PC = address
        }
    }
    
    func execBCS(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        if C {
            cycle += 1
            if isPageCrossed(PC, address) {
                cycle += 1
            }
            PC = address
        }
    }
    
    func execBEQ(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        if Z {
            cycle += 1
            if isPageCrossed(PC, address) {
                cycle += 1
            }
            PC = address
        }
    }
    
    func execBNE(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        if !Z {
            cycle += 1
            if isPageCrossed(PC, address) {
                cycle += 1
            }
            PC = address
        }
    }
    
    func execBMI(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        if N {
            cycle += 1
            if isPageCrossed(PC, address) {
                cycle += 1
            }
            PC = address
        }
    }
    
    func execBPL(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        if !N {
            cycle += 1
            if isPageCrossed(PC, address) {
                cycle += 1
            }
            PC = address
        }
    }
    
    func execBVC(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        if !V {
            cycle += 1
            if isPageCrossed(PC, address) {
                cycle += 1
            }
            PC = address
        }
    }
    
    func execBVS(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        if V {
            cycle += 1
            if isPageCrossed(PC, address) {
                cycle += 1
            }
            PC = address
        }
    }
}
