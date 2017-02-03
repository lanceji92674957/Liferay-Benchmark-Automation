import os
import sys
import shutil
import subprocess
import time

def runBashCommand(bashCommand):
	process = subprocess.Popen(bashCommand.split())
	process.communicate()

def copyProperties(filePath):
	shutil.copyfile(filePath, benchmarkDir + "/benchmark-ext.properties")

currentDir = os.getcwd()
benchmarkDir = "/home/trunks/git/liferay-benchmark-ee"

for arg in sys.argv[1:]:
	runBashCommand("echo starting: " + arg)
	copyProperties("benchmark-exts/" + arg + "/benchmark-ext.properties")
	os.chdir(benchmarkDir)
	runBashCommand("ant stop reload-warmup-database all-portal start-visualvm all-grinder all-sample stop -Dskip.build.portal=true")
#	runBashCommand("ant stop")
	runBashCommand("echo run finished")
	os.chdir(currentDir)
