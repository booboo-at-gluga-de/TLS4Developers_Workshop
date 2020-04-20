package de.tls4developers.examples.exercisea2.web;

import de.tls4developers.examples.exercisea2.query.BackendQueryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Optional;

@Controller
@RequestMapping("/")
public class ResultsController {

    private final BackendQueryService backendQueryService;

    @Autowired
    public ResultsController(BackendQueryService backendQueryService) {
        this.backendQueryService = backendQueryService;
    }

    @GetMapping
    public ResponseEntity<String> getResult() {


        Optional<String> response = backendQueryService.queryBackend();

        if (response.isPresent()) {
            return ResponseEntity.ok().body(response.get());
        }

        return ResponseEntity.status(500).body("{}");

    }

}
