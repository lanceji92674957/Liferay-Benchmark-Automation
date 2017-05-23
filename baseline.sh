#!/bin/sh
ANT_OPTS="-server -Xverify:none -XX:NewSize=128m -XX:MaxNewSize=256m -Xms1024m -Xmx3g -XX:+UseParallelOldGC -XX:SurvivorRatio=65536 -XX:TargetSurvivorRatio=0 -XX:MaxTenuringThreshold=0 -XX:+DisableExplicitGC -Xss2m -XX:PermSize=100m -XX:MaxPermSize=256m"
JAVA_HOME=/opt/jvms/default_jdk
ANT_HOME=/opt/ant
MAVEN_HOME=/opt/maven
PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$MAVEN_HOME/bin:/home/zsyxc/localwork/bin:$GIT_CORE:$ASPECTJ_HOME/bin:$PATH
DATE=$(date --date="next day" '+%Y-%m-%d')
export JAVA_HOME ANT_HOME MAVEN_HOME ANT_OPTS PATH

cd /home/trunks/git/Liferay-Benchmark-Automation

ant switch-to-default-script

./pull-upstream.sh

#ant reboot-agents

cd /home/trunks/git/liferay-benchmark-ee

ant stop

set -e

ant all-database -Dclean.node.modules=true

echo ***********Finish all database****************

ant stop reload-warmup-database all-portal start-visualvm all-grinder all-sample stop -Dskip.build.portal=true

echo ****************Finish first run*************************

#ant profile-cpu-tracing
#ant profile-memory-profile
#ant all-sql-log -Dskip.build.portal=true

mkdir /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE

cd /home/trunks/git/liferay-benchmark-ee/archive/login

#ls -1 . | egrep ".*$(date '+%Y-%m-%d').*" | xargs cp -t /home/liferay/shares/benchmark/2016/DailyProfiles/$(date '+%Y-%m-%d')
find . -mmin -720 -type f | xargs cp -t /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE
cp -f /home/liferay/cronout.log /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE

cd /home/trunks/git/liferay-benchmark-ee

ant stop reload-warmup-database all-portal start-visualvm all-grinder all-sample stop -Dskip.build.portal=true
#ant stop reload-warmup-database all-portal start-visualvm all-grinder all-sample stop -Dskip.build.portal=true
ant stop reload-warmup-database all-portal start-visualvm all-grinder all-sample stop -Dskip.build.portal=true -Dwith.cpu.sampling=true

cd /home/trunks/git/liferay-benchmark-ee/archive/login

find . -mmin -720 -type f | xargs cp -t /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE

cd /home/trunks/git/Liferay-Benchmark-Automation

echo ************Start content*******************
./content.sh
mkdir /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE/content
cd /home/trunks/git/liferay-benchmark-ee/archive/content
find . -mmin -720 -type f | xargs cp -t /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE/content
cp -f /home/liferay/cronout.log /home/liferay/shares/benchmark/2016/DailyProfiles/$(date '+%Y-%m-%d')
echo **************Finished content****************

echo ************Start Asset****************
cd /home/trunks/git/Liferay-Benchmark-Automation

./asset.sh
mkdir /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE/asset
cd /home/trunks/git/liferay-benchmark-ee/archive/asset
find . -mmin -720 -type f | xargs cp -t /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE/asset
cp -f /home/liferay/cronout.log /home/liferay/shares/benchmark/2016/DailyProfiles/$(date '+%Y-%m-%d')
echo ************Finished asset*****************

echo ************Start DL****************
cd /home/trunks/git/Liferay-Benchmark-Automation

./dl.sh
mkdir /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE/dl
cd /home/trunks/git/liferay-benchmark-ee/archive/dl
find . -mmin -720 -type f | xargs cp -t /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE/dl
cp -f /home/liferay/cronout.log /home/liferay/shares/benchmark/2016/DailyProfiles/$(date '+%Y-%m-%d')
echo ************Finished DL*****************

echo ************Start MB****************
cd /home/trunks/git/Liferay-Benchmark-Automation

./mb.sh
mkdir /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE/mb
cd /home/trunks/git/liferay-benchmark-ee/archive/mb
find . -mmin -720 -type f | xargs cp -t /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE/mb
cp -f /home/liferay/cronout.log /home/liferay/shares/benchmark/2016/DailyProfiles/$(date '+%Y-%m-%d')
echo ************Finished MB*****************


echo ************Start Blog****************
cd /home/trunks/git/Liferay-Benchmark-Automation

./blog.sh
mkdir /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE/blog
cd /home/trunks/git/liferay-benchmark-ee/archive/blog
find . -mmin -720 -type f | xargs cp -t /home/liferay/shares/benchmark/2016/DailyProfiles/$DATE/blog
cp -f /home/liferay/cronout.log /home/liferay/shares/benchmark/2016/DailyProfiles/$(date '+%Y-%m-%d')
echo ************Finished Blog*****************

