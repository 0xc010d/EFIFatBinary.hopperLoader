#pragma once

#include <stdlib.h>
#include <libkern/OSByteOrder.h>

#define EFI_FAT_BINARY_MAGIC                0x0ef1fab9
#define EFI_FAT_BINARY_CPU_TYPE_x86         0x07
#define EFI_FAT_BINARY_CPU_TYPE_x86_64      0x01000007
#define EFI_FAT_BINARY_CPU_SUBTYPE_GENERIC  0x03

#define EFI_FAT_FILE_STRUCT_OFFSET(index)   (size_t)(20 * index + 8)

struct EFIFatEmbeddedFile {
    uint32_t cpuType;
    uint32_t cpuSubtype;
    uint32_t offset;
    uint32_t length;
    uint32_t alignment;

    EFIFatEmbeddedFile(const void *base, uint32_t index) :
            cpuType     (OSReadLittleInt32(base, EFI_FAT_FILE_STRUCT_OFFSET(index))),
            cpuSubtype  (OSReadLittleInt32(base, EFI_FAT_FILE_STRUCT_OFFSET(index) + 4)),
            offset      (OSReadLittleInt32(base, EFI_FAT_FILE_STRUCT_OFFSET(index) + 8)),
            length      (OSReadLittleInt32(base, EFI_FAT_FILE_STRUCT_OFFSET(index) + 12)),
            alignment   (OSReadLittleInt32(base, EFI_FAT_FILE_STRUCT_OFFSET(index) + 16)) { }

    const char *description() {
        if (cpuType == EFI_FAT_BINARY_CPU_TYPE_x86 && cpuSubtype == EFI_FAT_BINARY_CPU_SUBTYPE_GENERIC)
            return "Generic x86";
        if (cpuType == EFI_FAT_BINARY_CPU_TYPE_x86_64 && cpuSubtype == EFI_FAT_BINARY_CPU_SUBTYPE_GENERIC)
            return "Generic x86_64";
        return "Unknown";
    }
};
