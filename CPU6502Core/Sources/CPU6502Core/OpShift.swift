extension CPU6502 {
    func execASL(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        var M = A, address = UInt16(0)
        if addrMode != AddressingMode.accumulator {
            address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
            M = readByte(memory, address: address, cycle: &cycle)
        }
        C = (M & 0b10000000) > 0
        N = (M & 0b01000000) > 0
        M = M &<< 1
        Z = M == 0
        cycle += 1
        if addrMode == AddressingMode.accumulator {
            A = M
        } else {
            writeByte(memory, address: address, value: M, cycle: &cycle)
        }
    }
    
    func execLSR(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        var M = A, address = UInt16(0)
        if addrMode != AddressingMode.accumulator {
            address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
            M = readByte(memory, address: address, cycle: &cycle)
        }
        C = (M & 0b00000001) > 0
        N = false
        M = M >> 1
        Z = M == 0
        cycle += 1
        if addrMode == AddressingMode.accumulator {
            A = M
        } else {
            writeByte(memory, address: address, value: M, cycle: &cycle)
        }
    }
    
    func execROL(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
    }
    
    func execROR(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
    }
}
