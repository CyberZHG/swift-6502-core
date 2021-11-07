extension CPU6502 {
    func execLDA(_ memory: Memory, code: UInt8, cycle: inout Int) {
        let addrCode = getAddrCode(code)
        switch CODE_TO_ADDRESSING_01[addrCode]! {
        case AddressingMode.IMMEDIATE:
            let val = loadAddrImmedidate(memory, cycle: &cycle)
            A = val
            break
        default:
            break
        }
        updateStatusFromA()
    }
}
