import os
import sys
import shutil
import subprocess
import time

def runBashCommand(bashCommand):
	process = subprocess.Popen(bashCommand.split())
	time.sleep(5)

def copyProperties(filePath):
	shutil.copyfile(filePath, benchmarkDir + "/benchmark-ext.properties")

def runTest(testCase):
	print "starting: " + testCase
	copyProperties("benchmark-exts/" + testCase + "/benchmark-ext.properties")
	os.chdir(benchmarkDir)
	runBashCommand("ant stop reload-warmup-database all-portal start-visualvm all-grinder all-sample stop -Dskip.build.portal=true")
	os.chdir(currentDir)

currentDir = os.getcwd()
benchmarkDir = "/liferaysc/liferay-benchmark-ee"

for arg in sys.argv[1:]:
	runTest(arg)