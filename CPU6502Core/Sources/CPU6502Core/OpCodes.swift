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
    case ADC, SBC, CMP, CPX, CPY
    case INC, DEC, INX, DEX, INY, DEY
    case ASL, LSR, ROL, ROR
}

/* TODO:
 BCC BCS BEQ
 BMI BNE BPL BRK BVC BVS
 RTI
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
    
    UInt8(0xE9): (Operation.SBC, AddressingMode.immediate),
    UInt8(0xE5): (Operation.SBC, AddressingMode.zeroPage),
    UInt8(0xF5): (Operation.SBC, AddressingMode.zeroPageX),
    UInt8(0xED): (Operation.SBC, AddressingMode.absolute),
    UInt8(0xFD): (Operation.SBC, AddressingMode.absoluteX),
    UInt8(0xF9): (Operation.SBC, AddressingMode.absoluteY),
    UInt8(0xE1): (Operation.SBC, AddressingMode.indexedIndirect),
    UInt8(0xF1): (Operation.SBC, AddressingMode.indirectIndexed),
    
    UInt8(0xC9): (Operation.CMP, AddressingMode.immediate),
    UInt8(0xC5): (Operation.CMP, AddressingMode.zeroPage),
    UInt8(0xD5): (Operation.CMP, AddressingMode.zeroPageX),
    UInt8(0xCD): (Operation.CMP, AddressingMode.absolute),
    UInt8(0xDD): (Operation.CMP, AddressingMode.absoluteX),
    UInt8(0xD9): (Operation.CMP, AddressingMode.absoluteY),
    UInt8(0xC1): (Operation.CMP, AddressingMode.indexedIndirect),
    UInt8(0xD1): (Operation.CMP, AddressingMode.indirectIndexed),
    
    UInt8(0xE0): (Operation.CPX, AddressingMode.immediate),
    UInt8(0xE4): (Operation.CPX, AddressingMode.zeroPage),
    UInt8(0xEC): (Operation.CPX, AddressingMode.absolute),
    
    UInt8(0xC0): (Operation.CPY, AddressingMode.immediate),
    UInt8(0xC4): (Operation.CPY, AddressingMode.zeroPage),
    UInt8(0xCC): (Operation.CPY, AddressingMode.absolute),
    
    UInt8(0xE6): (Operation.INC, AddressingMode.zeroPage),
    UInt8(0xF6): (Operation.INC, AddressingMode.zeroPageX),
    UInt8(0xEE): (Operation.INC, AddressingMode.absolute),
    UInt8(0xFE): (Operation.INC, AddressingMode.absoluteX),
    
    UInt8(0xC6): (Operation.DEC, AddressingMode.zeroPage),
    UInt8(0xD6): (Operation.DEC, AddressingMode.zeroPageX),
    UInt8(0xCE): (Operation.DEC, AddressingMode.absolute),
    UInt8(0xDE): (Operation.DEC, AddressingMode.absoluteX),
    
    UInt8(0xE8): (Operation.INX, AddressingMode.implied),
    
    UInt8(0xCA): (Operation.DEX, AddressingMode.implied),
    
    UInt8(0xC8): (Operation.INY, AddressingMode.implied),
    
    UInt8(0x88): (Operation.DEY, AddressingMode.implied),
    
    UInt8(0x0A): (Operation.ASL, AddressingMode.accumulator),
    UInt8(0x06): (Operation.ASL, AddressingMode.zeroPage),
    UInt8(0x16): (Operation.ASL, AddressingMode.zeroPageX),
    UInt8(0x0E): (Operation.ASL, AddressingMode.absolute),
    UInt8(0x1E): (Operation.ASL, AddressingMode.absoluteX),
    
    UInt8(0x4A): (Operation.LSR, AddressingMode.accumulator),
    UInt8(0x46): (Operation.LSR, AddressingMode.zeroPage),
    UInt8(0x56): (Operation.LSR, AddressingMode.zeroPageX),
    UInt8(0x4E): (Operation.LSR, AddressingMode.absolute),
    UInt8(0x5E): (Operation.LSR, AddressingMode.absoluteX),
    
    UInt8(0x2A): (Operation.ROL, AddressingMode.accumulator),
    UInt8(0x26): (Operation.ROL, AddressingMode.zeroPage),
    UInt8(0x36): (Operation.ROL, AddressingMode.zeroPageX),
    UInt8(0x2E): (Operation.ROL, AddressingMode.absolute),
    UInt8(0x3E): (Operation.ROL, AddressingMode.absoluteX),
    
    UInt8(0x6A): (Operation.ROR, AddressingMode.accumulator),
    UInt8(0x66): (Operation.ROR, AddressingMode.zeroPage),
    UInt8(0x76): (Operation.ROR, AddressingMode.zeroPageX),
    UInt8(0x6E): (Operation.ROR, AddressingMode.absolute),
    UInt8(0x7E): (Operation.ROR, AddressingMode.absoluteX),
]
