if ((NOT GENERATE_EL6) AND (NOT "$ENV{GENERATE_EL6}" STREQUAL ""))
  if (("$ENV{GENERATE_EL6}" STREQUAL "ON") OR ("$ENV{GENERATE_EL6}" STREQUAL "1") OR ("$ENV{GENERATE_EL6}" STREQUAL "YES"))
    set(GENERATE_EL6 ON)
  endif()
endif()

# RPM specifics
if(CPACK_GENERATOR MATCHES "RPM")
  set(CPACK_PACKAGING_INSTALL_PREFIX "/")
  if(GENERATE_EL6)
    message(STATUS "Building EL6 components")
    set(CPACK_COMPONENTS_ALL clients-el6 server-el6)
  else()
    message(STATUS "Building EL7 components")
    set(CPACK_COMPONENTS_ALL clients-el7 server-el7)
  endif()
  set(CPACK_RESOURCE_FILE_README ${CMAKE_SOURCE_DIR}/README.md)
  set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_SOURCE_DIR}/LICENSE)
elseif(CPACK_GENERATOR MATCHES "DEB")
  set(CPACK_PACKAGING_INSTALL_PREFIX "/")
  set(CPACK_COMPONENTS_ALL clients-deb server-deb)
  set(CPACK_RESOURCE_FILE_README ${CMAKE_SOURCE_DIR}/README.md)
  set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_SOURCE_DIR}/LICENSE)
elseif(CPACK_GENERATOR MATCHES "productbuild")
  set(CPACK_PACKAGING_INSTALL_PREFIX "/")
  set(CPACK_COMPONENTS_ALL clients-pm server-pm)
  set(CPACK_STRIP_FILES TRUE)
  set(CPACK_PREFLIGHT_SERVER_SCRIPT ${CMAKE_SOURCE_DIR}/packaging/osx/scripts-server/preinstall)
  set(CPACK_POSTFLIGHT_SERVER_SCRIPT ${CMAKE_SOURCE_DIR}/packaging/osx/scripts-server/postinstall)
  set(CPACK_POSTFLIGHT_CLIENTS_SCRIPT ${CMAKE_SOURCE_DIR}/packaging/osx/scripts-server/preinstall)
# Commenting out this readme file until it works within packaging
  set(CPACK_RESOURCE_FILE_README ${CMAKE_SOURCE_DIR}/packaging/osx/resources/conclusion.rtf)
  set(CPACK_PRODUCTBUILD_RESOURCES_DIR ${CMAKE_SOURCE_DIR}/packaging/osx/resources)
# Changing the path of this file as CMAKE_BINARY_DIR does not seem to be defined
  set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_BINARY_DIR}/License.txt)
  if(NOT FDB_RELEASE)
    set(prerelease_string "-PRERELEASE")
  endif()
  set(CPACK_PACKAGE_FILE_NAME "FoundationDB-${PROJECT_VERSION}${prerelease_string}")
elseif(CPACK_GENERATOR MATCHES "TGZ")
  set(CPACK_STRIP_FILES TRUE)
  set(CPACK_COMPONENTS_ALL clients-tgz server-tgz)
  set(CPACK_RESOURCE_FILE_README ${CMAKE_SOURCE_DIR}/README.md)
  set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_SOURCE_DIR}/LICENSE)
else()
  message(FATAL_ERROR "Unsupported package format ${CPACK_GENERATOR}")
endif()
