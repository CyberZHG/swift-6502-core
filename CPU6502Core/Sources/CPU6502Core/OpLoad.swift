extension CPU6502 {
    func execLDA(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        var val : UInt8 = 0
        switch addrMode {
        case .IMMEDIATE:
            val = loadAddrImmedidate(memory, cycle: &cycle)
            break
        case .ZERO_PAGE:
            val = loadAddrZeroPage(memory, cycle: &cycle)
            break
        case .ZERO_PAGE_X:
            val = loadAddrZeroPageX(memory, cycle: &cycle)
            break
        case .ABSOLUTE:
            val = loadAddrAbsolute(memory, cycle: &cycle)
            break
        case .ABSOLUTE_X:
            val = loadAddrAbsoluteX(memory, cycle: &cycle)
            break
        case .ABSOLUTE_Y:
            val = loadAddrAbsoluteY(memory, cycle: &cycle)
            break
        case .INDEXED_INDIRECT:
            val = loadAddrIndexedIndirect(memory, cycle: &cycle)
            break
        case .INDIRECT_INDEXED:
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
        case .IMMEDIATE:
            val = loadAddrImmedidate(memory, cycle: &cycle)
            break
        case .ZERO_PAGE:
            val = loadAddrZeroPage(memory, cycle: &cycle)
            break
        case .ZERO_PAGE_Y:
            val = loadAddrZeroPageY(memory, cycle: &cycle)
            break
        case .ABSOLUTE:
            val = loadAddrAbsolute(memory, cycle: &cycle)
            break
        case .ABSOLUTE_Y:
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
        case .IMMEDIATE:
            val = loadAddrImmedidate(memory, cycle: &cycle)
            break
        case .ZERO_PAGE:
            val = loadAddrZeroPage(memory, cycle: &cycle)
            break
        case .ZERO_PAGE_X:
            val = loadAddrZeroPageX(memory, cycle: &cycle)
            break
        case .ABSOLUTE:
            val = loadAddrAbsolute(memory, cycle: &cycle)
            break
        case .ABSOLUTE_X:
            val = loadAddrAbsoluteX(memory, cycle: &cycle)
            break
        default:
            throw EmulateError.invalidAddrMode
        }
        Y = val
        updateStatusFromConst(val)
    }
}
