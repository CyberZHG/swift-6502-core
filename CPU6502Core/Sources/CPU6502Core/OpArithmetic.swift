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
    
    func execARR(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        let M = readByte(memory, address: address, cycle: &cycle)
        let and = M & A
        let result = and >> 1 + (C ? 0b10000000 : 0)
        if D {
            N = C
            Z = result == 0
            V = (result & 0b01000000) != (A & 0b01000000)
            let ah = and >> 4
            let al = and & 0x0F
            A = result
            if al + (al & 1) > 5 {
                A = (A & 0xF0) | ((A &+ 6) & 0x0F)
            }
            C = ah + (ah & 1) > 5
            if C {
                A = UInt8((Int(A) + 0x60) & 0xFF)
            }
        } else {
            C = (result & 0b01000000) > 0
            V = ((result & 0b01000000) > 0) != ((result & 0b00100000) > 0)
            A = result
            updateStatusNZFromConst(A)
        }
    }
    
    func execASR(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        let M = A & readByte(memory, address: address, cycle: &cycle)
        C = (M & 0x01) > 0
        A = M >> 1
        updateStatusNZFromConst(A)
    }
    
    func execSBX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        let M = readByte(memory, address: address, cycle: &cycle)
        C = (A & X) >= M
        X = (A & X) &- M
        updateStatusNZFromConst(X)
    }
    
    func execXAA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: false)
        let M = readByte(memory, address: address, cycle: &cycle)
        A = (A | 0xFE) & X & M  // 0xFE is the most common magic number
        updateStatusNZFromConst(A)
    }
    
    func execDCP(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        let M = readByte(memory, address: address, cycle: &cycle) &- 1
        cycle += 1
        let result = (Int(A) - Int(M) + 0x100) & 0b10000000
        C = A >= M
        Z = A == M
        N = result > 0
        writeByte(memory, address: address, value: M, cycle: &cycle)
    }
    
    func execISC(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        let M = readByte(memory, address: address, cycle: &cycle) &+ 1
        cycle += 1
        let signSame = isSignSame(A, M)
        let result = Int(A) - Int(M)
        C = result >= 0
        A = UInt8((result + 0x100) & 0xFF)
        V = !signSame && isSignSame(A, M)
        updateStatusNZFromConst(A)
        writeByte(memory, address: address, value: M, cycle: &cycle)
    }
    
    func execRLA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        let M = readByte(memory, address: address, cycle: &cycle)
        cycle += 2
        let rot = (M &<< 1) + (C ? 1 : 0)
        C = (M & 0b10000000) > 0
        A = A & rot
        updateStatusNZFromConst(A)
    }
    
    func execRRA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        var M = readByte(memory, address: address, cycle: &cycle)
        cycle += 2
        let rot = (M >> 1) + (C ? 0b10000000 : 0)
        C = (M & 0x01) > 0
        M = rot
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
    
    func execSLO(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        var M = readByte(memory, address: address, cycle: &cycle)
        cycle += 1
        C = (M & 0b10000000) > 0
        M = M &<< 1
        A = A | M
        updateStatusNZFromConst(A)
        writeByte(memory, address: address, value: M, cycle: &cycle)
    }
    
    func execSRE(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        let address = try getAddress(memory, addrMode: addrMode, cycle: &cycle, addIndexedCost: true)
        let M = readByte(memory, address: address, cycle: &cycle)
    }
}
