package de.tls4developers.examples.exercisea4.query;

import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Optional;

@Service
@Log4j2
public class BackendQueryService {

    private final BackendProperties backendProperties;
    private final RestTemplate restTemplate;

    @Autowired
    public BackendQueryService(BackendProperties backendProperties, RestTemplate restTemplate) {
        this.backendProperties = backendProperties;
        this.restTemplate = restTemplate;
    }

    public Optional<String> queryBackend() {

        try {
            ResponseEntity<String> responseEntity = restTemplate.getForEntity(backendProperties.getUrl(), String.class);
            if (responseEntity.getStatusCodeValue() == 200) {
                return Optional.ofNullable(responseEntity.getBody());
            }
        } catch (Exception e) {
            log.error("Something somewhere went terribly wrong upon attempt to query backend: ", e);
        }

        return Optional.empty();

    }


}
