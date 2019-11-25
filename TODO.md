# ToDo's within this Project

   * Exercise B3: Tell about OCSP Stapling
   * expiring certificates / renewal / monitoring
   * write regression tests for exercise B.3, section "If You Decide to Use CRL"
     and everything after this. These checks are not yet implemented for automated testing
     Some ideas for this already exist in solve-exercises.sh, but commented out for now
   * have a look at SSLSessionCache, might better be
     SSLSessionCache         shmcb:/run/httpd/sslcache(512000)
   * goss.yml: check if all the statements
     {{getEnv "DOMAIN_NAME_CHAPTER_B" "exercise.jumpingcrab.com"}}
     can be replaced by a single one, writing to a variable
