extension CPU6502 {
    fileprivate func isSignSame(_ a: UInt8, _ b: UInt8) -> Bool {
        return ((a ^ b) & 0b10000000) == 0
    }
    
    func execADC(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        let M = readByte(memory, address: address, cycle: &cycle)
        let signSame = isSignSame(A, M)
        var result = -1
        if D {
            let AL = A & 0x0F, ML = M & 0x0F
            var L = Int(AL) + Int(ML) + (C ? 1 : 0)
            if L >= 0x0A {
                L = ((L + 0x06) & 0x0F) + 0x10
            }
            let AH = A & 0xF0, MH = M & 0xF0
            result = Int(AH) + Int(MH) + L
            if result >= 0xA0 {
                result += 0x60
            }
        } else {
            result = Int(A) + Int(M) + (C ? 1 : 0)
        }
        C = result >= 0x100
        A = UInt8(result & 0xFF)
        V = signSame && !isSignSame(A, M)
        updateStatusNZFromConst(A)
    }
    
    func execSBC(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        let M = readByte(memory, address: address, cycle: &cycle)
        let signSame = isSignSame(A, M)
        var result = -1
        if D {
            let AL = A & 0x0F, ML = M & 0x0F
            var L = Int(AL) - Int(ML) - (C ? 0 : 1)
            if L < 0 {
                L = ((L - 0x06) & 0x0F) - 0x10
            }
            let AH = A & 0xF0, MH = M & 0xF0
            result = Int(AH) - Int(MH) + L
            if result < 0 {
                result -= 0x60
            }
        } else {
            result = Int(A) - Int(M) - (C ? 0 : 1)
        }
        C = result >= 0
        A = UInt8((result + 0x100) & 0xFF)
        V = !signSame && isSignSame(A, M)
        updateStatusNZFromConst(A)
    }
    
    func execCMP(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        let M = readByte(memory, address: address, cycle: &cycle)
        let result = (Int(A) - Int(M) + 0x100) & 0b10000000
        C = A >= M
        Z = A == M
        N = result > 0
    }
    
    func execCPX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        let M = readByte(memory, address: address, cycle: &cycle)
        let result = (Int(X) - Int(M) + 0x100) & 0b10000000
        C = X >= M
        Z = X == M
        N = result > 0
    }
    
    func execCPY(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        let M = readByte(memory, address: address, cycle: &cycle)
        let result = (Int(Y) - Int(M) + 0x100) & 0b10000000
        C = Y >= M
        Z = Y == M
        N = result > 0
    }
    
    func execANC(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        A &= readByte(memory, address: address, cycle: &cycle)
        updateStatusNZFromConst(A)
        C = N
    }
}
