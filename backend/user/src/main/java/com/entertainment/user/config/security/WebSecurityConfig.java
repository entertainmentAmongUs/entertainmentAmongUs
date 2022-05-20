package com.entertainment.user.config.security;

import com.entertainment.user.config.security.JwtAuthenticationFilter;
import com.entertainment.user.config.security.JwtTokenProvider;
//import com.entertainment.user.entity.Role;
//import com.entertainment.user.service.CustomOAuth2UserService;
//import com.entertainment.user.service.CustomOAuth2UserService;
import com.entertainment.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@RequiredArgsConstructor
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    private final JwtTokenProvider jwtTokenProvider;

    //private final CustomOAuth2UserService customOAuth2UserService;

    // 암호화에 필요한 PasswordEncoder 를 Bean 등록합니다.
    @Bean
    public PasswordEncoder PasswordEncoder() {
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }

    //authenticationManager 를 Bean 등록합니다.
    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .oauth2Login()
                .and()
//                //.exceptionHandling()
//                //.authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED))
//                //.and()
                .httpBasic().disable()  // rest api 만을 고려하여 기본 설정은 해제하겠습니다.
                .csrf().disable()  // csrf 보안 토큰 disable처리.
//                // OAuth2를 사용할 때 세션을 사용하므로 아래의 sessionManagement는 주석처리 하였습니다.
//                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS) // 토큰 기반 인증이므로 세션 역시 사용하지 않습니다.
////
//                //.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED) // 토큰 기반 인증이므로 세션 역시 사용하지 않습니다.
//                .and()
//                .authorizeRequests()
//                .antMatchers("/api/v1/**").permitAll()
//                //.antMatchers("/googleLogin").permitAll()
//                //.anyRequest().authenticated()
//                .anyRequest().anonymous()
//
                .addFilterBefore(new JwtAuthenticationFilter(jwtTokenProvider),
                        UsernamePasswordAuthenticationFilter.class);
                //.oauth2Login().userInfoEndpoint().userService(customOAuth2UserService);
        // JwtAuthenticationFilter를 UsernamePasswordAuthenticationFilter 전에 넣는다
    }
}
