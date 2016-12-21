#!/bin/sh
ANT_OPTS="-server -Xverify:none -XX:NewSize=128m -XX:MaxNewSize=256m -Xms1024m -Xmx1536m -XX:+UseParallelOldGC -XX:SurvivorRatio=65536 -XX:TargetSurvivorRatio=0 -XX:MaxTenuringThreshold=0 -XX:+DisableExplicitGC -Xss2m -XX:PermSize=100m -XX:MaxPermSize=256m"
JAVA_HOME=/opt/jvms/default_jdk
ANT_HOME=/opt/ant
MAVEN_HOME=/opt/maven
PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$MAVEN_HOME/bin:/home/zsyxc/localwork/bin:$GIT_CORE:$ASPECTJ_HOME/bin:$PATH
export JAVA_HOME ANT_HOME MAVEN_HOME ANT_OPTS PATH

cd /home/trunks/git/liferay-portal

git checkout master
git reset --hard
git clean -df
git pull --rebase upstream master
rm -rf `find . -name "node_modules" -type d`

cd /home/trunks/git/liferay-benchmark-ee

ant all-database
ant stop reload-warmup-database all-portal start-visualvm all-grinder all-sample stop -Dskip.build.portal=true
ant profile-cpu-tracing
ant profile-memory-profile
ant all-sql-log -Dskip.build.portal=true
ant stop reload-warmup-database all-portal start-visualvm all-grinder all-sample stop -Dskip.build.portal=true
ant stop reload-warmup-database all-portal start-visualvm all-grinder all-sample stop -Dskip.build.portal=true

cd /home/liferay/shares/benchmark/2016/DailyProfiles

mkdir $(date '+%Y-%m-%d')

cd /home/trunks/git/liferay-benchmark-ee/archive/login

ls -1 . | egrep ".*$(date '+%Y-%m-%d').*" | xargs cp -t /home/liferay/shares/benchmark/2016/DailyProfiles/$(date '+%Y-%m-%d')
