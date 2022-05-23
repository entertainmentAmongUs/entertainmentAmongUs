package com.entertainment.user;

import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.oauth2.client.CommonOAuth2Provider;
import org.springframework.web.socket.server.standard.ServerEndpointExporter;

@SpringBootApplication
public class UserApplication {

	CommonOAuth2Provider commonOAuth2Provider;

	public static void main(String[] args) {
		SpringApplication.run(UserApplication.class, args);
	}

//	@Bean
//	public ServerEndpointExporter serverEndpointExporter() {
//		return new ServerEndpointExporter();
//	}
//
//	@Bean
//	public Jackson2JsonMessageConverter converter() {
//		return new Jackson2JsonMessageConverter();
//	}
}
