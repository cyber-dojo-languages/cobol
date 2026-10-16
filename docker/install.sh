#!/bin/sh -eu

# GnuCOBOL is one alpine package, named without a version, so installing it
# from the floating base image takes whichever release that alpine carries.
# The version is therefore resolved when the image is built rather than
# written down here, where it would pin the image to the release that was
# current when someone last edited this file.
#
# cobc compiles COBOL by translating it to C and handing that to a C compiler,
# so the package brings gcc and the C headers with it. cobc -x needs both at
# every compile, which is every time a kata runs its tests.
apk update
apk add gnucobol

# Recorded in /versions.json and read by the install.sh of images built on
# this one, so both state the version this image actually holds. The compiler is asked
# rather than the package index, so a version recorded here is one the image
# can run. Its first line reads "cobc (GnuCOBOL) 3.2.0".
readonly GNUCOBOL_VERSION=$(cobc --version | sed --quiet '1s/^cobc (GnuCOBOL) \([0-9][0-9.]*\).*/\1/p')

# An empty version means the banner has been reworded rather than that cobc
# has gone, so stop here and say so instead of recording nothing.
if [ -z "${GNUCOBOL_VERSION}" ]; then
  echo 'Could not read a version from cobc --version' >&2
  exit 1
fi

# The language is named COBOL, as a learner knows it, though the version is
# GnuCOBOL's: that is the compiler which implements it here.
cat > /versions.json <<EOF
{
  "language": {
    "name": "COBOL",
    "version": "${GNUCOBOL_VERSION}"
  },
  "test_frameworks": []
}
EOF

rm -rf /var/cache/apk/*
