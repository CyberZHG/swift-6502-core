import XCTest
@testable import CPU6502Core

final class OpASLTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testASLAccumulator() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x0A])
        self.cpu.PC = 0x0000
        self.cpu.A = 0b00110010
        var actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.A, 0b01100100)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        
        self.cpu.PC = 0x0000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.A, 0b11001000)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        
        self.cpu.PC = 0x0000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.A, 0b10010000)
        XCTAssertEqual(self.cpu.P, 0b10110101)
        
        self.cpu.PC = 0x0000
        self.cpu.A = 0b10000000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00110111)
    }
    
    func testASLZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x06, 0x02, 0b00110010])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.memory[0x0002], 0b01100100)
    }
    
    func testASLZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x16, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAB, 0b01100100])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.memory[0x0011], 0b11001000)
    }
    
    func testASLAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x0E, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0b11001000])
        self.cpu.PC = 0x0000
        self.cpu.X = 0
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b10110101)
        XCTAssertEqual(self.memory[0xABCD], 0b10010000)
    }
    
    func testASLAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x1E, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0b10000000])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b00110111)
        XCTAssertEqual(self.memory[0xABCE], 0x00)
    }
    
}
