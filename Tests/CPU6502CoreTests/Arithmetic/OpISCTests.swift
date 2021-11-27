import XCTest
@testable import CPU6502Core

final class OpISPTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testISPZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xE7, 0x00])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xE9
        let actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b00110101)
        XCTAssertEqual(self.memory[0x0000], 0xE8)
    }
    
    func testISPZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xF7, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAA, 0xC7])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xC8
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b00110111)
        XCTAssertEqual(self.memory[0x0011], 0xC8)
    }
    
    func testISPAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xEF, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xC7])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xC7
        self.cpu.X = 0
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.memory[0xABCD], 0xC8)
    }
    
    func testISPAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xFF, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.memory[0xABCE], 0xFD)
    }
    
    func testISPAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xFB, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.memory[0xABCE], 0xFD)
    }
    
    func testISPIndexedIndirect() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xE3, 0x40])
        self.memory.setBytes(start: 0x0041, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFF])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 8)
        XCTAssertEqual(actualCycle, 8)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b00110111)
        XCTAssertEqual(self.memory[0xABCD], 0x00)
    }
    
    func testISPIndirectIndexed() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xF3, 0x40])
        self.memory.setBytes(start: 0x0040, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x42, 0x43])
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 8)
        XCTAssertEqual(actualCycle, 8)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.memory[0xABCE], 0x44)
    }
    
}
