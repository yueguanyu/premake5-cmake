[Premake](https://github.com/premake/premake-core) extension for supporting [cmake](http://www.cmake.org/) cmake

### Features ###

* Support for C/C++ language projects
* Work in progress

### Install ###
In your project directory:
```bash
git clone https://github.com/ovenpasta/premake5-cmake cmake
```
add this line to your premake5.lua:
```lua
require("cmake")
```

### Configure vcpkg path ###
configure your vcpkg executeable path env as VCPKG_EXEC_PATH
```shell
set VCPKG_EXEC_PATH=you/vcpkg/path/to/executable/vcpkg.exe
```

### Install dependency use vcpkg ###
```shell
vcpkg install example:x64-windows
```

### Add dependency with dependson key words in premake5.lua ###

project "example"
    dependson {"protobuf", "curl"} -- used for cmake include and find_package...

### Usage ###

Simply generate your project using the `cmake` action:
```bash
premake5 cmake
```

It will generate one root CMakeLists.txt, as well as one sub CMakeLists.txt for each subproject.

In CMakeLists.txt for project, search will automate use vcpkg install info to add cmake find_package and target_link_libraries info to it.
Such as:
```cmake
find_package(protobuf CONFIG REQUIRED)
find_package(CURL CONFIG REQUIRED)
add_executable(exp "**.cpp")
target_link_libraries(network PRIVATE protobuf::libprotoc protobuf::libprotobuf protobuf::libprotobuf-lite)
target_link_libraries(network PRIVATE CURL::libcurl)
```
