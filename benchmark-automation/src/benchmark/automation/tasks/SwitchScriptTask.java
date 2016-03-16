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
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.tools.ant.Task;

/**
 * @author tom
 */
public class SwitchScriptTask extends Task {
    public void execute() {
		try {
			replaceEnv(_environment, _filePath);
		}
		catch (IOException ex) {
			Logger.getLogger(SwitchScriptTask.class.getName()).log(Level.SEVERE, null, ex);
		}
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

	private String _environment;
	private Path _filePath;
	private String _script;
}
