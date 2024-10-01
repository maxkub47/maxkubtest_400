#!/usr/bin/qsh
# // Licensed Materials-Property of IBM.
# //
# // 5722-SS1, 5761-SS1
# //
# // (C) Copyright IBM Corp. 2007, 2007
# //
# // US Government Users Restricted Rights-
# // Use, duplication or disclosure restricted
# // by GSA ADP schedule Contract with IBM Corp.
# //

JAVA_HOME="/QOpenSys/QIBM/ProdData/JavaVM/jdk70/32bit"
IAS_HOME="/QIBM/ProdData/OS/OSGi/shared/lib"

if (test -d /QOpenSys/QIBM/ProdData/JavaVM/jdk80/64bit)
then
JAVA_HOME="/QOpenSys/QIBM/ProdData/JavaVM/jdk80/64bit"
fi

export JAVA_HOME

IWS_INSTALL_ROOT="/QIBM/ProdData/OS/WebServices"

IWS_JAVA_CLASSPATH="\
${IWS_INSTALL_ROOT}/internal/lib/iwsadmin.jar:\
${JAVA_HOME}/lib/tools.jar:\
${IAS_HOME}/iasadmin.jar:\
${IAS_HOME}/roleadmin.jar:\
${IAS_HOME}/lwicommon.jar:\
/QIBM/ProdData/HTTPA/java/lib/hatmanager.jar:\
/QIBM/ProdData/OS400/jt400/lib/jt400Native.jar"

JAVA_EXT_DIRS="\
${JAVA_HOME}/jre/lib/ext:\
${JAVA_HOME}/jre/lib:\
/QIBM/UserData/Java400/ext"

IWS_JAVA_FLAGS="\
 -Dfile.encoding=UTF-8 \
 -Djava.ext.dirs=${JAVA_EXT_DIRS}"

${JAVA_HOME}/bin/java ${IWS_JAVA_FLAGS} -classpath ${IWS_JAVA_CLASSPATH} com.ibm.systemi.iws.scripts.ScriptProcessor "$0" "$@"
