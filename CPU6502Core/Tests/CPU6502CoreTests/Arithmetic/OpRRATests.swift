import XCTest
@testable import CPU6502Core

final class OpRRATests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testRRAZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x67, 0x00])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xE9
        let actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x1D)
        XCTAssertEqual(self.cpu.P, 0b00110101)
    }
    
    func testRRAZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x77, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAA, 0xC7])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xC8
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x2C)
        XCTAssertEqual(self.cpu.P, 0b00110101)
    }
    
    func testRRAAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x6F, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xC7])
        self.cpu.PC = 0x0000
        self.cpu.A = 0xC7
        self.cpu.X = 0
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0x2B)
        XCTAssertEqual(self.cpu.P, 0b00110101)
    }
    
    func testRRAAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x7F, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0x7E)
        XCTAssertEqual(self.cpu.P, 0b00110100)
    }
    
    func testRRAAbsoluteY() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x7B, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0xFC])
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.A, 0x7E)
        XCTAssertEqual(self.cpu.P, 0b00110100)
    }
    
    func testRRAIndexedIndirect() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x63, 0x40])
        self.memory.setBytes(start: 0x0041, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFF])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 8)
        XCTAssertEqual(actualCycle, 8)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x80)
        XCTAssertEqual(self.cpu.P, 0b11110100)
    }
    
    func testRRAIndirectIndexed() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x73, 0x40])
        self.memory.setBytes(start: 0x0040, bytes: [0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0x42, 0x43])
        self.cpu.PC = 0x0000
        self.cpu.Y = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 8)
        XCTAssertEqual(actualCycle, 8)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.A, 0x22)
        XCTAssertEqual(self.cpu.P, 0b00110100)
    }
    
}
