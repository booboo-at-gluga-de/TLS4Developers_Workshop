package de.tls4developers.examples.exercisea2.web;

import de.tls4developers.examples.exercisea2.data.Result;
import de.tls4developers.examples.exercisea2.query.BackendQueryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class ResultsController {

    private final BackendQueryService backendQueryService;

    @Autowired
    public ResultsController(BackendQueryService backendQueryService) {
        this.backendQueryService = backendQueryService;
    }

    @GetMapping
    public String getResult(Model model) {

        Result result = backendQueryService.queryBackend();

        model.addAttribute("resultHeader", result.getHeader());
        model.addAttribute("resultSubHeader", result.getSubHeader());
        model.addAttribute("resultDetails", result.getDetails());

        return "index";

    }

}
