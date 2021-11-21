enum AddressingMode {
    case accumulator
    case implied
    case immediate
    case zeroPage
    case zeroPageX
    case zeroPageY
    case absolute
    case absoluteX
    case absoluteY
    case indirect
    case indirectIndexed
    case indexedIndirect
    case relative
}


enum Operation {
    case NOP
    case JMP, JSR, RTS
    case LDA, LDX, LDY
    case STA, STX, STY
    case TAX, TAY, TXA, TYA
    case TXS, TSX, PHA, PLA, PHP, PLP
    case AND, ORA, EOR, BIT
    case CLC, SEC, CLD, SED, CLI, SEI, CLV
    case ADC
}

/* TODO:
 ASL BCC BCS BEQ
 BMI BNE BPL BRK BVC BVS
 CMP CPX CPY DEC
 DEX DEY INC INX INY
 LSR
 PHA PHP PLA PLP ROL ROR RTI
 SBC
 */


let CODE_TO_OPERATION = [
    UInt8(0xEA): (Operation.NOP, AddressingMode.implied),
    
    UInt8(0x4C): (Operation.JMP, AddressingMode.absolute),
    UInt8(0x6C): (Operation.JMP, AddressingMode.indirect),
    
    UInt8(0x20): (Operation.JSR, AddressingMode.absolute),
    
    UInt8(0x60): (Operation.RTS, AddressingMode.implied),
    
    UInt8(0xA9): (Operation.LDA, AddressingMode.immediate),
    UInt8(0xA5): (Operation.LDA, AddressingMode.zeroPage),
    UInt8(0xB5): (Operation.LDA, AddressingMode.zeroPageX),
    UInt8(0xAD): (Operation.LDA, AddressingMode.absolute),
    UInt8(0xBD): (Operation.LDA, AddressingMode.absoluteX),
    UInt8(0xB9): (Operation.LDA, AddressingMode.absoluteY),
    UInt8(0xA1): (Operation.LDA, AddressingMode.indexedIndirect),
    UInt8(0xB1): (Operation.LDA, AddressingMode.indirectIndexed),
    
    UInt8(0xA2): (Operation.LDX, AddressingMode.immediate),
    UInt8(0xA6): (Operation.LDX, AddressingMode.zeroPage),
    UInt8(0xB6): (Operation.LDX, AddressingMode.zeroPageY),
    UInt8(0xAE): (Operation.LDX, AddressingMode.absolute),
    UInt8(0xBE): (Operation.LDX, AddressingMode.absoluteY),
    
    UInt8(0xA0): (Operation.LDY, AddressingMode.immediate),
    UInt8(0xA4): (Operation.LDY, AddressingMode.zeroPage),
    UInt8(0xB4): (Operation.LDY, AddressingMode.zeroPageX),
    UInt8(0xAC): (Operation.LDY, AddressingMode.absolute),
    UInt8(0xBC): (Operation.LDY, AddressingMode.absoluteX),
    
    UInt8(0x85): (Operation.STA, AddressingMode.zeroPage),
    UInt8(0x95): (Operation.STA, AddressingMode.zeroPageX),
    UInt8(0x8D): (Operation.STA, AddressingMode.absolute),
    UInt8(0x9D): (Operation.STA, AddressingMode.absoluteX),
    UInt8(0x99): (Operation.STA, AddressingMode.absoluteY),
    UInt8(0x81): (Operation.STA, AddressingMode.indexedIndirect),
    UInt8(0x91): (Operation.STA, AddressingMode.indirectIndexed),
    
    UInt8(0x86): (Operation.STX, AddressingMode.zeroPage),
    UInt8(0x96): (Operation.STX, AddressingMode.zeroPageY),
    UInt8(0x8E): (Operation.STX, AddressingMode.absolute),
    
    UInt8(0x84): (Operation.STY, AddressingMode.zeroPage),
    UInt8(0x94): (Operation.STY, AddressingMode.zeroPageX),
    UInt8(0x8C): (Operation.STY, AddressingMode.absolute),
    
    UInt8(0xAA): (Operation.TAX, AddressingMode.implied),
    
    UInt8(0x8A): (Operation.TXA, AddressingMode.implied),
    
    UInt8(0xA8): (Operation.TAY, AddressingMode.implied),
    
    UInt8(0x98): (Operation.TYA, AddressingMode.implied),
    
    UInt8(0x9A): (Operation.TXS, AddressingMode.implied),
    
    UInt8(0xBA): (Operation.TSX, AddressingMode.implied),
    
    UInt8(0x48): (Operation.PHA, AddressingMode.implied),
    
    UInt8(0x68): (Operation.PLA, AddressingMode.implied),
    
    UInt8(0x08): (Operation.PHP, AddressingMode.implied),
    
    UInt8(0x28): (Operation.PLP, AddressingMode.implied),
    
    UInt8(0x29): (Operation.AND, AddressingMode.immediate),
    UInt8(0x25): (Operation.AND, AddressingMode.zeroPage),
    UInt8(0x35): (Operation.AND, AddressingMode.zeroPageX),
    UInt8(0x2D): (Operation.AND, AddressingMode.absolute),
    UInt8(0x3D): (Operation.AND, AddressingMode.absoluteX),
    UInt8(0x39): (Operation.AND, AddressingMode.absoluteY),
    UInt8(0x21): (Operation.AND, AddressingMode.indexedIndirect),
    UInt8(0x31): (Operation.AND, AddressingMode.indirectIndexed),
    
    UInt8(0x09): (Operation.ORA, AddressingMode.immediate),
    UInt8(0x05): (Operation.ORA, AddressingMode.zeroPage),
    UInt8(0x15): (Operation.ORA, AddressingMode.zeroPageX),
    UInt8(0x0D): (Operation.ORA, AddressingMode.absolute),
    UInt8(0x1D): (Operation.ORA, AddressingMode.absoluteX),
    UInt8(0x19): (Operation.ORA, AddressingMode.absoluteY),
    UInt8(0x01): (Operation.ORA, AddressingMode.indexedIndirect),
    UInt8(0x11): (Operation.ORA, AddressingMode.indirectIndexed),
    
    UInt8(0x49): (Operation.EOR, AddressingMode.immediate),
    UInt8(0x45): (Operation.EOR, AddressingMode.zeroPage),
    UInt8(0x55): (Operation.EOR, AddressingMode.zeroPageX),
    UInt8(0x4D): (Operation.EOR, AddressingMode.absolute),
    UInt8(0x5D): (Operation.EOR, AddressingMode.absoluteX),
    UInt8(0x59): (Operation.EOR, AddressingMode.absoluteY),
    UInt8(0x41): (Operation.EOR, AddressingMode.indexedIndirect),
    UInt8(0x51): (Operation.EOR, AddressingMode.indirectIndexed),
    
    UInt8(0x24): (Operation.BIT, AddressingMode.zeroPage),
    UInt8(0x2C): (Operation.BIT, AddressingMode.absolute),
    
    UInt8(0x18): (Operation.CLC, AddressingMode.implied),
    
    UInt8(0x38): (Operation.SEC, AddressingMode.implied),
    
    UInt8(0xD8): (Operation.CLD, AddressingMode.implied),
    
    UInt8(0xF8): (Operation.SED, AddressingMode.implied),
    
    UInt8(0x58): (Operation.CLI, AddressingMode.implied),
    
    UInt8(0x78): (Operation.SEI, AddressingMode.implied),
    
    UInt8(0xB8): (Operation.CLV, AddressingMode.implied),
    
    UInt8(0x69): (Operation.ADC, AddressingMode.immediate),
    UInt8(0x65): (Operation.ADC, AddressingMode.zeroPage),
    UInt8(0x75): (Operation.ADC, AddressingMode.zeroPageX),
    UInt8(0x6D): (Operation.ADC, AddressingMode.absolute),
    UInt8(0x7D): (Operation.ADC, AddressingMode.absoluteX),
    UInt8(0x79): (Operation.ADC, AddressingMode.absoluteY),
    UInt8(0x61): (Operation.ADC, AddressingMode.indexedIndirect),
    UInt8(0x71): (Operation.ADC, AddressingMode.indirectIndexed),
]
