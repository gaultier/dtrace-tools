# Ubuntu
apt update
apt install -y git cmake make g++ perf-tools-unstable perl sudo linux-tools-virtual openjdk13-dbg openjdk13-jdk

mkdir /root/code
cd /root/code
git clone --depth 1 https://github.com/brendangregg/FlameGraph.git
git clone --depth 1 https://github.com/jvm-profiling-tools/perf-map-agent
export JAVA_HOME=/home/ubuntu/jdk-15.0.1/
$JAVA_HOME/bin/javac -g -parameters Http.java
$JAVA_HOME/bin/java Main &
cd perf-map-agent
cmake -DCMAKE_PREFIX_PATH=/opt/java/openjdk/ .
make -j`nproc`
cd bin
sh -c 'for i in `seq 1 10000`; do curl -s "http://localhost:8081/test" -o /dev/null; done;' &
FLAMEGRAPH_DIR=/root/code/FlameGraph ./perf-java-flames `pgrep java`


# Alpine
apk add sudo bash openjdk11 wrk rsync linux-tools
export JAVA_OPTS="-XX:+PreserveFramePointer  -XX:+UnlockDiagnosticVMOptions -XX:+DebugNonSafepoints -XX:InlineSmallCode=500" # -XX:+ExtendedDTraceProbes
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk/
$JAVA_HOME/bin/javac -g -parameters Http.java
$JAVA_HOME/bin/java Main &
cmake .
make -j`nproc`
cd bin
wrk --duration 20s http://localhost:8081/test &
FLAMEGRAPH_DIR=~/FlameGraph ./perf-java-flames `pgrep java`
