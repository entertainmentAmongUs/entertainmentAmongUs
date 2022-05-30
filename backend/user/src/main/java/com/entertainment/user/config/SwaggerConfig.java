package com.entertainment.user.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.ApiKey;
import springfox.documentation.service.AuthorizationScope;
import springfox.documentation.service.SecurityReference;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spi.service.contexts.SecurityContext;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger.web.UiConfiguration;
import springfox.documentation.swagger.web.UiConfigurationBuilder;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import java.util.List;

/**
 * API 문서 관련 swagger2 설정 정의.
 */
@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2).useDefaultResponseMessages(false)
                .apiInfo(getApiInfo())
                .select()
                .apis(RequestHandlerSelectors.any())
                .paths(PathSelectors.any())
                .build()
                ;
    }

    private ApiInfo getApiInfo() {
        String description = "REST API 입니다.\n 1. 원하시는 기능을 누르세요. \n" +
                "2. Try if out을 누르세요.(테스트 해본다는 의미)\n" +
                "3. 해당 인자에 원하는 값을 넣습니다.\n" +
                "4. 밑으로 내려가다보면 Execute버튼(파란 버튼)을 누르면 Responses에 결과 출력";
        return new ApiInfoBuilder()
                .title("우리끼리 예능 REST API 입니다.")
                .description(description)
                .version("1.0")
                .build();
    }

}
