set(CppUTestExtTests_src
    AllTests.cpp
    CodeMemoryReporterTest.cpp
    GMockTest.cpp
    GTest1Test.cpp
    IEEE754PluginTest.cpp
    IEEE754PluginTest_c.c
    MemoryReportAllocatorTest.cpp
    MemoryReporterPluginTest.cpp
    MemoryReportFormatterTest.cpp
    MockActualCallTest.cpp
    MockCheatSheetTest.cpp
    MockCallTest.cpp
    MockComparatorCopierTest.cpp
    MockExpectedCallTest.cpp
    ExpectedFunctionsListTest.cpp
    MockFailureReporterForTest.cpp
    MockFailureTest.cpp
    MockHierarchyTest.cpp
    MockNamedValueTest.cpp
    MockParameterTest.cpp
    MockPluginTest.cpp
    MockSupportTest.cpp
    MockSupport_cTestCFile.c
    MockSupport_cTest.cpp
    MockStrictOrderTest.cpp
    MockReturnValueTest.cpp
    OrderedTestTest.cpp
)

if (MINGW)
    find_package (Threads REQUIRED)
    set(THREAD_LIB "pthread")
endif (MINGW)

add_executable(CppUTestExtTests ${CppUTestExtTests_src})
if (CALLSTACK_INSPECTION AND CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(DL_LIB "dl")
endif ()
cpputest_normalize_test_output_location(CppUTestExtTests)
target_link_libraries(CppUTestExtTests CppUTest CppUTestExt ${DL_LIB} ${THREAD_LIB} ${CPPUNIT_EXTERNAL_LIBRARIES})
cpputest_buildtime_discover_tests(CppUTestExtTests)
