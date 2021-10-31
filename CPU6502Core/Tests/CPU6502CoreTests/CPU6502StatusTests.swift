import XCTest
@testable import CPU6502Core

final class CPU6502StatusTests: XCTestCase {
    
    func testGetSetStatus() throws {
        let cpu = CPU6502()
        let initVal : UInt8 = 0b00100000
        cpu.P = initVal
        
        cpu.N = true
        XCTAssertTrue(cpu.N)
        XCTAssertEqual(cpu.P, 0b10100000)
        cpu.N = false
        XCTAssertFalse(cpu.N)
        XCTAssertEqual(cpu.P, initVal)
        
        cpu.V = true
        XCTAssertTrue(cpu.V)
        XCTAssertEqual(cpu.P, 0b01100000)
        cpu.V = false
        XCTAssertFalse(cpu.V)
        XCTAssertEqual(cpu.P, initVal)
        
        cpu.B = true
        XCTAssertTrue(cpu.B)
        XCTAssertEqual(cpu.P, 0b00110000)
        cpu.B = false
        XCTAssertFalse(cpu.B)
        XCTAssertEqual(cpu.P, initVal)
        
        cpu.D = true
        XCTAssertTrue(cpu.D)
        XCTAssertEqual(cpu.P, 0b00101000)
        cpu.D = false
        XCTAssertFalse(cpu.D)
        XCTAssertEqual(cpu.P, initVal)
        
        cpu.I = true
        XCTAssertTrue(cpu.I)
        XCTAssertEqual(cpu.P, 0b00100100)
        cpu.I = false
        XCTAssertFalse(cpu.I)
        XCTAssertEqual(cpu.P, initVal)
        
        cpu.Z = true
        XCTAssertTrue(cpu.Z)
        XCTAssertEqual(cpu.P, 0b00100010)
        cpu.Z = false
        XCTAssertFalse(cpu.Z)
        XCTAssertEqual(cpu.P, initVal)
        
        cpu.C = true
        XCTAssertTrue(cpu.C)
        XCTAssertEqual(cpu.P, 0b00100001)
        cpu.C = false
        XCTAssertFalse(cpu.C)
        XCTAssertEqual(cpu.P, initVal)
    }
}
