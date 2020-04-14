# Exercise A.6: Setting up an HTTPS-Enabled Spring Boot Application

## Disclaimer

This exercise is entirely optional -- the upcoming exercises of this workshop will neither require the results of this exercise nor an understanding of the concepts taught therein.

## Objective
The preceding exercises A2 and A4 involved a Spring Boot application establishing connections to a small demo REST service running on an HTTPS-enabled Apache server, meaning the Spring Boot applications have acted as clients. During this exercise, on the other hand, you'll learn how to set up a Spring Boot application acting as an HTTPS-enabled backend. 

In the real world, such a setup is commonly encountered in the context of Spring-Boot based API gateways that act as SSL termination entity instead of a dedicated web server that might then pass on requests to some application landscape (think, for example, of some micro services) or even orchestrate processing flow.

## Prerequisites
