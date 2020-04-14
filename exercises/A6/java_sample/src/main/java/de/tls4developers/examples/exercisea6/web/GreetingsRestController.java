package de.tls4developers.examples.exercisea6.web;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/greetings")
public class GreetingsRestController {

    @GetMapping
    public ResponseEntity<Greeting> produceGreeting(@RequestParam String name) {

        return ResponseEntity.ok(new Greeting(String.format("Hello, %s!",
                StringUtils.isEmpty(name) ? "stranger" : name)));

    }


    @AllArgsConstructor
    @Getter
    private static class Greeting {

        private final String message;

    }

}

