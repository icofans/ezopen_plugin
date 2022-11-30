package com.hiveintel.ezopen_plugin;

public class EZRecordFile {
    private String code;
    private String Data;
    private long callBackFuncId;

    public EZRecordFile(String code, String data) {
        this.code = code;
        Data = data;
    }

    public long getCallBackFuncId() {
        return callBackFuncId;
    }

    public void setCallBackFuncId(long callBackFuncId) {
        this.callBackFuncId = callBackFuncId;
    }
}
