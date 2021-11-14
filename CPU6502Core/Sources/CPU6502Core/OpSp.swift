extension CPU6502 {
    func execNOP(_ memory: Memory, addrMode: AddressingMode, cycle: inout Int) throws {
        if addrMode != .implied {
            throw EmulateError.invalidAddrMode
        }
        cycle += 1
    }
}
