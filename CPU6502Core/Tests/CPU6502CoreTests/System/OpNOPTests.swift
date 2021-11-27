import XCTest
@testable import CPU6502Core

final class OpNOPTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = PlainMemory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testNOPImplied() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0xEA, 0xEA])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b00110110)
    }
    
    func testNOPImpliedUndocumented() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x1A, 0x3A, 0x5A, 0x7A, 0xDA, 0xFA])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 12)
        XCTAssertEqual(actualCycle, 12)
        XCTAssertEqual(self.cpu.PC, 0x0006)
        XCTAssertEqual(self.cpu.P, 0b00110110)
    }
    
    func testNOPImmedidateUndocumented() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x80, 0x00, 0x82, 0x00, 0x89, 0x00, 0xC2, 0x00, 0xE2, 0x00])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 10)
        XCTAssertEqual(actualCycle, 10)
        XCTAssertEqual(self.cpu.PC, 0x000A)
        XCTAssertEqual(self.cpu.P, 0b00110110)
    }
    
    func testNOPZeroPageUndocumented() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x04, 0x00, 0x44, 0x00, 0x64, 0x00])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 9)
        XCTAssertEqual(actualCycle, 9)
        XCTAssertEqual(self.cpu.PC, 0x0006)
        XCTAssertEqual(self.cpu.P, 0b00110110)
    }
    
    func testNOPZeroPageXUndocumented() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x14, 0x00, 0x34, 0x00, 0x54, 0x00])
        self.memory.setBytes(start: 0x0006, bytes: [0x74, 0x00, 0xD4, 0x00, 0xF4, 0x00])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 24)
        XCTAssertEqual(actualCycle, 24)
        XCTAssertEqual(self.cpu.PC, 0x000C)
        XCTAssertEqual(self.cpu.P, 0b00110110)
    }
    
    func testNOPAbsoluteUndocumented() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x0C, 0x00, 0x00])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 4)
        XCTAssertEqual(actualCycle, 4)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b00110110)
    }
    
    func testNOPAbsoluteXUndocumented() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x1C, 0x00, 0x00, 0x3C, 0x00, 0x00, 0x5C, 0x00, 0x00])
        self.memory.setBytes(start: 0x0009, bytes: [0x7C, 0x00, 0x00, 0xDC, 0x00, 0x00, 0xFC, 0x00, 0x00])
        self.cpu.PC = 0x0000
        var actualCycle = try self.cpu.execute(memory, maxCycle: 24)
        XCTAssertEqual(actualCycle, 24)
        XCTAssertEqual(self.cpu.PC, 0x0012)
        XCTAssertEqual(self.cpu.P, 0b00110110)
        
        self.memory.setBytes(start: 0x0000, bytes: [0x1C, 0xAB, 0xCD])
        self.cpu.PC = 0x0000
        self.cpu.X = 0xFF
        actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b00110110)
    }
}
