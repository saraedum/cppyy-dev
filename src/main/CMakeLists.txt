# Copyright (C) 1995-2019, Rene Brun and Fons Rademakers.
# All rights reserved.
#
# For the licensing terms see $ROOTSYS/LICENSE.
# For the list of contributors see $ROOTSYS/README/CREDITS.

############################################################################
# CMakeLists.txt file for building ROOT main package
# @author Pere Mato, CERN
############################################################################

if(MSVC)
  set(root_exports "/EXPORT:_Init_thread_abort /EXPORT:_Init_thread_epoch
      /EXPORT:_Init_thread_footer /EXPORT:_Init_thread_header /EXPORT:_tls_index
      /STACK:4000000")
endif()

##---CreateHaddCommandLineOptions------------------------------------------------------------------
if(NOT MSVC)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CLING_CXXFLAGS} -Wno-unused-parameter")
else()
  set_source_files_properties(src/rootcling.cxx PROPERTIES COMPILE_FLAGS "-DNOMINMAX -D_XKEYCHECK_H")
endif()

llvm_map_components_to_libnames(llvm_libs AArch64AsmParser AArch64CodeGen AArch64Desc AArch64Disassembler AArch64Info AArch64Utils AggressiveInstCombine AMDGPUAsmParser AMDGPUCodeGen AMDGPUDesc AMDGPUDisassembler AMDGPUInfo AMDGPUUtils Analysis ARMAsmParser ARMCodeGen ARMDesc ARMDisassembler ARMInfo ARMUtils AsmParser AsmPrinter AVRAsmParser AVRCodeGen AVRDesc AVRDisassembler AVRInfo BinaryFormat BitReader BitstreamReader BitWriter BPFAsmParser BPFCodeGen BPFDesc BPFDisassembler BPFInfo CFGuard CFIVerify CodeGen Core Coroutines Coverage DebugInfoCodeView DebugInfoDWARF DebugInfoGSYM DebugInfoMSF DebugInfoPDB Demangle DlltoolDriver DWARFLinker DWP ExecutionEngine Exegesis ExegesisAArch64 ExegesisMips ExegesisPowerPC ExegesisX86 Extensions FileCheck FrontendOpenACC FrontendOpenMP FuzzMutate GlobalISel HexagonAsmParser HexagonCodeGen HexagonDesc HexagonDisassembler HexagonInfo InstCombine Instrumentation InterfaceStub Interpreter ipo IRReader JITLink LanaiAsmParser LanaiCodeGen LanaiDesc LanaiDisassembler LanaiInfo LibDriver LineEditor Linker LTO MC MCA MCACustomBehaviourAMDGPU MCDisassembler MCJIT MCParser MipsAsmParser MipsCodeGen MipsDesc MipsDisassembler MipsInfo MIRParser MSP430AsmParser MSP430CodeGen MSP430Desc MSP430Disassembler MSP430Info NVPTXCodeGen NVPTXDesc NVPTXInfo ObjCARCOpts Object ObjectYAML Option OrcJIT OrcShared OrcTargetProcess Passes PowerPCAsmParser PowerPCCodeGen PowerPCDesc PowerPCDisassembler PowerPCInfo ProfileData Remarks RISCVAsmParser RISCVCodeGen RISCVDesc RISCVDisassembler RISCVInfo RuntimeDyld ScalarOpts SelectionDAG SparcAsmParser SparcCodeGen SparcDesc SparcDisassembler SparcInfo Support Symbolize SystemZAsmParser SystemZCodeGen SystemZDesc SystemZDisassembler SystemZInfo TableGen TableGenGlobalISel Target TextAPI TransformUtils Vectorize WebAssemblyAsmParser WebAssemblyCodeGen WebAssemblyDesc WebAssemblyDisassembler WebAssemblyInfo WebAssemblyUtils WindowsManifest X86AsmParser X86CodeGen X86Desc X86Disassembler X86Info XCoreCodeGen XCoreDesc XCoreDisassembler XCoreInfo XRay)

ROOT_EXECUTABLE(rootcling src/rootcling.cxx LIBRARIES RIOLegacy Cling CoreLegacy ${llvm_libs} ${llvm_libs} ${llvm_libs} ${llvm_libs} ${llvm_libs} ${llvm_libs} ${llvm_libs} ${llvm_libs} ${llvm_libs} z dl)

target_include_directories(rootcling PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/../core/metacling/res
        ${CMAKE_CURRENT_SOURCE_DIR}/../core/dictgen/res
        ${CMAKE_CURRENT_SOURCE_DIR}/../io/rootpcm/res)
if(WIN32)
  set_target_properties(rootcling PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS 1)
endif()

# Create aliases: rootcint, genreflex.
if(WIN32)
  add_custom_command(TARGET rootcling POST_BUILD
                     COMMAND copy /y rootcling.exe rootcint.exe
                     COMMAND copy /y rootcling.exe genreflex.exe
                     WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
else()
  add_custom_command(TARGET rootcling POST_BUILD
                     COMMAND ln -f rootcling rootcint
                     COMMAND ln -f rootcling genreflex
                     WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
endif()
set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES
                         "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/rootcint;${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/genreflex")

if(CMAKE_HOST_UNIX)
  install(CODE "execute_process(COMMAND ln -f rootcling rootcint WORKING_DIRECTORY \$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR})" COMPONENT applications)
  install(CODE "execute_process(COMMAND ln -f rootcling genreflex WORKING_DIRECTORY \$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR})" COMPONENT applications)
else()
  if(MSVC)
    install(PROGRAMS  ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/rootcling.exe DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT applications)
    install(PROGRAMS  ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/rootcint.exe DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT applications)
    install(PROGRAMS  ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/genreflex.exe DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT applications)
  else()
    install(PROGRAMS  ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/rootcint
                      ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/genreflex
                      ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/rlibmap
                      DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT applications)
  endif()
endif()
