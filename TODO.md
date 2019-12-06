# ToDo's within this Project

   * expiring certificates / renewal / monitoring
   * write regression tests for exercise B.3, section "If You Decide to Use CRL"
     and everything after this. These checks are not yet implemented for automated testing
     Some ideas for this already exist in solve-exercises.sh, but commented out for now
   * goss.yml: check if all the statements
     {{getEnv "DOMAIN_NAME_CHAPTER_B" "exercise.jumpingcrab.com"}}
     can be replaced by a single one, writing to a variable
   * Exercise B3: Example on how to check a certificate against a CRL
