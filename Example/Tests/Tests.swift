import XCTest
import SecureStorage

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        let keychainMock = KeychainServiceMock()
        let aesMock = AESMock()
        let cryptableFactoryMock = CryptableFactoryMock()
        cryptableFactoryMock.aesMock = aesMock
        let secureStorageSUT = SecureStorage(keychainService: keychainMock, cryptableFactory: cryptableFactoryMock)
        
        XCTAssertNotNil(secureStorageSUT)
    }
    
    func testSetString() {
        let keychainMock = KeychainServiceMock()
        let aesMock = AESMock()
        let cryptableFactoryMock = CryptableFactoryMock()
        cryptableFactoryMock.aesMock = aesMock
        let secureStorageSUT = SecureStorage(keychainService: keychainMock, cryptableFactory: cryptableFactoryMock)
        secureStorageSUT.set("test data", forKey: "test_key")
        
        XCTAssert(aesMock.isEncryptCalled)
        XCTAssert(keychainMock.isSetDataCalled)
    }
    
    func testSetData() {
        let keychainMock = KeychainServiceMock()
        let aesMock = AESMock()
        let cryptableFactoryMock = CryptableFactoryMock()
        cryptableFactoryMock.aesMock = aesMock
        let secureStorageSUT = SecureStorage(keychainService: keychainMock, cryptableFactory: cryptableFactoryMock)
        secureStorageSUT.set(Data("test data".utf8), forKey: "test_key")
        
        XCTAssert(aesMock.isEncryptDataCalled)
        XCTAssert(keychainMock.isSetDataCalled)
    }
    
    func testGetString() {
        let keychainMock = KeychainServiceMock()
        let aesMock = AESMock()
        let cryptableFactoryMock = CryptableFactoryMock()
        cryptableFactoryMock.aesMock = aesMock
        let secureStorageSUT = SecureStorage(keychainService: keychainMock, cryptableFactory: cryptableFactoryMock)
        secureStorageSUT.set("test data", forKey: "test_key")
        let savedData = secureStorageSUT.getString(forKey: "test_key")
        
        XCTAssert(aesMock.isDecryptCalled)
        XCTAssert(keychainMock.isGetDataCalled)
        XCTAssertNotNil(savedData)
    }
    
    func testGetData() {
        let keychainMock = KeychainServiceMock()
        let aesMock = AESMock()
        let cryptableFactoryMock = CryptableFactoryMock()
        cryptableFactoryMock.aesMock = aesMock
        let secureStorageSUT = SecureStorage(keychainService: keychainMock, cryptableFactory: cryptableFactoryMock)
        secureStorageSUT.set(Data(), forKey: "test_key")
        let savedData = secureStorageSUT.getData(forKey: "test_key")
        
        XCTAssert(aesMock.isDecryptDataCalled)
        XCTAssert(keychainMock.isGetDataCalled)
        XCTAssertNotNil(savedData)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
