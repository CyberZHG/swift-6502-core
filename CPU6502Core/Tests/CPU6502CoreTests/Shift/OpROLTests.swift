import XCTest
@testable import CPU6502Core

final class OpROLTests: XCTestCase {
    
    var cpu = CPU6502()
    var memory = Memory()
    
    override func setUp() {
        self.cpu.reset()
        self.memory.reset()
    }
    
    func testROLAccumulator() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x2A])
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
        XCTAssertEqual(self.cpu.A, 0b10010001)
        XCTAssertEqual(self.cpu.P, 0b10110101)
        
        self.cpu.PC = 0x0000
        self.cpu.A = 0b10000000
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.A, 0b00000001)
        XCTAssertEqual(self.cpu.P, 0b00110101)
        
        self.cpu.PC = 0x0000
        self.cpu.A = 0x00
        actualCycle = try self.cpu.execute(memory, maxCycle: 2)
        XCTAssertEqual(actualCycle, 2)
        XCTAssertEqual(self.cpu.PC, 0x0001)
        XCTAssertEqual(self.cpu.A, 0x00)
        XCTAssertEqual(self.cpu.P, 0b00110110)
    }
    
    func testROLZeroPage() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x26, 0x02, 0b00110010])
        self.cpu.PC = 0x0000
        let actualCycle = try self.cpu.execute(memory, maxCycle: 5)
        XCTAssertEqual(actualCycle, 5)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b00110100)
        XCTAssertEqual(self.memory[0x0002], 0b01100100)
    }
    
    func testROLZeroPageX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x36, 0x10])
        self.memory.setBytes(start: 0x0010, bytes: [0xAB, 0b01100100])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0002)
        XCTAssertEqual(self.cpu.P, 0b10110100)
        XCTAssertEqual(self.memory[0x0011], 0b11001000)
    }
    
    func testROLAbsolute() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x2E, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0b11001000])
        self.cpu.PC = 0x0000
        self.cpu.X = 0
        let actualCycle = try self.cpu.execute(memory, maxCycle: 6)
        XCTAssertEqual(actualCycle, 6)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b10110101)
        XCTAssertEqual(self.memory[0xABCD], 0b10010001)
    }
    
    func testROLAbsoluteX() throws {
        self.memory.setBytes(start: 0x0000, bytes: [0x3E, 0xCD, 0xAB])
        self.memory.setBytes(start: 0xABCD, bytes: [0xFE, 0b10000000])
        self.memory.setBytes(start: 0xAC2D, bytes: [0xFA])
        self.cpu.PC = 0x0000
        self.cpu.X = 1
        let actualCycle = try self.cpu.execute(memory, maxCycle: 7)
        XCTAssertEqual(actualCycle, 7)
        XCTAssertEqual(self.cpu.PC, 0x0003)
        XCTAssertEqual(self.cpu.P, 0b00110101)
        XCTAssertEqual(self.memory[0xABCE], 0b00000001)
    }
    
}
