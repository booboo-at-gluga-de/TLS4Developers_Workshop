package de.tls4developers.examples.exercisea2.query;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties("backend")
@Getter
@Setter
public class BackendProperties {

    private String url;

}
