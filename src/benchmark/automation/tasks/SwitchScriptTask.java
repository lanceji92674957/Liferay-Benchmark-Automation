/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package benchmark.automation.tasks;

import benchmark.automation.util.PropertiesUtil;
import benchmark.automation.util.StringUtil;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

/**
 * @author tom
 */
public class SwitchScriptTask extends Task {

	@Override
    public void execute() throws BuildException {
		try {
			Map<String, Settings> scriptMap = initMap();

			verifyInputs(scriptMap);

			replaceEnv(_filePath);

			appendScript(scriptMap, _filePath, _script);
		}
		catch (IOException ex) {
			throw new BuildException(ex.getMessage());
		}
    }

	private void appendScript(
			Map<String, Settings> scriptMap, Path filePath, String script)
		throws IOException {

		StringBuilder sb = new StringBuilder();

		sb.append(
			"database.sample.data.properties=database/sample-data/"
				+ "sample-sql-builder-");
		sb.append(script);
		sb.append(".properties\n");
		sb.append("database.name=lportal_");
		sb.append(script);
		sb.append('\n');
		sb.append("grinder.script=script/netty/");

		Settings scriptSettings = scriptMap.get(script);

		sb.append(scriptSettings.getFullName());
		sb.append(".py");
		sb.append('\n');
		sb.append("sample.archive.dir=archive/");
		sb.append(script);
		sb.append('\n');
		sb.append("agent.new.thread.model.init.permits=");
		sb.append(scriptSettings.getInitPermits());
		sb.append('\n');
		sb.append("sample.heap.enabled=");
		sb.append(scriptSettings.getSampleHeap());
		sb.append('\n');
		sb.append("sample.heap.liveonly=");
		sb.append(scriptSettings.getSampleHeap());

		try (Writer writer = new FileWriter(filePath.toFile(), true)) {
			writer.append(sb);
		}
	}

	 private Map<String, Settings> initMap() throws IOException {
		Map<String, Settings> scriptMap = new HashMap<>();

		Properties scriptProperties = PropertiesUtil.loadProperties(
			Paths.get("script.properties"));

		Settings assetSettings =
			new Settings(
				"assetpublisher", scriptProperties.getProperty("asset"),
				scriptProperties.getProperty("sample.heap"));

		scriptMap.put("asset", assetSettings);

		Settings blogSettings =
			new Settings(
				"blog", scriptProperties.getProperty("blog"),
				scriptProperties.getProperty("sample.heap"));

		scriptMap.put("blog", blogSettings);

		Settings contentSettings =
			new Settings(
				"content", scriptProperties.getProperty("content"),
				scriptProperties.getProperty("sample.heap"));

		scriptMap.put("content", contentSettings);

		Settings loginSettings =
			new Settings(
				"login", scriptProperties.getProperty("login"),
				scriptProperties.getProperty("sample.heap"));

		scriptMap.put("login", loginSettings);

		Settings mbSettings =
			new Settings(
				"messageboard", scriptProperties.getProperty("mb"),
				scriptProperties.getProperty("sample.heap"));

		scriptMap.put("mb", mbSettings);

		Settings wikiSettings =
			new Settings("wiki", scriptProperties.getProperty("wiki"),
				scriptProperties.getProperty("sample.heap"));

		scriptMap.put("wiki", wikiSettings);

		Settings dlSettings =
			new Settings(
				"documentlibrary", scriptProperties.getProperty("dl"),
				scriptProperties.getProperty("sample.heap"));

		scriptMap.put("dl", dlSettings);

		return scriptMap;
	}

	private void replaceEnv(Path filePath) throws IOException {
		String content = new String(Files.readAllBytes(filePath));

		content = StringUtil.replace(content, "qa1", _environment);

		Files.write(
			filePath, Arrays.asList(content), StandardCharsets.UTF_8);
	}

    public void setEnv(String env) {
        _environment = env;
    }

	public void setFilePath(String filePath) {
		_filePath = Paths.get(filePath);
	}

	public void setScript(String script) {
        _script = script;
    }

	private void verifyInputs(Map<String, Settings> scriptMap)
		throws IOException {

		if (!scriptMap.containsKey(_script)) {
			throw new IOException(_script + " is not a valid script!");
		}

		if (Files.notExists(_filePath)) {
			throw new IOException(_filePath + " does not exist!");
		}
	}

	private String _environment;
	private Path _filePath;
	private String _script;

	private class Settings {
		public Settings(
			String fullName, String initPermits, String sampleHeap) {

			_fullName = fullName;
			_initPermits = initPermits;
			_sampleHeap = sampleHeap;
		}

		public String getFullName() {
			return _fullName;
		}

		public String getInitPermits() {
			return _initPermits;
		}

		public String getSampleHeap() {
			return _sampleHeap;
		}

		private final String _fullName;
		private final String _initPermits;
		private final String _sampleHeap;
	}
}
