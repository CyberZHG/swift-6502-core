import XCTest
@testable import CPU6502Core

final class OpRLATests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testRLAZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x27, 0x00])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        let actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0b01001110)
        XCTAssertEqual(self.cpu.P, 0b00110100)
    }
    
    func testRLAZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x37, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAA, 0b10101010])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        self.cpu.C = true
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0b01010101)
        XCTAssertEqual(self.cpu.P, 0b00110101)
    }
    
    func testRLAAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x2F, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0b10101010])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        self.cpu.C = false
        self.cpu.X = 0
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0b01010100)
        XCTAssertEqual(self.cpu.P, 0b00110101)
    }
    
    func testRLAAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x3F, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0b01000000])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0b10000000)
        XCTAssertEqual(self.cpu.P, 0b10110100)
    }
    
    func testRLAAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x3B, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0b01000000])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        self.cpu.Y = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0b10000000)
        XCTAssertEqual(self.cpu.P, 0b10110100)
    }
    
    func testRLAIndexedIndirect() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x23, 0x40])
        self.memory.setBytes(start: 0x0041, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x00])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 8)
        XCTAssertEqual(actualCycle, 8)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00110110)
    }
    
    func testRLAIndirectIndexed() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x33, 0x40])
        self.memory.setBytes(start: 0x0040, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x42, 0xFF])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xFF
        self.cpu.Y = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 8)
        XCTAssertEqual(actualCycle, 8)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0xFE)
        XCTAssertEqual(self.cpu.P, 0b10110101)
    }
    
}
