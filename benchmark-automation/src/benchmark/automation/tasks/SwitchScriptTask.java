/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package benchmark.automation.tasks;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import org.apache.tools.ant.Task;

/**
 * @author tom
 */
public class SwitchScriptTask extends Task {
    public void execute() {
		try {
			Map<String, String> scriptMap = initMap();

			verifyInputs(scriptMap);

			replaceEnv(_environment, _filePath);

			appendScript(scriptMap, _filePath, _script);
		}
		catch (IOException ex) {
			System.out.println("*****Script switch failed******* ");
			System.out.println(ex.getMessage());
		}
    }

	public void appendScript(
			Map<String, String> scriptMap, Path filePath, String script)
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
		sb.append("grinder.script=script/");
		sb.append(scriptMap.get(script));
		sb.append(".py");
		sb.append('\n');
		sb.append("sample.archive.dir=archive/");
		sb.append(script);

		Files.write(
			filePath, Arrays.asList(sb.toString()), StandardOpenOption.APPEND);
	}

	public Map<String, String> initMap() {
		Map<String, String> scriptMap = new HashMap<>();

		scriptMap.put("asset", "assetpublisher");
		scriptMap.put("blog", "blog");
		scriptMap.put("content", "content");
		scriptMap.put("login", "login");
		scriptMap.put("mb", "messageboard");
		scriptMap.put("wiki", "wiki");
		scriptMap.put("dl", "documentlibrary");

		return scriptMap;
	}

	public void replaceEnv(String env, Path filePath) throws IOException {
		String content = new String(Files.readAllBytes(filePath));

		content = content.replace("qa1", _environment);

		Files.write(
			filePath, Arrays.asList(content), Charset.defaultCharset());
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

	public void verifyInputs(Map<String, String> scriptMap) throws IOException {
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
}
