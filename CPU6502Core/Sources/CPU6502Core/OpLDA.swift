extension CPU6502 {
    func execLDA(_ memory: Memory, code: UInt8, cycle: inout Int) {
        let addrCode = getAddrCode(code)
        var val : UInt8 = 0
        switch CODE_TO_ADDRESSING_01[addrCode]! {
        case AddressingMode.IMMEDIATE:
            val = loadAddrImmedidate(memory, cycle: &cycle)
            break
        case AddressingMode.ZERO_PAGE:
            val = loadAddrZeroPage(memory, cycle: &cycle)
            break
        case AddressingMode.ZERO_PAGE_X:
            val = loadAddrZeroPageX(memory, cycle: &cycle)
            break
        case AddressingMode.ABSOLUTE:
            val = loadAddrAbsolute(memory, cycle: &cycle)
            break
        case AddressingMode.ABSOLUTE_X:
            val = loadAddrAbsoluteX(memory, cycle: &cycle)
            break
        case AddressingMode.ABSOLUTE_Y:
            val = loadAddrAbsoluteY(memory, cycle: &cycle)
            break
        default:
            break
        }
        A = val
        updateStatusFromA()
    }
}
