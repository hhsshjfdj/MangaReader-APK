#!/bin/sh

# Gradle wrapper script that downloads gradle if needed
# Usage: ./gradlew [task...]

APP_NAME="Gradle"
APP_BASE_NAME=`basename "$0"`
DEFAULT_JVM_OPTS='"-Xmx64m" "-Xms64m"'

# Use the maximum available, or set MAX_FD != -1 to use that value.
MAX_FD="maximum"

warn () { echo "$*"; }
die () { echo "$*"; exit 1; }

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then JAVACMD="$JAVA_HOME/jre/sh/java"
    else JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME"; fi
else
    JAVACMD="java"
    which java >/dev/null 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH."
fi

# Increase the maximum file descriptors if we can.
if [ "$(uname)" = "Darwin" ] && [ "$MAX_FD" = "maximum" ]; then
    MAX_FD_LIMIT=`ulimit -H -n`
    if [ $? -eq 0 ]; then
        if [ "$MAX_FD" = "maximum" -o "$MAX_FD" = "max" ]; then MAX_FD="$MAX_FD_LIMIT"; fi
        ulimit -n $MAX_FD
        if [ $? -ne 0 ]; then warn "Could not set maximum file descriptor limit: $MAX_FD"; fi
    else
        warn "Could not query maximum file descriptor limit: $MAX_FD_LIMIT"
    fi
fi

# Determine the project base dir
PRG="$0"
while [ -h "$PRG" ]; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then PRG="$link"
    else PRG=`dirname "$PRG"`"/$link"
    fi
done
SAVED="`pwd`"
cd "`dirname "$PRG"`/" >/dev/null
APP_HOME="`pwd -P`"
cd "$SAVED" >/dev/null

CLASSPATH=$APP_HOME/gradle/wrapper/gradle-wrapper.jar

# Download gradle-wrapper.jar if not present
if [ ! -f "$CLASSPATH" ]; then
    echo "Downloading gradle-wrapper.jar..."
    GRADLE_VERSION="8.5"
    if command -v curl >/dev/null 2>&1; then
        curl -sL "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o /tmp/gradle-tmp.zip
    elif command -v wget >/dev/null 2>&1; then
        wget -q "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -O /tmp/gradle-tmp.zip
    fi
    if [ -f /tmp/gradle-tmp.zip ]; then
        unzip -qo /tmp/gradle-tmp.zip "gradle-${GRADLE_VERSION}/lib/gradle-wrapper-*.jar" -d /tmp/gradle-tmp/
        cp /tmp/gradle-tmp/gradle-${GRADLE_VERSION}/lib/gradle-wrapper-*.jar "$CLASSPATH"
        rm -rf /tmp/gradle-tmp.zip /tmp/gradle-tmp/
    fi
fi

if [ ! -f "$CLASSPATH" ]; then
    die "ERROR: gradle-wrapper.jar not found. Please run 'gradle wrapper' first."
fi

exec "$JAVACMD" \
    $DEFAULT_JVM_OPTS \
    $JAVA_OPTS \
    $GRADLE_OPTS \
    "-Dorg.gradle.appname=$APP_BASE_NAME" \
    -classpath "$CLASSPATH" \
    org.gradle.wrapper.GradleWrapperMain \
    "$@"
