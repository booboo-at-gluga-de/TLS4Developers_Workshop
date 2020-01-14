package de.tls4developers.examples.exercisea4.query;

import de.tls4developers.examples.exercisea4.data.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class BackendQueryService {

    private static final String SUCCESS_HEADER = "Eureka!";
    private static final String SUCCESS_SUB_HEADER = "Query successful:";

    private static final String ERROR_HEADER = "Oh, snap!";
    private static final String ERROR_SUB_HEADER = "That hasn't worked:";

    private final RestTemplate restTemplate;

    @Value("${query-service-backend-url}")
    private String backendUrl;

    @Autowired
    public BackendQueryService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public Result queryBackend() {

        try {
            ResponseEntity<String> responseEntity = restTemplate.getForEntity(backendUrl, String.class);
            return new Result(SUCCESS_HEADER, SUCCESS_SUB_HEADER, responseEntity.getBody());
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(ERROR_HEADER, ERROR_SUB_HEADER, e.getMessage());
        }

    }


}
