let PC_RESET_VAL: UInt16 = 0xFFFC
let SP_RESET_VAL: UInt8 = 0xFF
let P_RESET_VAL: UInt8 = 0b00110110

enum EmulateError: Error {
    case invalidOpCode
    case invalidAddrMode
}


enum EmulateFlag {
    /// The orignal 6502 does not deal with the page boundary correctly when using the indirect addressing.
    case useOriginalIncorrectIndirectJMP
}

/**
 The class contains all the 6502 states.
 */
public class CPU6502 {
    
    /// Program counter. This register points to the address of the next instruction to be executed.
    var PC : UInt16 = PC_RESET_VAL
    /// Stack pointer. This contains the offset to the stack page (`$0100` - `$01FF`).
    var SP : UInt8 = SP_RESET_VAL
    /// Processor status. The register stores the state of the processor.
    var P : UInt8 = P_RESET_VAL
    /// Accumulator. The main register for arithmetic and logical operations.
    var A : UInt8 = 0
    /// X index register. This generally is for addressing.
    var X : UInt8 = 0
    /// Y index register.
    var Y : UInt8 = 0
    
    /// Flags for emulation.
    var flags: Set<EmulateFlag> = []
    
    /// Negative flag. The flag will be set after any arithmetic operations.
    var N: Bool {
        get { return getPBit(7) }
        set(flag) { setPBit(7, flag)}
    }
    /// Overflow flag.
    var V: Bool {
        get { return getPBit(6) }
        set(flag) { setPBit(6, flag)}
    }
    /// Break flag.
    var B: Bool {
        get { return getPBit(4) }
        set(flag) { setPBit(4, flag)}
    }
    /// Decimal mode flag.
    var D: Bool {
        get { return getPBit(3) }
        set(flag) { setPBit(3, flag)}
    }
    /// Interrrupt disable flag.
    var I: Bool {
        get { return getPBit(2) }
        set(flag) { setPBit(2, flag)}
    }
    /// Zero flag.
    var Z: Bool {
        get { return getPBit(1) }
        set(flag) { setPBit(1, flag)}
    }
    /// Carry flag.
    var C: Bool {
        get { return getPBit(0) }
        set(flag) { setPBit(0, flag)}
    }
    
    func addFlag(_ flag: EmulateFlag) {
        flags.insert(flag)
    }
    
    func removeFlag(_ flag: EmulateFlag) {
        flags.remove(flag)
    }
    
    func removeAllFlag() {
        flags.removeAll()
    }

    /// Get 1 bit from the processor unit.
    private func getPBit(_ index: Int) -> Bool {
        return (P & (1 << index)) > 0
    }
    
    /// Set 1 bit to the processor unit.
    private func setPBit(_ index: Int, _ flag: Bool) {
        if (flag) {
            P |= 1 << index
        } else {
            P &= ~(1 << index)
        }
    }
    
    func reset() {
        PC = PC_RESET_VAL
        SP = SP_RESET_VAL
        P = P_RESET_VAL
        A = 0
        X = 0
        Y = 0
    }
    
    /**
        Execute codes with a given memory space.
     
        - Parameter memory: The memory space.
        - Parameter maxCycle: Maximum number of cycles that can be executed.
        Note that the actual cycle number may be greater than this value as
        it ensures that all the instructions are complete. Set to -1 to execute until a dead loop.
     
        - Returns: The actual number of cycles.
        */
    func execute(_ memory: Memory,
                 entry: UInt16 = PC_RESET_VAL,
                 maxCycle: Int = -1) throws -> Int {
        var cycle = 0
        while cycle < maxCycle {
            let code = readByte(memory, address: PC, cycle: &cycle)
            PC += 1
            guard let (op, addrMode) = CODE_TO_OPERATION[code] else {
                throw EmulateError.invalidOpCode
            }
            switch op {
            case Operation.NOP:
                try execNOP(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.BRK:
                try execBRK(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.RTI:
                try execRTI(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.JMP:
                try execJMP(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.JSR:
                try execJSR(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.RTS:
                try execRTS(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.LDA:
                try execLDA(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.LDX:
                try execLDX(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.LDY:
                try execLDY(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.LAS:
                try execLAS(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.LAX:
                try execLAX(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.STA:
                try execSTA(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.STX:
                try execSTX(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.STY:
                try execSTY(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.SAX:
                try execSAX(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.SHA:
                try execSHA(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.SHX:
                try execSHX(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.SHY:
                try execSHY(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.SHS:
                try execSHS(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.TAX:
                try execTAX(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.TXA:
                try execTXA(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.TAY:
                try execTAY(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.TYA:
                try execTYA(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.TXS:
                try execTXS(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.TSX:
                try execTSX(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.PHA:
                try execPHA(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.PLA:
                try execPLA(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.PHP:
                try execPHP(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.PLP:
                try execPLP(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.AND:
                try execAND(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.ORA:
                try execORA(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.EOR:
                try execEOR(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.BIT:
                try execBIT(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.CLC:
                try execCLC(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.SEC:
                try execSEC(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.CLD:
                try execCLD(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.SED:
                try execSED(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.CLI:
                try execCLI(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.SEI:
                try execSEI(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.CLV:
                try execCLV(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.ADC:
                try execADC(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.SBC:
                try execSBC(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.CMP:
                try execCMP(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.CPX:
                try execCPX(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.CPY:
                try execCPY(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.INC:
                try execINC(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.DEC:
                try execDEC(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.INX:
                try execINX(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.DEX:
                try execDEX(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.INY:
                try execINY(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.DEY:
                try execDEY(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.ASL:
                try execASL(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.LSR:
                try execLSR(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.ROL:
                try execROL(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.ROR:
                try execROR(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.ANC:
                try execANC(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.ARR:
                try execARR(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.BCC:
                try execBCC(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.BCS:
                try execBCS(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.BEQ:
                try execBEQ(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.BNE:
                try execBNE(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.BMI:
                try execBMI(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.BPL:
                try execBPL(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.BVC:
                try execBVC(memory, addrMode: addrMode, cycle: &cycle)
                break
            case Operation.BVS:
                try execBVS(memory, addrMode: addrMode, cycle: &cycle)
                break
            }
        }
        return cycle
    }
    
    /// Read a byte from the specific address in memory. It requires 1 cycle.
    internal func readByte(_ memory: Memory, address: UInt16, cycle: inout Int) -> UInt8 {
        cycle += 1
        return memory[Int(address)]
    }
    
    /// Read two bytes from the specific address in memory. It requires 2 cycles.
    internal func readWord(_ memory: Memory, address: UInt16, cycle: inout Int) -> UInt16 {
        cycle += 2
        return UInt16(memory[Int(address)]) + (UInt16(memory[Int(address) + 1]) << 8)
    }
    
    /// Write a byte from the specific address in memory. It requires 1 cycle.
    internal func writeByte(_ memory: Memory, address: UInt16, value: UInt8, cycle: inout Int) {
        cycle += 1
        memory[Int(address)] = value
    }
    
    /// Write two bytes from the specific address in memory. It requires 2 cycles.
    internal func writeWord(_ memory: Memory, address: UInt16, value: UInt16, cycle: inout Int) {
        cycle += 2
        memory[Int(address)] = UInt8(value & 0xFF)
        memory[Int(address) + 1] = UInt8(value >> 8)
    }
    
    /// Push a byte to the stack.
    internal func pushByte(_ memory: Memory, value: UInt8, cycle: inout Int) {
        writeByte(memory, address: (0x0100 | UInt16(SP)), value: value, cycle: &cycle)
        SP = SP &- 1
    }
    
    /// Pop a byte from the stack.
    internal func popByte(_ memory: Memory, cycle: inout Int) -> UInt8 {
        SP = SP &+ 1
        let addr = readByte(memory, address: (0x0100 | UInt16(SP)), cycle: &cycle)
        return addr
    }
    
    /// Push a word to the stack.
    internal func pushWord(_ memory: Memory, value: UInt16, cycle: inout Int) {
        writeWord(memory, address: (0x0100 | UInt16(SP)) - 1, value: value, cycle: &cycle)
        SP = SP &- 2
    }
    
    /// Pop a word from the stack.
    internal func popWord(_ memory: Memory, cycle: inout Int) -> UInt16 {
        SP = SP &+ 2
        let addr = readWord(memory, address: (0x0100 | UInt16(SP)) - 1, cycle: &cycle)
        return addr
    }
    
    internal func isPageCrossed(_ a: UInt16, _ b: UInt16) -> Bool {
        return (a >> 8) != (b >> 8)
    }
    
    /// Get the address from immediate addressing. The address is the byte that PC points to.
    internal func getAddrImmedidate(_ memory: Memory, cycle: inout Int) -> UInt16 {
        let addr = PC
        PC += 1
        return addr
    }
    
    /// Get the address from zero page.
    internal func getAddrZeroPage(_ memory: Memory, cycle: inout Int) -> UInt16 {
        let zeroPageAddr = readByte(memory, address: PC, cycle: &cycle)
        PC += 1
        return UInt16(zeroPageAddr)
    }
    
    /// Get the address from zero page indexed by X. The zero page address should modulo 0x100 after indexing.
    internal func getAddrZeroPageX(_ memory: Memory, cycle: inout Int) -> UInt16 {
        let zeroPageAddr = readByte(memory, address: PC, cycle: &cycle)
        PC += 1
        cycle += 1
        return (UInt16(zeroPageAddr) + UInt16(X)) % 0x100
    }
    
    /// Get the address from zero page indexed by Y. The zero page address should modulo 0x100 after indexing.
    internal func getAddrZeroPageY(_ memory: Memory, cycle: inout Int) -> UInt16 {
        let zeroPageAddr = readByte(memory, address: PC, cycle: &cycle)
        PC += 1
        cycle += 1
        return (UInt16(zeroPageAddr) + UInt16(Y)) % 0x100
    }
    
    /// Get the address from a 2-byte absolute address.
    internal func getAddrAbsolute(_ memory: Memory, cycle: inout Int) -> UInt16 {
        let absAddr = readWord(memory, address: PC, cycle: &cycle)
        PC += 2
        return absAddr
    }
    
    /// Get the address from a 2-byte absolute address indexed by X. One extra cycle is required when a page boundary is crossed.
    internal func getAddrAbsoluteX(_ memory: Memory, cycle: inout Int, addIndexedCost: Bool) -> UInt16 {
        let absAddr = readWord(memory, address: PC, cycle: &cycle)
        PC += 2
        let indexedAddr = absAddr + UInt16(X)
        if addIndexedCost || isPageCrossed(absAddr, indexedAddr) {
            cycle += 1
        }
        return indexedAddr
    }
    
    /// Get the address from a 2-byte absolute address indexed by Y. One extra cycle is required when a page boundary is crossed.
    internal func getAddrAbsoluteY(_ memory: Memory, cycle: inout Int, addIndexedCost: Bool) -> UInt16 {
        let absAddr = readWord(memory, address: PC, cycle: &cycle)
        PC += 2
        let indexedAddr = absAddr + UInt16(Y)
        if addIndexedCost || isPageCrossed(absAddr, indexedAddr) {
            cycle += 1
        }
        return indexedAddr
    }
    
    /// Get the address based on the indirect addressing.
    internal func getAddrIndirect(_ memory: Memory, cycle: inout Int) -> UInt16 {
        let indirectAddr = readWord(memory, address: PC, cycle: &cycle)
        if flags.contains(.useOriginalIncorrectIndirectJMP) && (indirectAddr & 0xFF) == 0xFF {
            let low = readByte(memory, address: indirectAddr, cycle: &cycle)
            let high = readByte(memory, address: (indirectAddr & 0xFF00), cycle: &cycle)
            return (UInt16(high) << 8) | UInt16(low)
        }
        return readWord(memory, address: indirectAddr, cycle: &cycle)
    }
    
    /// Get the address based on the indexed indirect addressing.
    internal func getAddrIndexedIndirect(_ memory: Memory, cycle: inout Int) -> UInt16 {
        let zeroPageAddr = readByte(memory, address: PC, cycle: &cycle)
        PC += 1
        let indexedAddr = (UInt16(zeroPageAddr) + UInt16(X)) % 0x100
        cycle += 1
        return readWord(memory, address: indexedAddr, cycle: &cycle)
    }
    
    /// Get the address based on the indirect indexed addressing.
    internal func getAddrIndirectIndexed(_ memory: Memory, cycle: inout Int, addIndexedCost: Bool) -> UInt16 {
        let zeroPageAddr = readByte(memory, address: PC, cycle: &cycle)
        PC += 1
        let indirectAddr = readWord(memory, address: UInt16(zeroPageAddr), cycle: &cycle)
        let indexedAddr = indirectAddr + UInt16(Y)
        if addIndexedCost || isPageCrossed(indirectAddr, indexedAddr) {
            cycle += 1
        }
        return indexedAddr
    }
    
    /// Get the relative address based on P.
    internal func getAddrRelative(_ memory: Memory, cycle: inout Int) -> UInt16 {
        var relative = Int(readByte(memory, address: PC, cycle: &cycle))
        PC += 1
        if relative >= 0x80 {
            relative -= 0x100
        }
        return UInt16((Int(PC) + Int(relative) + 0x10000) & 0xFFFF)
    }
    
    /// Get the address based on the addressing mode.
    internal func getAddress(_ memory: Memory, addrMode: AddressingMode,
                             cycle: inout Int, addIndexedCost: Bool = false) throws -> UInt16 {
        switch addrMode {
        case .immediate:
            return getAddrImmedidate(memory, cycle: &cycle)
        case .zeroPage:
            return getAddrZeroPage(memory, cycle: &cycle)
        case .zeroPageX:
            return getAddrZeroPageX(memory, cycle: &cycle)
        case .zeroPageY:
            return getAddrZeroPageY(memory, cycle: &cycle)
        case .absolute:
            return getAddrAbsolute(memory, cycle: &cycle)
        case .absoluteX:
            return getAddrAbsoluteX(memory, cycle: &cycle, addIndexedCost: addIndexedCost)
        case .absoluteY:
            return getAddrAbsoluteY(memory, cycle: &cycle, addIndexedCost: addIndexedCost)
        case .indirect:
            return getAddrIndirect(memory, cycle: &cycle)
        case .indexedIndirect:
            return getAddrIndexedIndirect(memory, cycle: &cycle)
        case .indirectIndexed:
            return getAddrIndirectIndexed(memory, cycle: &cycle, addIndexedCost: addIndexedCost)
        case .relative:
            return getAddrRelative(memory, cycle: &cycle)
        default:
            throw EmulateError.invalidAddrMode
        }
    }
    
    /// Update status based on A. A only affects zero and negative flags.
    internal func updateStatusNZFromConst(_ val: UInt8) {
        self.Z = val == 0
        self.N = (val & 0b10000000) > 0
    }
}
