package com.mass.common.result;

import com.mass.common.base.BaseResponse;
import com.mass.common.exception.ErrorCode;

public class ResultUtils {
    /**
     * 成功请求
     * @param data
     * @param <T>
     * @return
     */
    public static <T> BaseResponse<T> success(T data){
        return new BaseResponse<T>(0,data,"ok");
    }

    /**
     * 失败调用
     * @param errorCode
     * @return
     */
    public static BaseResponse error(ErrorCode errorCode){
        return new BaseResponse(errorCode.getCode(),null, errorCode.getMessage(),errorCode.getDescription());
    }

    public static BaseResponse error(ErrorCode errorCode,String message,String description){
        return new BaseResponse(errorCode.getCode(),null,message,description );
    }

    public static BaseResponse error(int code,String message,String description){
        return new BaseResponse(code,null,message,description );
    }
}
