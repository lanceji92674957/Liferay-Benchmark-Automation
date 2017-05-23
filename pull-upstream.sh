#!/bin/sh
ANT_OPTS="-server -Xverify:none -XX:NewSize=128m -XX:MaxNewSize=256m -Xms1024m -Xmx3g -XX:+UseParallelOldGC -XX:SurvivorRatio=65536 -XX:TargetSurvivorRatio=0 -XX:MaxTenuringThreshold=0 -XX:+DisableExplicitGC -Xss2m -XX:PermSize=100m -XX:MaxPermSize=256m"
JAVA_HOME=/opt/jvms/default_jdk
ANT_HOME=/opt/ant
MAVEN_HOME=/opt/maven
PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$MAVEN_HOME/bin:/home/zsyxc/localwork/bin:$GIT_CORE:$ASPECTJ_HOME/bin:$PATH
export JAVA_HOME ANT_HOME MAVEN_HOME ANT_OPTS PATH

cd /home/trunks/git/liferay-portal

echo *********Pulling portal upstrem*******************

git reset --hard
git clean -df
git checkout master
git pull --rebase upstream master

rm -rf `find . -name "node_modules" -type d`

#echo ***************cd to journal directory****************

#cd modules/apps/web-experience/journal

#echo *************Pulling journal upstream**************

#git reset --hard
#git clean -df
#git pull upstream master

cd /home/trunks/git/liferay-benchmark-ee

git pull --rebase upstream master
