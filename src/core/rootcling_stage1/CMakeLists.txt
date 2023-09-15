# Copyright (C) 1995-2019, Rene Brun and Fons Rademakers.
# All rights reserved.
#
# For the licensing terms see $ROOTSYS/LICENSE.
# For the list of contributors see $ROOTSYS/README/CREDITS.

############################################################################
# CMakeLists.txt file for building ROOT core/rootcling_stage1 package
############################################################################

include(CMakePrintHelpers)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../dictgen/res)

if(WIN32)
  set_source_files_properties(src/rootcling_stage1.cxx PROPERTIES COMPILE_FLAGS "-D_WIN32 -DNOMINMAX")
else()
  if(CXX_HAS_fno_rtti)
    set_source_files_properties(src/rootcling_stage1.cxx PROPERTIES COMPILE_FLAGS "-fno-rtti")
  endif()
endif()

if(NOT builtin_clang)
  set(prefixed_link_libraries)
  foreach(dep ${CLING_DEPEND_LIBS})
    if("${dep}" MATCHES "^clang")
      set(dep "${LLVM_LIBRARY_DIR}/lib${dep}.a")
     endif()
     list(APPEND prefixed_link_libraries "${dep}")
   endforeach()
  set(LINK_LIBS "${prefixed_link_libraries}")
  link_directories("${LLVM_LIBRARY_DIR}")
endif()

foreach(lib ${CLING_LIBRARIES})
  get_target_property(transitive_libs ${lib} INTERFACE_LINK_LIBRARIES)
  if (NOT transitive_libs)
    continue()
  endif()

  set(static_transitive_libs "")
  foreach(transitive_lib ${transitive_libs})
    if("${transitive_lib}" STREQUAL "LLVM")
      # Filter our libLLVM.so and friends, see https://github.com/conda-forge/cppyy-cling-feedstock/pull/56#issuecomment-1800307065
      continue()
    else()
      list(APPEND static_transitive_libs ${transitive_lib})
    endif()
  endforeach(transitive_lib)
  # Update the target properties with the list of only static libraries.
  set_target_properties(${lib} PROPERTIES INTERFACE_LINK_LIBRARIES "${static_transitive_libs}")
  set(static_transitive_libs "")
endforeach()

llvm_map_components_to_libnames(llvm_libs AArch64AsmParser AArch64CodeGen AArch64Desc AArch64Disassembler AArch64Info AArch64Utils AggressiveInstCombine AMDGPUAsmParser AMDGPUCodeGen AMDGPUDesc AMDGPUDisassembler AMDGPUInfo AMDGPUUtils Analysis ARMAsmParser ARMCodeGen ARMDesc ARMDisassembler ARMInfo ARMUtils AsmParser AsmPrinter AVRAsmParser AVRCodeGen AVRDesc AVRDisassembler AVRInfo BinaryFormat BitReader BitstreamReader BitWriter BPFAsmParser BPFCodeGen BPFDesc BPFDisassembler BPFInfo CFGuard CFIVerify CodeGen Core Coroutines Coverage DebugInfoCodeView DebugInfoDWARF DebugInfoGSYM DebugInfoMSF DebugInfoPDB Demangle DlltoolDriver DWARFLinker DWP ExecutionEngine Exegesis ExegesisAArch64 ExegesisMips ExegesisPowerPC ExegesisX86 Extensions FileCheck FrontendOpenACC FrontendOpenMP FuzzMutate GlobalISel HexagonAsmParser HexagonCodeGen HexagonDesc HexagonDisassembler HexagonInfo InstCombine Instrumentation InterfaceStub Interpreter ipo IRReader JITLink LanaiAsmParser LanaiCodeGen LanaiDesc LanaiDisassembler LanaiInfo LibDriver LineEditor Linker LTO MC MCA MCACustomBehaviourAMDGPU MCDisassembler MCJIT MCParser MipsAsmParser MipsCodeGen MipsDesc MipsDisassembler MipsInfo MIRParser MSP430AsmParser MSP430CodeGen MSP430Desc MSP430Disassembler MSP430Info NVPTXCodeGen NVPTXDesc NVPTXInfo ObjCARCOpts Object ObjectYAML Option OrcJIT OrcShared OrcTargetProcess Passes PowerPCAsmParser PowerPCCodeGen PowerPCDesc PowerPCDisassembler PowerPCInfo ProfileData Remarks RISCVAsmParser RISCVCodeGen RISCVDesc RISCVDisassembler RISCVInfo RuntimeDyld ScalarOpts SelectionDAG SparcAsmParser SparcCodeGen SparcDesc SparcDisassembler SparcInfo Support Symbolize SystemZAsmParser SystemZCodeGen SystemZDesc SystemZDisassembler SystemZInfo TableGen TableGenGlobalISel Target TextAPI TransformUtils Vectorize WebAssemblyAsmParser WebAssemblyCodeGen WebAssemblyDesc WebAssemblyDisassembler WebAssemblyInfo WebAssemblyUtils WindowsManifest X86AsmParser X86CodeGen X86Desc X86Disassembler X86Info XCoreCodeGen XCoreDesc XCoreDisassembler XCoreInfo XRay)
ROOT_EXECUTABLE(rootcling_stage1 src/rootcling_stage1.cxx
                              $<TARGET_OBJECTS:Clib>
                              $<TARGET_OBJECTS:ClingUtils>
                              $<TARGET_OBJECTS:Dictgen>
                              $<TARGET_OBJECTS:Foundation_Stage1>
                              LIBRARIES ${CLING_LIBRARIES} ${LINK_LIBS} ${CMAKE_DL_LIBS} ${CMAKE_THREAD_LIBS_INIT} ${ROOT_ATOMIC_LIBS} ${llvm_libs} ${llvm_libs} ${llvm_libs} ${llvm_libs} ${llvm_libs} ${llvm_libs} ${llvm_libs} ${llvm_libs} ${llvm_libs} z
                              NOINSTALL)
set_target_properties(rootcling_stage1 PROPERTIES RUNTIME_OUTPUT_DIRECTORY src)
add_dependencies(rootcling_stage1 ClingUtils)
