# ToDo's within this Project

   * Exercise B3: Tell about OCSP Stapling
   * expiring certificates / renewal / monitoring
   * write some regression test (to quickly check if everything is still working after config changes)
   * have a look at SSLSessionCache, might better be
     SSLSessionCache         shmcb:/run/httpd/sslcache(512000)
   * goss.yml: check if all the statements
     {{getEnv "DOMAIN_NAME_CHAPTER_B" "exercise.jumpingcrab.com"}}
     can be replaced by a single one, writing to a variable
