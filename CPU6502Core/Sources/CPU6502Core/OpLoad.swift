extension CPU6502 {
    func execLDA(_ memory: Memory, code: UInt8, cycle: inout Int) throws {
        let addrCode = getAddrCode(code)
        var val : UInt8 = 0
        guard let addrMode = CODE_TO_ADDRESSING_01[addrCode] else {
            throw EmulateError.invalidAddrMode
        }
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
            break
        }
        A = val
        updateStatusFromConst(val)
    }
    
    func execLDX(_ memory: Memory, code: UInt8, cycle: inout Int) throws {
        let addrCode = getAddrCode(code)
        var val : UInt8 = 0
        guard let addrMode = CODE_TO_ADDRESSING_10[addrCode] else {
            // TODO: 010 TAX, 100 Invalid, 110 TSX
            throw EmulateError.invalidAddrMode
        }
        switch addrMode {
        case .IMMEDIATE:
            val = loadAddrImmedidate(memory, cycle: &cycle)
            break
        case .ZERO_PAGE:
            val = loadAddrZeroPage(memory, cycle: &cycle)
            break
        case .ZERO_PAGE_X:
            val = loadAddrZeroPageY(memory, cycle: &cycle)
            break
        case .ABSOLUTE:
            val = loadAddrAbsolute(memory, cycle: &cycle)
            break
        case .ABSOLUTE_X:
            val = loadAddrAbsoluteY(memory, cycle: &cycle)
            break
        default:
            throw EmulateError.invalidAddrMode
        }
        X = val
        updateStatusFromConst(val)
    }
    
    func execLDY(_ memory: Memory, code: UInt8, cycle: inout Int) throws {
        let addrCode = getAddrCode(code)
        var val : UInt8 = 0
        guard let addrMode = CODE_TO_ADDRESSING_00[addrCode] else {
            // TODO: 010 TYA, 100 BCS, 110 CLV
            throw EmulateError.invalidAddrMode
        }
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
