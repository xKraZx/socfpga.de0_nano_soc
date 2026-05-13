LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:append := "${THISDIR}/files:"

SRC_URI:append := " \
    file://CMakeLists.txt \
    file://src/transfer_benchmark.cpp \
"

S = "${UNPACKDIR}"

inherit cmake

do_install() {
    install -d ${D}${bindir}
    install -m 0755 transfer_benchmark ${D}${bindir}
}