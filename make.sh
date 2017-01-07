#!/bin/sh
FONTDIR="/vagrant/fonts"
TMPDIR="/home/vagrant/fonts"
LOGFILE=${FONTDIR}/build_`date +%Y%m%d_%H%M%S`.log

mkdir ${FONTDIR} ${TMPDIR} 2>/dev/null

# Download Inconsolata
if [ ! -e "${TMPDIR}/Inconsolata-Regular.ttf" -o ! -e "${TMPDIR}/Inconsolata-Bold.ttf" ]; then
  echo "--> Getting Inconsolata font..."
  curl -L https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Regular.ttf \
    -o ${TMPDIR}/Inconsolata-Regular.ttf || exit 1
  curl -L https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Bold.ttf \
    -o ${TMPDIR}/Inconsolata-Bold.ttf || exit 1
fi

# Download Ricty script
if [ ! -d "${TMPDIR}/ricty" ]; then
  echo "--> Getting Ricty script..."
  mkdir ${TMPDIR}/ricty
  curl http://www.rs.tus.ac.jp/yyusa/ricty/ricty_generator.sh -o ${TMPDIR}/ricty/ricty_generator.sh || exit 1
  curl http://www.rs.tus.ac.jp/yyusa/ricty/os2version_reviser.sh -o ${TMPDIR}/ricty/os2version_reviser.sh || exit 1
fi

# Checkout M+ font
cd ${TMPDIR}
if [ -d "mplus_outline_fonts" ]; then
  echo "--> Updating mplus_outline_fonts..."
  (cd mplus_outline_fonts && cvs -q update -d) || exit 1
else
  echo "--> Checking out mplus_outline_fonts..."
  cvs -q -d :pserver:anonymous@cvs.osdn.jp:/cvsroot/mplus-fonts checkout mplus_outline_fonts || exit 1
fi

# Checkout the patches for Migu
if [ -d "mixfont-mplus-ipa" ]; then
  echo "--> Updating mixfont-mplus-ipa..."
  (cd mixfont-mplus-ipa && cvs -q update -d) || exit 1
else
  echo "--> Checking out mixfont-mplus-ipa..."
  cvs -q -d :pserver:anonymous@cvs.osdn.jp:/cvsroot/mix-mplus-ipa checkout mixfont-mplus-ipa || exit 1
fi
cp -pr mixfont-mplus-ipa/mplus_outline_fonts/mig.d mplus_outline_fonts/

# Build Migu
cd ${TMPDIR}/mplus_outline_fonts
if [ ! -e "${FONTDIR}/migu-1m-regular.ttf" ]; then
  echo "--> Building Migu fonts..."
  (sh mig.d/migu_build.sh && sh mig.d/migu_merge.sh) | tee -a ${LOGFILE} 2>&1
  cp migu-*.ttf ${FONTDIR}
fi

# Build Ricty
cd ${TMPDIR}/ricty
if [ ! -e "${FONTDIR}/Ricty-Regular.ttf" ]; then
  echo "--> Building Ricty fonts..."
  sh ricty_generator.sh ${TMPDIR}/Inconsolata-{Regular,Bold}.ttf ${FONTDIR}/migu-1m-{regular,bold}.ttf | tee -a ${LOGFILE} 2>&1
  sh os2version_reviser.sh Ricty*.ttf
  cp Ricty*.ttf ${FONTDIR}
fi
