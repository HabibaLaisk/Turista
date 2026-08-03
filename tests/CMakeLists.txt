find_package(Qt6 REQUIRED COMPONENTS
    Core
    Test
    Sql
    Qml
    Network
)

qt_add_executable(tst_Turista
    tst_Turista.cpp

    ../UserManager.cpp
    ../UserManager.h

    ../services/ApiService.cpp
    ../services/ApiService.h

    ../models/SearchResult.h
)

target_include_directories(tst_Turista
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/..
        ${CMAKE_CURRENT_SOURCE_DIR}/../services
        ${CMAKE_CURRENT_SOURCE_DIR}/../models
)

target_link_libraries(tst_Turista
    PRIVATE
        Qt6::Core
        Qt6::Test
        Qt6::Sql
        Qt6::Qml
        Qt6::Network
)

enable_testing()

add_test(
    NAME TuristaUnitTests
    COMMAND tst_Turista
)