package com.function;

import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.HttpMethod;
import com.microsoft.azure.functions.HttpRequestMessage;
import com.microsoft.azure.functions.HttpResponseMessage;
import com.microsoft.azure.functions.HttpStatus;
import com.microsoft.azure.functions.annotation.AuthorizationLevel;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.HttpTrigger;

import java.util.Optional;

/**
 * Hello World Azure Functions with HTTP Trigger.
 * 
 * Goals:
 * + Deploy function to Azure
 * + Call the HTTP endpoint (browser, curl, ...)
 * + Get a result
 * + Open function plan on azure, verify function executions, log files
 * + Extend function to pass a query parameter or a body and change the output to include it
 *      + e.g. Input: {your host}/api/HttpExample?name=Stefan -> Output: Hello Stefan. Nice to meet you.
 * + Run changed function locally
 * + Deploy changed function and verify
 */
public class Function {
    /**
     * This function listens at endpoint "/api/HttpExample". One way to invoke it using "curl" command in bash:
     * 1. curl {your host}/api/HttpExample
     * 2. curl "{your host}/api/HttpExample"
     */
    @FunctionName("HelloWorld")
    public HttpResponseMessage run(
            @HttpTrigger(
                name = "req",
                methods = {HttpMethod.GET, HttpMethod.POST},
                authLevel = AuthorizationLevel.ANONYMOUS)
                HttpRequestMessage<Optional<String>> request,
            final ExecutionContext context) {
        context.getLogger().info("HelloWorld Function - Java HTTP trigger processed a request.");

        return request.createResponseBuilder(HttpStatus.OK).body("Hello World. It is me. Your function.").build();
    }
}
