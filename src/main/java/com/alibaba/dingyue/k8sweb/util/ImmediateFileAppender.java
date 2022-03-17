package com.alibaba.dingyue.k8sweb.util;

import ch.qos.logback.core.rolling.RollingFileAppender;
import ch.qos.logback.core.util.FileUtil;

import java.io.*;

/**
 * https://stackoverflow.com/questions/11829922/logback-file-appender-doesnt-flush-immediately
 */
public class ImmediateFileAppender<E> extends RollingFileAppender<E> {

    @Override
    public void openFile(String file_name) throws IOException {
        synchronized (lock) {
            File file = new File(file_name);
            if (FileUtil.createMissingParentDirectories(file)) {
                boolean result = FileUtil.createMissingParentDirectories(file);
                if (!result) {
                    addError("Failed to create parent directories for [" + file.getAbsolutePath() + "]");
                }
            }

            ImmediateResilientFileOutputStream resilientFos = new ImmediateResilientFileOutputStream(file, append);
            resilientFos.setContext(context);
            setOutputStream(resilientFos);
        }
    }

    @Override
    protected void writeOut(E event) throws IOException {
        super.writeOut(event);
    }

}
