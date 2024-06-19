package com.mass.common.exception;

public enum ErrorCode {

    SUCCESS(0,"OK",""),
    PARAMS_ERROR(40000,"PARAMS ERROR",""),
    NULL_ERROR(40001,"PARAMS NULL",""),
    NOT_LOGIN(40100,"NO LOGIN",""),
    NO_AUTH(40101,"NO AUTH",""),
    NO_RESULT(40102,"NO RESULT",""),
    SYSTEM_ERROR(50000,"SYSTEM ERROR","");

    private final int code;
    private final String message;
    private final String description;

    ErrorCode(int code,String message,String description){
        this.code= code;
        this.message = message;
        this.description = description;
    }

    public int getCode(){
        return code;
    }

    public String getMessage(){
        return message;
    }

    public String getDescription(){
        return description;
    }

}
