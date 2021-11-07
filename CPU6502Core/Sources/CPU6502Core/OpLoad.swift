extension CPU6502 {
    func execLDA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        var val : UInt8 = 0
        switch addrMode {
        case .immediate:
            val = loadAddrImmedidate(memory, cycle: &cycle)
            break
        case .zeroPage:
            val = loadAddrZeroPage(memory, cycle: &cycle)
            break
        case .zeroPageX:
            val = loadAddrZeroPageX(memory, cycle: &cycle)
            break
        case .absolute:
            val = loadAddrAbsolute(memory, cycle: &cycle)
            break
        case .absoluteX:
            val = loadAddrAbsoluteX(memory, cycle: &cycle)
            break
        case .absoluteY:
            val = loadAddrAbsoluteY(memory, cycle: &cycle)
            break
        case .indexedIndirect:
            val = loadAddrIndexedIndirect(memory, cycle: &cycle)
            break
        case .indirectIndexed:
            val = loadAddrIndirectIndexed(memory, cycle: &cycle)
            break
        default:
            throw EmulateError.invalidAddrMode
        }
        A = val
        updateStatusFromConst(val)
    }
    
    func execLDX(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        var val : UInt8 = 0
        switch addrMode {
        case .immediate:
            val = loadAddrImmedidate(memory, cycle: &cycle)
            break
        case .zeroPage:
            val = loadAddrZeroPage(memory, cycle: &cycle)
            break
        case .zeroPageY:
            val = loadAddrZeroPageY(memory, cycle: &cycle)
            break
        case .absolute:
            val = loadAddrAbsolute(memory, cycle: &cycle)
            break
        case .absoluteY:
            val = loadAddrAbsoluteY(memory, cycle: &cycle)
            break
        default:
            throw EmulateError.invalidAddrMode
        }
        X = val
        updateStatusFromConst(val)
    }
    
    func execLDY(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        var val : UInt8 = 0
        switch addrMode {
        case .immediate:
            val = loadAddrImmedidate(memory, cycle: &cycle)
            break
        case .zeroPage:
            val = loadAddrZeroPage(memory, cycle: &cycle)
            break
        case .zeroPageX:
            val = loadAddrZeroPageX(memory, cycle: &cycle)
            break
        case .absolute:
            val = loadAddrAbsolute(memory, cycle: &cycle)
            break
        case .absoluteX:
            val = loadAddrAbsoluteX(memory, cycle: &cycle)
            break
        default:
            throw EmulateError.invalidAddrMode
        }
        Y = val
        updateStatusFromConst(val)
    }
}
