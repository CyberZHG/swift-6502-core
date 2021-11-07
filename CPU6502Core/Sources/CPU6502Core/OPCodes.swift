enum AddressingMode {
    case ACCUMULATOR
    case IMPLIED
    case IMMEDIATE
    case ZERO_PAGE
    case ZERO_PAGE_X
    case ZERO_PAGE_Y
    case ABSOLUTE
    case ABSOLUTE_X
    case ABSOLUTE_Y
    case INDIRECT
    case INDIRECT_INDEXED
    case INDEXED_INDIRECT
    case RELATIVE
}


enum Operation {
    case LDA
}

let CODE_TO_ADDRESSING_00 = [
    UInt8(0b000): AddressingMode.IMMEDIATE,
    UInt8(0b001): AddressingMode.ZERO_PAGE,
    UInt8(0b010): AddressingMode.IMPLIED,
    UInt8(0b011): AddressingMode.ABSOLUTE,
    UInt8(0b100): AddressingMode.RELATIVE,
    UInt8(0b110): AddressingMode.IMPLIED,
]

let CODE_TO_ADDRESSING_01 = [
    UInt8(0b000): AddressingMode.INDIRECT_INDEXED,
    UInt8(0b001): AddressingMode.ZERO_PAGE,
    UInt8(0b010): AddressingMode.IMMEDIATE,
    UInt8(0b011): AddressingMode.ABSOLUTE,
    UInt8(0b100): AddressingMode.INDEXED_INDIRECT,
    UInt8(0b101): AddressingMode.ZERO_PAGE_X,
    UInt8(0b110): AddressingMode.ABSOLUTE_Y,
    UInt8(0b111): AddressingMode.ABSOLUTE_X,
]

let CODE_TO_ADDRESSING_10 = [
    UInt8(0b001): AddressingMode.ZERO_PAGE,
    UInt8(0b010): AddressingMode.ACCUMULATOR,
    UInt8(0b010): AddressingMode.IMPLIED,
    UInt8(0b101): AddressingMode.ZERO_PAGE_X, // ZERO_PAGE_Y
    UInt8(0b011): AddressingMode.ABSOLUTE,
    UInt8(0b111): AddressingMode.ABSOLUTE_X,  // ABSOLUTE_Y
]


let CODE_TO_OPERATION = [
    UInt8(0b10101): Operation.LDA
]
