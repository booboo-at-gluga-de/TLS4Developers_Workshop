package de.tls4developers.examples.exercisea4;

import org.apache.http.client.HttpClient;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContextBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.core.io.Resource;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

import javax.net.ssl.SSLContext;
import java.io.IOException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;

@Configuration
public class MtlsEnabledRestTemplateConfiguration {

    @Value("${http.client.ssl.trust-store}")
    private Resource trustStoreResource;

    @Value("${http.client.ssl.trust-store-password}")
    private String trustStorePassword;

    @Value("${http.client.ssl.key-store}")
    private Resource keyStoreResource;

    @Value("${http.client.ssl.key-store-password}")
    private String keyStorePassword;

    @Value("${http.client.ssl.key-password}")
    private String keyPassword;

    @Profile("prd")
    @Bean
    public RestTemplate restTemplate() throws IOException, CertificateException, NoSuchAlgorithmException,
            KeyStoreException, KeyManagementException, UnrecoverableKeyException {

        SSLContext sslContext = new SSLContextBuilder()
                .loadTrustMaterial(trustStoreResource.getURL(), trustStorePassword.toCharArray())
                .setKeyStoreType("JKS")
                .loadKeyMaterial(keyStoreResource.getURL(), keyStorePassword.toCharArray(), keyPassword.toCharArray())
                .build();
        SSLConnectionSocketFactory sslConnectionSocketFactory = new SSLConnectionSocketFactory(sslContext);
        HttpClient httpClient = HttpClients
                .custom()
                .setSSLSocketFactory(sslConnectionSocketFactory)
                .build();
        HttpComponentsClientHttpRequestFactory httpComponentsClientHttpRequestFactory =
                new HttpComponentsClientHttpRequestFactory(httpClient);
        return new RestTemplate(httpComponentsClientHttpRequestFactory);

    }

    @Profile("tst")
    @Bean
    public RestTemplate dummyRestTemplate() {
        return new RestTemplate();
    }

}
