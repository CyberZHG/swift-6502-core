import XCTest
@testable import CPU6502Core

final class OpSRETests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testSREZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x47, 0x00])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x23)
        XCTAssertEqual(self.cpu.P, 0b00110101)
        XCTAssertEqual(self.memory[0x0000], 0x23)
    }
    
    func testSREZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x57, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAA, 0b10101010])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0b01010101)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.memory[0x0011], 0b01010101)
    }
    
    func testSREAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x4F, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0b10101010])
        self.cpu.PC = 0x0000
        self.cpu.X = 0
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0b01010101)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.memory[0xABCD], 0b01010101)
    }
    
    func testSREAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x5F, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0b01000000])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0b00100000)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.memory[0xABCE], 0b00100000)
    }
    
    func testSREAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x5B, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0b01000000])
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0b00100000)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.memory[0xABCE], 0b00100000)
    }
    
    func testSREIndexedIndirect() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x43, 0x40])
        self.memory.setBytes(start: 0x0041, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x00])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 8)
        XCTAssertEqual(actualCycle, 8)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        XCTAssertEqual(self.memory[0xABCD], 0b00000000)
    }
    
    func testSREIndirectIndexed() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x53, 0x40])
        self.memory.setBytes(start: 0x0040, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x42, 0xFF])
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 8)
        XCTAssertEqual(actualCycle, 8)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0b01111111)
        XCTAssertEqual(self.cpu.P, 0b00110101)
        XCTAssertEqual(self.memory[0xABCE], 0b01111111)
    }
    
}
