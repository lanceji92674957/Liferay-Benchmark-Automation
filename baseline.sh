cd /home/trunks/git/liferay-portal

git checkout master
git pull --rebase upstream master

cd /home/trunks/git/liferay-benchmark-ee

ant all-database
ant stop reload-warmup-database all-portal start-visualvm all-grinder all-sample stop -Dskip.build.portal=true
ant profile-cpu-tracing
ant profile-memory-profile
ant all-sql-log -Dskip.build.portal=true