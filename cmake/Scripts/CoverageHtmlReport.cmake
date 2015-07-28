#
# Generates a coverage report in HTML format using LCOV
#

find_program( PERL perl )
if( NOT EXISTS ${PERL} )
    message( FATAL_ERROR "Couldn't find perl interpreter" )
endif()

find_program( LCOV lcov PATHS ${LCOV_PATH} )
if( NOT EXISTS ${LCOV} )
    message( FATAL_ERROR "Couldn't find lcov" )
endif()

find_program( GENHTML genhtml PATHS ${LCOV_PATH} )
if( NOT EXISTS ${LCOV} )
    message( FATAL_ERROR "Couldn't find genhtml" )
endif()

if( NOT OUTPUT_DIR )
    message( FATAL_ERROR "Output directory variable (OUTPUT_DIR) not defined" )
endif()

set( LCOV_ARGS --rc lcov_branch_coverage=1 )

set( TMP_DIR ${BINARY_DIR}/coverage_data )

# Remove old coverage data and clean
file( GLOB_RECURSE COVERAGE_DATA_FILES *.gc?? )
if( COVERAGE_DATA_FILES )
  file( REMOVE ${COVERAGE_DATA_FILES} )
endif()
file( REMOVE_RECURSE ${TMP_DIR} ${OUTPUT_DIR} )
execute_process( COMMAND ${MAKE_PROGRAM} clean )

# Compile
execute_process( COMMAND ${MAKE_PROGRAM} all )

# Prepare initial coverage data
execute_process( COMMAND ${CMAKE_COMMAND} -E make_directory ${TMP_DIR} )
execute_process( COMMAND ${PERL} ${LCOV} -z -d ${BINARY_DIR} )
execute_process( COMMAND ${PERL} ${LCOV} ${LCOV_ARGS} -c -i -d ${BINARY_DIR} -b ${SOURCE_DIR} --no-external -o ${TMP_DIR}/coverage_base.info )

# Execute unit tests to collect coverage data
execute_process( COMMAND ${MAKE_PROGRAM} test )

# Process collected coverage data
execute_process( COMMAND ${PERL} ${LCOV} ${LCOV_ARGS} -c -d ${BINARY_DIR} -b ${SOURCE_DIR} --no-external -o ${TMP_DIR}/coverage_test.info )
execute_process( COMMAND ${PERL} ${LCOV} ${LCOV_ARGS} -a ${TMP_DIR}/coverage_base.info -a ${TMP_DIR}/coverage_test.info -o ${TMP_DIR}/coverage_full.info )
execute_process( COMMAND ${PERL} ${LCOV} ${LCOV_ARGS} -e ${TMP_DIR}/coverage_full.info -o ${TMP_DIR}/coverage_stripped.info ${SOURCE_DIR}* )

# Generate HTML report
execute_process( COMMAND ${CMAKE_COMMAND} -E make_directory ${OUTPUT_DIR} )
execute_process( COMMAND ${PERL} ${GENHTML} ${LCOV_ARGS} -s ${TMP_DIR}/coverage_stripped.info -o ${OUTPUT_DIR} --demangle-cpp --title "CppUTest" )

message( "Coverage HTML report succesfully generated in ${OUTPUT_DIR}" )
