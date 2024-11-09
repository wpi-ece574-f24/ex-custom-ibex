set(SOURCES1
	    main.c
            poly1305.c
)

# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-format")

add_executable(poly1305 ${SOURCES1})
target_link_libraries(poly1305 common)
